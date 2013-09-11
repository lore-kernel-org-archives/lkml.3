Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757257Ab3IKUU1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 16:20:27 -0400
Received: from smtprelay0139.hostedemail.com ([216.40.44.139]:47025 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754184Ab3IKUUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 16:20:25 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:69:355:379:541:599:800:960:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1535:1544:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2691:2828:3138:3139:3140:3141:3142:3355:3622:3865:3867:3868:3871:3872:4321:4605:5007:7652:7903:10004:10848:11026:11232:11658:11914:12043:12291:12438:12517:12519:12555:12683:12740,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: linen36_77b96823fe011
X-Filterd-Recvd-Size: 5922
Message-ID: <1378930822.4714.22.camel@joe-AO722>
Subject: Re: [PATCH] vsprintf: drop comment claiming %n is ignored
From: Joe Perches <joe@perches.com>
To: Kees Cook <keescook@chromium.org>
Cc: David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        George Spelvin <linux@horizon.com>, Jiri Kosina <jkosina@suse.cz>,
        Jan Beulich <jbeulich@suse.com>, Eldad Zack <eldad@fogrefinery.com>
Date: Wed, 11 Sep 2013 13:20:22 -0700
In-Reply-To: <CAGXu5jKRmp_Ei=ty05W3SSqQ01agEMDVMGnZCFqQ_yYbZmMSmw@mail.gmail.com>
References: <20130911193040.GA16688@www.outflux.net>
	 <1378929961.4714.21.camel@joe-AO722>
	 <CAGXu5jKRmp_Ei=ty05W3SSqQ01agEMDVMGnZCFqQ_yYbZmMSmw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-09-11 at 13:18 -0700, Kees Cook wrote:
> On Wed, Sep 11, 2013 at 1:06 PM, Joe Perches <joe@perches.com> wrote:
> > On Wed, 2013-09-11 at 12:30 -0700, Kees Cook wrote:
> >> The %n format is not ignored, so remove the incorrect comment about it.
> >
> > I think it may be better to reimplement the ignoring.
> 
> Yeah, just had a quick look, and scanf doesn't use this code at all.
> I'd much rather remove %n again instead.
> 
> > Maybe:
> > ---
> >  lib/vsprintf.c      | 18 +++++-------
> >  net/ipv4/fib_trie.c | 30 +++++++++----------
> >  net/ipv4/ping.c     | 19 ++++++------
> >  net/ipv4/tcp_ipv4.c | 84 ++++++++++++++++++++++++++---------------------------
> >  net/ipv4/udp.c      | 19 ++++++------
> >  net/phonet/socket.c | 32 ++++++++++----------
> >  net/sctp/objcnt.c   |  5 ++--
> >  7 files changed, 99 insertions(+), 108 deletions(-)
> 
> This needs fs/proc/consoles.c, nommu.c, task_mmu.c, and task_nommu.c
> added too, if I can believe my "git grep".

Yeah, just found those too.
---
 fs/proc/consoles.c   |  2 +-
 fs/proc/nommu.c      | 20 ++++++++++----------
 fs/proc/task_mmu.c   | 18 +++++++++---------
 fs/proc/task_nommu.c | 20 ++++++++++----------
 4 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/fs/proc/consoles.c b/fs/proc/consoles.c
index b701eaa..42f2bb7 100644
--- a/fs/proc/consoles.c
+++ b/fs/proc/consoles.c
@@ -47,7 +47,7 @@ static int show_console_dev(struct seq_file *m, void *v)
 			con_flags[a].name : ' ';
 	flags[a] = 0;
 
-	seq_printf(m, "%s%d%n", con->name, con->index, &len);
+	len = seq_printf(m, "%s%d", con->name, con->index);
 	len = 21 - len;
 	if (len < 1)
 		len = 1;
diff --git a/fs/proc/nommu.c b/fs/proc/nommu.c
index ccfd99b..91cfd19 100644
--- a/fs/proc/nommu.c
+++ b/fs/proc/nommu.c
@@ -50,16 +50,16 @@ static int nommu_region_show(struct seq_file *m, struct vm_region *region)
 		ino = inode->i_ino;
 	}
 
