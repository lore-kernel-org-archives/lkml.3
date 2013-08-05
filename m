Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792Ab3HETll (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 15:41:41 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:35014 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754651Ab3HETlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 15:41:39 -0400
Message-ID: <51FFFFEB.3030907@linux.vnet.ibm.com>
Date: Tue, 06 Aug 2013 01:11:31 +0530
From: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tony Luck <tony.luck@gmail.com>
CC: "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
        "paulus@samba.org" <paulus@samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "keescook@chromium.org" <keescook@chromium.org>
Subject: Re: [PATCH 00/11] Add compression support to pstore
References: <20130715164844.1520.27771.stgit@aruna-ThinkPad-T420> <51FA3B02.7060004@linux.vnet.ibm.com> <3908561D78D1C84285E8C5FCA982C28F31CAA167@ORSMSX106.amr.corp.intel.com> <CA+8MBbLuhVDCb26ag3AH0vXrP4MXHLxS5aVn8pTi4=qL1NdR5w@mail.gmail.com> <CA+8MBbJ7x46FGC7dPSdNzf8z=fZz20w1kiNgnZr4QQB6SUELhg@mail.gmail.com> <51FFDC8B.7010909@linux.vnet.ibm.com> <CA+8MBb+1LpR+Cx=84WZT98U5eqZcm1KriUP75aCg+uSrXrb3Yw@mail.gmail.com>
In-Reply-To: <CA+8MBb+1LpR+Cx=84WZT98U5eqZcm1KriUP75aCg+uSrXrb3Yw@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------010507000307010605020108"
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080519-2674-0000-0000-00000A1D0133
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010507000307010605020108
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Tony,

On Monday 05 August 2013 11:52 PM, Tony Luck wrote:
> See attachment for what I actually applied - I think I got what you
> suggested (I added a declaration for "total_len").
>
> Forcing a panic worked some things were logged to pstore.
>
> But on reboot with your patches applied I'm still seeing a GP fault
> when pstore is mounted and we find compressed records and inflate them
> and install them into the pstore filesystem.  Here's the oops:
>
> general protection fault: 0000 [#1] SMP
> Modules linked in:
> CPU: 29 PID: 10252 Comm: mount Not tainted 3.11.0-rc3-12-g73bec18 #2
> Hardware name: Intel Corporation LH Pass ........../SVRBD-ROW_T, BIOS
> SE5C600.86B.99.99.x059.091020121352 09/10/2012
> task: ffff88082e934040 ti: ffff88082e2ec000 task.ti: ffff88082e2ec000
> RIP: 0010:[<ffffffff8126d314>]  [<ffffffff8126d314>] pstore_mkfile+0x84/0x410
> RSP: 0018:ffff88082e2edc70  EFLAGS: 00010007
> RAX: 0000000000000246 RBX: ffffffff81ca7b20 RCX: 625f6963703e373c
> RDX: 0000000000040004 RSI: 0000000000000004 RDI: ffffffff820aa7e8
> RBP: ffff88082e2edd10 R08: ffff881026a48000 R09: 0000000000000000
> R10: ffff88102d21efb8 R11: 0000000000000000 R12: ffff881026a48000
> R13: 51ffe35600000003 R14: 0000000000000000 R15: 0000000000004450
> FS:  00007fbd37a2d7e0(0000) GS:ffff88103fca0000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fbd37a47000 CR3: 000000103dc78000 CR4: 00000000000407e0
> Stack:
>   ffff881026a4c450 0000000000005227 ffffffff81a3703d ffff881026a48000
>   2e2edd7000000000 ffff88103db34140 000000000001abaf 3638303900000000
>   0000003a00000fb8 ffff881026a48000 ffff88102d21e000 000000000000448a
> Call Trace:
>   [<ffffffff8126dd7d>] pstore_get_records+0xed/0x2c0
>   [<ffffffff8126cfa0>] ? pstore_get_inode+0x50/0x50
>   [<ffffffff8126d042>] pstore_fill_super+0xa2/0xc0
>   [<ffffffff811691f2>] mount_single+0xa2/0xd0
>   [<ffffffff8126ce28>] pstore_mount+0x18/0x20
>   [<ffffffff811693e3>] mount_fs+0x43/0x1b0
>   [<ffffffff8112dc40>] ? __alloc_percpu+0x10/0x20
>   [<ffffffff8118256f>] vfs_kern_mount+0x6f/0x100
>   [<ffffffff81184a79>] do_mount+0x259/0xa10
>   [<ffffffff81128bcb>] ? strndup_user+0x5b/0x80
>   [<ffffffff811852be>] SyS_mount+0x8e/0xe0
>   [<ffffffff81606802>] system_call_fastpath+0x16/0x1b
> Code: 88 e8 f1 0f 39 00 48 8b 0d 0a 3a a2 00 48 81 f9 00 0d c9 81 75
> 15 eb 67 0f 1f 80 00 00 00 00 48 8b 09 48 81 f9 00 0d c9 81 74 54 <44>
> 39 71 18 75 ee 4c 39 69 20 75 e8 48 39 59 10 75 e2 48 89 c6
> RIP  [<ffffffff8126d314>] pstore_mkfile+0x84/0x410
>   RSP <ffff88082e2edc70>
> ---[ end trace 0e1dd8e3ccfa3dcc ]---
> /etc/init.d/functions: line 530: 10252 Segmentation fault      "$@"
>
> Here's the start of my pstore_mkfile() code where the GP fault occurred:
>
> ffffffff8126d290 <pstore_mkfile>:
> ffffffff8126d290:       e8 2b 91 39 00          callq
> ffffffff816063c0 <__fentry__>
> ffffffff8126d295:       55                      push   %rbp
> ffffffff8126d296:       48 89 e5                mov    %rsp,%rbp
> ffffffff8126d299:       41 57                   push   %r15
> ffffffff8126d29b:       41 56                   push   %r14
> ffffffff8126d29d:       41 89 fe                mov    %edi,%r14d
> ffffffff8126d2a0:       48 c7 c7 e8 a7 0a 82    mov    $0xffffffff820aa7e8,%rdi
> ffffffff8126d2a7:       41 55                   push   %r13
> ffffffff8126d2a9:       49 89 d5                mov    %rdx,%r13
> ffffffff8126d2ac:       41 54                   push   %r12
> ffffffff8126d2ae:       53                      push   %rbx
> ffffffff8126d2af:       48 83 ec 78             sub    $0x78,%rsp
> ffffffff8126d2b3:       89 4d 84                mov    %ecx,-0x7c(%rbp)
> ffffffff8126d2b6:       48 89 b5 70 ff ff ff    mov    %rsi,-0x90(%rbp)
> ffffffff8126d2bd:       65 48 8b 04 25 28 00    mov    %gs:0x28,%rax
> ffffffff8126d2c4:       00 00
> ffffffff8126d2c6:       48 89 45 d0             mov    %rax,-0x30(%rbp)
> ffffffff8126d2ca:       31 c0                   xor    %eax,%eax
> ffffffff8126d2cc:       48 8b 05 0d d5 e3 00    mov
> 0xe3d50d(%rip),%rax        # ffffffff820aa7e0 <pstore_sb>
> ffffffff8126d2d3:       4c 89 85 78 ff ff ff    mov    %r8,-0x88(%rbp)
> ffffffff8126d2da:       44 89 4d 80             mov    %r9d,-0x80(%rbp)
> ffffffff8126d2de:       48 8b 5d 28             mov    0x28(%rbp),%rbx
> ffffffff8126d2e2:       48 8b 40 60             mov    0x60(%rax),%rax
> ffffffff8126d2e6:       48 89 45 88             mov    %rax,-0x78(%rbp)
> ffffffff8126d2ea:       e8 f1 0f 39 00          callq
> ffffffff815fe2e0 <_raw_spin_lock_irqsave>
> ffffffff8126d2ef:       48 8b 0d 0a 3a a2 00    mov
> 0xa23a0a(%rip),%rcx        # ffffffff81c90d00 <allpstore>
> ffffffff8126d2f6:       48 81 f9 00 0d c9 81    cmp    $0xffffffff81c90d00,%rcx
> ffffffff8126d2fd:       75 15                   jne
> ffffffff8126d314 <pstore_mkfile+0x84>
> ffffffff8126d2ff:       eb 67                   jmp
> ffffffff8126d368 <pstore_mkfile+0xd8>
> ffffffff8126d301:       0f 1f 80 00 00 00 00    nopl   0x0(%rax)
> ffffffff8126d308:       48 8b 09                mov    (%rcx),%rcx
> ffffffff8126d30b:       48 81 f9 00 0d c9 81    cmp    $0xffffffff81c90d00,%rcx
> ffffffff8126d312:       74 54                   je
> ffffffff8126d368 <pstore_mkfile+0xd8>
> ffffffff8126d314:       44 39 71 18             cmp
> %r14d,0x18(%rcx)   <<<<<<<<<< GP fault here
> ffffffff8126d318:       75 ee                   jne
> ffffffff8126d308 <pstore_mkfile+0x78>
> ffffffff8126d31a:       4c 39 69 20             cmp    %r13,0x20(%rcx)
> ffffffff8126d31e:       75 e8                   jne
> ffffffff8126d308 <pstore_mkfile+0x78>
> ffffffff8126d320:       48 39 59 10             cmp    %rbx,0x10(%rcx)
> ffffffff8126d324:       75 e2                   jne
> ffffffff8126d308 <pstore_mkfile+0x78>
> ffffffff8126d326:       48 89 c6                mov    %rax,%rsi
> ffffffff8126d329:       48 c7 c7 e8 a7 0a 82    mov    $0xffffffff820aa7e8,%rdi
> ffffffff8126d330:       e8 1b 0d 39 00          callq
> ffffffff815fe050 <_raw_spin_unlock_irqrestore>
>
> Booting a vanilla v3.11-rc4 kernel I can see the files pstore - but
> they still seem to have
> corruption/missing data at the end when I decode with openssl zlib -d :-(
>
> So start by peering at the path that I applied to make sure I didn't mess up.

Strangely I am not ablereproduce this on power or on system-x. With system-x I was
able to loga single record and decompression did not give me any junk characters 
at the
end. Not sure if its the header which is missing.If it was I should have encountered
same issue on Power too. Please give a final try with the patch I have attached 
and I
will dig into this more tomorrow. Patch to be applied on top of my patch series
(without your fix patch).


- Aruna
>
> -Tony


--------------010507000307010605020108
Content-Type: text/x-patch;
 name="pstore_fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="pstore_fix.patch"

commit 35b489152ae8f673fa79e7eeffc0bc8503c608b6
Author: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
Date:   Tue Aug 6 00:08:35 2013 +0530

    pstore: fix for the junk characters at the end
    
    Signed-off-by: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>

diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index 8f3e5f0..3446c99 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -283,7 +283,7 @@ static void pstore_dump(struct kmsg_dumper *dumper,
 		unsigned long size, big_buf_sz;
 		int hsize = 0;
 		int zipped_len = -1;
-		size_t len;
+		size_t len, total_len;
 		bool compressed;
 
 		big_buf_sz = (psinfo->bufsize * 100) / 45;
@@ -293,9 +293,8 @@ static void pstore_dump(struct kmsg_dumper *dumper,
 			hsize = sprintf(dst, "%s#%d Part%d\n", why,
 							oopscount, part);
 			size = big_buf_sz - hsize;
-			dst += hsize;
 
-			if (!kmsg_dump_get_buffer(dumper, true, dst,
+			if (!kmsg_dump_get_buffer(dumper, true, dst + hsize,
 								size, &len))
 				break;
 
@@ -313,17 +312,18 @@ static void pstore_dump(struct kmsg_dumper *dumper,
 			if (!kmsg_dump_get_buffer(dumper, true, dst,
 								size, &len))
 				break;
+			total_len = hsize + len;
 		} else {
 			compressed = true;
-			len = zipped_len;
+			total_len = zipped_len;
 		}
 
 		ret = psinfo->write(PSTORE_TYPE_DMESG, reason, &id, part,
-				    oopscount, compressed, hsize + len, psinfo);
+				    oopscount, compressed, total_len, psinfo);
 		if (ret == 0 && reason == KMSG_DUMP_OOPS && pstore_is_mounted())
 			pstore_new_entry = 1;
 
-		total += hsize + len;
+		total += total_len;
 		part++;
 	}
 	if (pstore_cannot_block_path(reason)) {

--------------010507000307010605020108--

