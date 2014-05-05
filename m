Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978AbaEERof (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 13:44:35 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:54502 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751114AbaEERoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 13:44:34 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoEJAAfNZ1NbsEtU/2dsb2JhbABZgwarUQcBAgUBmgyBFxd0glMTHCMYgQIkE4hFAcwKhVaIfIRGAQOPGooZAYp+h3aDNjs
Date: Mon, 5 May 2014 19:44:31 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Eric Biederman <ebiederm@xmission.com>, akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] kernel/kexec.c: convert printk to pr_foo()
Message-Id: <20140505194431.42fc6d43a91a7303c1cb59f7@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ some pr_warning -> pr_warn and checkpatch warning fixes

Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 kernel/kexec.c | 69 +++++++++++++++++++++++++++-------------------------------
 1 file changed, 32 insertions(+), 37 deletions(-)

diff --git a/kernel/kexec.c b/kernel/kexec.c
index c8380ad..4d7a678 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -125,8 +125,8 @@ static struct page *kimage_alloc_page(struct kimage *image,
 				       unsigned long dest);
 
 static int do_kimage_alloc(struct kimage **rimage, unsigned long entry,
-	                    unsigned long nr_segments,
-                            struct kexec_segment __user *segments)
+			   unsigned long nr_segments,
+			   struct kexec_segment __user *segments)
 {
 	size_t segment_bytes;
 	struct kimage *image;
@@ -257,13 +257,13 @@ static int kimage_normal_alloc(struct kimage **rimage, unsigned long entry,
 	image->control_code_page = kimage_alloc_control_pages(image,
 					   get_order(KEXEC_CONTROL_PAGE_SIZE));
 	if (!image->control_code_page) {
-		printk(KERN_ERR "Could not allocate control_code_buffer\n");
+		pr_err("Could not allocate control_code_buffer\n");
 		goto out_free;
 	}
 
 	image->swap_page = kimage_alloc_control_pages(image, 0);
 	if (!image->swap_page) {
-		printk(KERN_ERR "Could not allocate swap buffer\n");
+		pr_err("Could not allocate swap buffer\n");
 		goto out_free;
 	}
 
@@ -332,7 +332,7 @@ static int kimage_crash_alloc(struct kimage **rimage, unsigned long entry,
 	image->control_code_page = kimage_alloc_control_pages(image,
 					   get_order(KEXEC_CONTROL_PAGE_SIZE));
 	if (!image->control_code_page) {
-		printk(KERN_ERR "Could not allocate control_code_buffer\n");
+		pr_err("Could not allocate control_code_buffer\n");
 		goto out_free;
 	}
 
@@ -621,8 +621,8 @@ static void kimage_terminate(struct kimage *image)
 
 #define for_each_kimage_entry(image, ptr, entry) \
 	for (ptr = &image->head; (entry = *ptr) && !(entry & IND_DONE); \
-		ptr = (entry & IND_INDIRECTION)? \
-			phys_to_virt((entry & PAGE_MASK)): ptr +1)
+		ptr = (entry & IND_INDIRECTION) ? \
+			phys_to_virt((entry & PAGE_MASK)) : ptr + 1)
 
 static void kimage_free_entry(kimage_entry_t entry)
 {
@@ -650,8 +650,7 @@ static void kimage_free(struct kimage *image)
 			 * done with it.
 			 */
 			ind = entry;
-		}
-		else if (entry & IND_SOURCE)
+		} else if (entry & IND_SOURCE)
 			kimage_free_entry(entry);
 	}
 	/* Free the final indirection page */