-	seq_printf(m,
-		   "%08lx-%08lx %c%c%c%c %08llx %02x:%02x %lu %n",
-		   region->vm_start,
-		   region->vm_end,
-		   flags & VM_READ ? 'r' : '-',
-		   flags & VM_WRITE ? 'w' : '-',
-		   flags & VM_EXEC ? 'x' : '-',
-		   flags & VM_MAYSHARE ? flags & VM_SHARED ? 'S' : 's' : 'p',
-		   ((loff_t)region->vm_pgoff) << PAGE_SHIFT,
-		   MAJOR(dev), MINOR(dev), ino, &len);
+	len = seq_printf(m, "%08lx-%08lx %c%c%c%c %08llx %02x:%02x %lu ",
+			 region->vm_start,
+			 region->vm_end,
+			 flags & VM_READ ? 'r' : '-',
+			 flags & VM_WRITE ? 'w' : '-',
+			 flags & VM_EXEC ? 'x' : '-',
+			 flags & VM_MAYSHARE ?
+			 flags & VM_SHARED ? 'S' : 's' : 'p',
+			 ((loff_t)region->vm_pgoff) << PAGE_SHIFT,
+			 MAJOR(dev), MINOR(dev), ino);
 
 	if (file) {
 		len = 25 + sizeof(void *) * 6 - len;
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 107d026..f84ee9f 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -286,15 +286,15 @@ show_map_vma(struct seq_file *m, struct vm_area_struct *vma, int is_pid)
 	if (stack_guard_page_end(vma, end))
 		end -= PAGE_SIZE;
 
-	seq_printf(m, "%08lx-%08lx %c%c%c%c %08llx %02x:%02x %lu %n",
-			start,
-			end,
-			flags & VM_READ ? 'r' : '-',
-			flags & VM_WRITE ? 'w' : '-',
-			flags & VM_EXEC ? 'x' : '-',
-			flags & VM_MAYSHARE ? 's' : 'p',
-			pgoff,
-			MAJOR(dev), MINOR(dev), ino, &len);
+	len = seq_printf(m, "%08lx-%08lx %c%c%c%c %08llx %02x:%02x %lu ",
+			 start,
+			 end,
+			 flags & VM_READ ? 'r' : '-',
+			 flags & VM_WRITE ? 'w' : '-',
+			 flags & VM_EXEC ? 'x' : '-',
+			 flags & VM_MAYSHARE ? 's' : 'p',
+			 pgoff,
+			 MAJOR(dev), MINOR(dev), ino);
 
 	/*
 	 * Print the dentry name for named mappings, and a
diff --git a/fs/proc/task_nommu.c b/fs/proc/task_nommu.c
index 56123a6..1d7bbe5 100644
--- a/fs/proc/task_nommu.c
+++ b/fs/proc/task_nommu.c
@@ -155,16 +155,16 @@ static int nommu_vma_show(struct seq_file *m, struct vm_area_struct *vma,
 		pgoff = (loff_t)vma->vm_pgoff << PAGE_SHIFT;
 	}
 
-	seq_printf(m,
-		   "%08lx-%08lx %c%c%c%c %08llx %02x:%02x %lu %n",
-		   vma->vm_start,
-		   vma->vm_end,
-		   flags & VM_READ ? 'r' : '-',
-		   flags & VM_WRITE ? 'w' : '-',
-		   flags & VM_EXEC ? 'x' : '-',
-		   flags & VM_MAYSHARE ? flags & VM_SHARED ? 'S' : 's' : 'p',
-		   pgoff,
-		   MAJOR(dev), MINOR(dev), ino, &len);
+	len = seq_printf(m, "%08lx-%08lx %c%c%c%c %08llx %02x:%02x %lu ",
+			 vma->vm_start,
+			 vma->vm_end,
+			 flags & VM_READ ? 'r' : '-',
+			 flags & VM_WRITE ? 'w' : '-',
+			 flags & VM_EXEC ? 'x' : '-',
+			 flags & VM_MAYSHARE ?
+			 flags & VM_SHARED ? 'S' : 's' : 'p',
+			 pgoff,
+			 MAJOR(dev), MINOR(dev), ino);
 
 	if (file) {
 		pad_len_spaces(m, len);