@@ -774,8 +773,7 @@ static struct page *kimage_alloc_page(struct kimage *image,
 			addr = old_addr;
 			page = old_page;
 			break;
-		}
-		else {
+		} else {
 			/* Place the page on the destination list I
 			 * will use it later.
 			 */
@@ -1059,7 +1057,7 @@ COMPAT_SYSCALL_DEFINE4(kexec_load, compat_ulong_t, entry,
 		return -EINVAL;
 
 	ksegments = compat_alloc_user_space(nr_segments * sizeof(out));
-	for (i=0; i < nr_segments; i++) {
+	for (i = 0; i < nr_segments; i++) {
 		result = copy_from_user(&in, &segments[i], sizeof(in));
 		if (result)
 			return -EFAULT;
@@ -1214,14 +1212,14 @@ void crash_save_cpu(struct pt_regs *regs, int cpu)
 	 * squirrelled away.  ELF notes happen to provide
 	 * all of that, so there is no need to invent something new.
 	 */
-	buf = (u32*)per_cpu_ptr(crash_notes, cpu);
+	buf = (u32 *)per_cpu_ptr(crash_notes, cpu);
 	if (!buf)
 		return;
 	memset(&prstatus, 0, sizeof(prstatus));
 	prstatus.pr_pid = current->pid;
 	elf_core_copy_kernel_regs(&prstatus.pr_reg, regs);
 	buf = append_elf_note(buf, KEXEC_CORE_NOTE_NAME, NT_PRSTATUS,
-		      	      &prstatus, sizeof(prstatus));
+			      &prstatus, sizeof(prstatus));
 	final_note(buf);
 }
 
@@ -1230,8 +1228,7 @@ static int __init crash_notes_memory_init(void)
 	/* Allocate memory for saving cpu registers. */
 	crash_notes = alloc_percpu(note_buf_t);
 	if (!crash_notes) {
-		printk("Kexec: Memory allocation for saving cpu register"
-		" states failed\n");
+		pr_warn("Kexec: Memory allocation for saving cpu register states failed\n");
 		return -ENOMEM;
 	}
 	return 0;
@@ -1253,10 +1250,10 @@ subsys_initcall(crash_notes_memory_init);
  *
  * The function returns 0 on success and -EINVAL on failure.
  */
-static int __init parse_crashkernel_mem(char 			*cmdline,
-					unsigned long long	system_ram,
-					unsigned long long	*crash_size,
-					unsigned long long	*crash_base)
+static int __init parse_crashkernel_mem(char *cmdline,
+					unsigned long long system_ram,
+					unsigned long long *crash_size,
+					unsigned long long *crash_base)
 {
 	char *cur = cmdline, *tmp;
 
@@ -1267,12 +1264,12 @@ static int __init parse_crashkernel_mem(char 			*cmdline,
 		/* get the start of the range */
 		start = memparse(cur, &tmp);
 		if (cur == tmp) {
-			pr_warning("crashkernel: Memory value expected\n");
+			pr_warn("crashkernel: Memory value expected\n");
 			return -EINVAL;
 		}
 		cur = tmp;
 		if (*cur != '-') {
-			pr_warning("crashkernel: '-' expected\n");
+			pr_warn("crashkernel: '-' expected\n");
 			return -EINVAL;
 		}
 		cur++;
@@ -1281,31 +1278,30 @@ static int __init parse_crashkernel_mem(char 			*cmdline,
 		if (*cur != ':') {
 			end = memparse(cur, &tmp);
 			if (cur == tmp) {
-				pr_warning("crashkernel: Memory "
-						"value expected\n");
+				pr_warn("crashkernel: Memory value expected\n");
 				return -EINVAL;
 			}
 			cur = tmp;
 			if (end <= start) {
-				pr_warning("crashkernel: end <= start\n");
+				pr_warn("crashkernel: end <= start\n");
 				return -EINVAL;
 			}
 		}
 
 		if (*cur != ':') {
-			pr_warning("crashkernel: ':' expected\n");
+			pr_warn("crashkernel: ':' expected\n");
 			return -EINVAL;
 		}
 		cur++;
 
 		size = memparse(cur, &tmp);
 		if (cur == tmp) {
-			pr_warning("Memory value expected\n");
+			pr_warn("Memory value expected\n");
 			return -EINVAL;
 		}
 		cur = tmp;
 		if (size >= system_ram) {
-			pr_warning("crashkernel: invalid size\n");
+			pr_warn("crashkernel: invalid size\n");
 			return -EINVAL;
 		}
 
@@ -1323,8 +1319,7 @@ static int __init parse_crashkernel_mem(char 			*cmdline,
 			cur++;
 			*crash_base = memparse(cur, &tmp);
 			if (cur == tmp) {
-				pr_warning("Memory value expected "
-						"after '@'\n");
+				pr_warn("Memory value expected after '@'\n");
 				return -EINVAL;
 			}
 		}
@@ -1336,26 +1331,26 @@ static int __init parse_crashkernel_mem(char 			*cmdline,
 /*
  * That function parses "simple" (old) crashkernel command lines like
  *
- * 	crashkernel=size[@offset]
+ *	crashkernel=size[@offset]
  *
  * It returns 0 on success and -EINVAL on failure.
  */
-static int __init parse_crashkernel_simple(char 		*cmdline,
-					   unsigned long long 	*crash_size,
-					   unsigned long long 	*crash_base)
+static int __init parse_crashkernel_simple(char *cmdline,
+					   unsigned long long *crash_size,
+					   unsigned long long *crash_base)
 {
 	char *cur = cmdline;
 
 	*crash_size = memparse(cmdline, &cur);
 	if (cmdline == cur) {
-		pr_warning("crashkernel: memory value expected\n");
+		pr_warn("crashkernel: memory value expected\n");
 		return -EINVAL;
 	}
 
 	if (*cur == '@')
 		*crash_base = memparse(cur+1, &cur);
 	else if (*cur != ' ' && *cur != '\0') {
-		pr_warning("crashkernel: unrecognized char\n");
+		pr_warn("crashkernel: unrecognized char\n");
 		return -EINVAL;
 	}
 
@@ -1683,7 +1678,7 @@ int kernel_kexec(void)
 		kexec_in_progress = true;
 		kernel_restart_prepare(NULL);
 		migrate_to_reboot_cpu();
-		printk(KERN_EMERG "Starting new kernel\n");
+		pr_emerg("Starting new kernel\n");
 		machine_shutdown();
 	}
 
-- 
1.9.1

