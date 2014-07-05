Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225AbaGEJIA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 05:08:00 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:59961 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754319AbaGEJHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 05:07:53 -0400
Date: Sat, 5 Jul 2014 12:07:45 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] headers: remove fs.h from poll.h
Message-ID: <20140705090745.GA13990@p183.telecom.by>
References: <20140701200150.GA31103@p183.telecom.by>
 <20140701134338.1d221dd127ffef4c25e86800@linux-foundation.org>
 <20140701220642.GA3150@p183.telecom.by>
 <alpine.DEB.2.02.1407021605490.5931@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="u3/rZRmxL6MmkK24"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1407021605490.5931@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 02, 2014 at 04:09:17PM -0700, David Rientjes wrote:
> Lots of #ifdefs in fs.h, I hope your series includes building for all 
> possible combinations.

If google can donate 1 million of cpu hours to me, then yeah :-)

> > This is first patch in series. Same thing we did with sched.h earlier.
> > 
> 
> Is it possible to post the whole series together so it makes sense and 
> it's possible to put it through some thorough build testing?  If you can 
> point me to a git tree that I can pull, then I can do that on 
> infrastructure that I have probably quicker than most.

Sure, attached.

My compile test farm is kinda rotten right now, so any help is appreciated.

Compile tested on x86_64 and lightly on arm.

--u3/rZRmxL6MmkK24
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-headers-proc_fs.h.patch"

>From 28e18cbfcb31131ae67792d7de8f97012ae3bcc3 Mon Sep 17 00:00:00 2001
From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Fri, 20 Jun 2014 23:55:48 +0300
Subject: [PATCH 01/12] headers: -proc_fs.h

---
 drivers/acpi/apei/erst-dbg.c        | 1 +
 drivers/char/ipmi/ipmi_si_intf.c    | 1 +
 drivers/ide/ide-cd.c                | 1 +
 drivers/ide/ide-disk_proc.c         | 1 +
 drivers/ide/ide-floppy_proc.c       | 1 +
 drivers/ide/ide-tape.c              | 1 +
 drivers/platform/x86/dell-smo8800.c | 1 +
 drivers/staging/panel/panel.c       | 1 +
 drivers/staging/rtl8192ee/debug.c   | 2 ++
 drivers/staging/rtl8821ae/debug.c   | 2 ++
 fs/nfs/client.c                     | 1 +
 fs/nfsd/export.h                    | 1 +
 fs/nfsd/netns.h                     | 1 +
 fs/nfsd/nfsctl.c                    | 1 +
 fs/nfsd/nfsfh.h                     | 1 +
 fs/nfsd/stats.c                     | 1 +
 include/acpi/acpi_bus.h             | 2 +-
 include/linux/atmdev.h              | 2 +-
 include/linux/crash_dump.h          | 1 -
 include/linux/efi.h                 | 1 -
 include/linux/ide.h                 | 2 +-
 include/linux/ipmi.h                | 1 -
 include/linux/ipmi_smi.h            | 1 -
 include/linux/parport.h             | 1 -
 include/linux/posix_acl.h           | 1 +
 include/linux/sunrpc/cache.h        | 3 ++-
 include/linux/sunrpc/rpc_pipe_fs.h  | 1 +
 include/linux/sunrpc/stats.h        | 2 +-
 include/net/netns/netfilter.h       | 2 +-
 include/net/sctp/sctp.h             | 1 -
 net/atm/br2684.c                    | 1 +
 net/netfilter/nf_synproxy_core.c    | 1 +
 net/sctp/objcnt.c                   | 1 +
 net/sctp/proc.c                     | 1 +
 net/sctp/protocol.c                 | 1 +
 net/sunrpc/auth_gss/svcauth_gss.c   | 1 +
 36 files changed, 33 insertions(+), 12 deletions(-)

diff --git a/drivers/acpi/apei/erst-dbg.c b/drivers/acpi/apei/erst-dbg.c
index 04ab5c9..a080011 100644
--- a/drivers/acpi/apei/erst-dbg.c
+++ b/drivers/acpi/apei/erst-dbg.c
@@ -23,6 +23,7 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
 
+#include <linux/fs.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/uaccess.h>
diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index 5d66568..9347146 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -50,6 +50,7 @@
 #include <linux/delay.h>
 #include <linux/list.h>
 #include <linux/pci.h>
+#include <linux/proc_fs.h>
 #include <linux/ioport.h>
 #include <linux/notifier.h>
 #include <linux/mutex.h>
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 0b510ba..503de27 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -30,6 +30,7 @@
 #include <linux/kernel.h>
 #include <linux/delay.h>
 #include <linux/timer.h>
+#include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
diff --git a/drivers/ide/ide-disk_proc.c b/drivers/ide/ide-disk_proc.c
index 0d1fae6..39f6f42 100644
--- a/drivers/ide/ide-disk_proc.c
+++ b/drivers/ide/ide-disk_proc.c
@@ -2,6 +2,7 @@
 #include <linux/ide.h>
 #include <linux/slab.h>
 #include <linux/export.h>
+#include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 
 #include "ide-disk.h"
diff --git a/drivers/ide/ide-floppy_proc.c b/drivers/ide/ide-floppy_proc.c
index e7a25ea..cd05445 100644
--- a/drivers/ide/ide-floppy_proc.c
+++ b/drivers/ide/ide-floppy_proc.c
@@ -1,6 +1,7 @@
 #include <linux/kernel.h>
 #include <linux/export.h>
 #include <linux/ide.h>
+#include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 
 #include "ide-floppy.h"
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 1793aea..775c95c 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -31,6 +31,7 @@
 #include <linux/major.h>
 #include <linux/errno.h>
 #include <linux/genhd.h>
+#include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/slab.h>
 #include <linux/pci.h>
diff --git a/drivers/platform/x86/dell-smo8800.c b/drivers/platform/x86/dell-smo8800.c
index a653716..8c26c6e 100644
--- a/drivers/platform/x86/dell-smo8800.c
+++ b/drivers/platform/x86/dell-smo8800.c
@@ -19,6 +19,7 @@
 
 #define DRIVER_NAME "smo8800"
 
+#include <linux/fs.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/acpi.h>
diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
index 4e92293..03fbb8e 100644
--- a/drivers/staging/panel/panel.c
+++ b/drivers/staging/panel/panel.c
@@ -36,6 +36,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/fs.h>
 #include <linux/module.h>
 
 #include <linux/types.h>
diff --git a/drivers/staging/rtl8192ee/debug.c b/drivers/staging/rtl8192ee/debug.c
index feec394..73c1407 100644
--- a/drivers/staging/rtl8192ee/debug.c
+++ b/drivers/staging/rtl8192ee/debug.c
@@ -23,6 +23,8 @@
  *
  *****************************************************************************/
 
+#include <linux/proc_fs.h>
+
 #include "wifi.h"
 #include "cam.h"
 
diff --git a/drivers/staging/rtl8821ae/debug.c b/drivers/staging/rtl8821ae/debug.c
index 8aefbf1..727276e 100644
--- a/drivers/staging/rtl8821ae/debug.c
+++ b/drivers/staging/rtl8821ae/debug.c
@@ -27,6 +27,8 @@
  *
  *****************************************************************************/
 
+#include <linux/proc_fs.h>
+
 #include "wifi.h"
 #include "cam.h"
 
diff --git a/fs/nfs/client.c b/fs/nfs/client.c
index 1d09289..ca55cfd 100644
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -12,6 +12,7 @@
 
 #include <linux/module.h>
 #include <linux/init.h>
+#include <linux/proc_fs.h>
 #include <linux/sched.h>
 #include <linux/time.h>
 #include <linux/kernel.h>
diff --git a/fs/nfsd/export.h b/fs/nfsd/export.h
index cfeea85..a4ff95f 100644
--- a/fs/nfsd/export.h
+++ b/fs/nfsd/export.h
@@ -4,6 +4,7 @@
 #ifndef NFSD_EXPORT_H
 #define NFSD_EXPORT_H
 
+#include <linux/path.h>
 #include <linux/sunrpc/cache.h>
 #include <uapi/linux/nfsd/export.h>
 
diff --git a/fs/nfsd/netns.h b/fs/nfsd/netns.h
index d32b3aa..5bd5dcd 100644
--- a/fs/nfsd/netns.h
+++ b/fs/nfsd/netns.h
@@ -21,6 +21,7 @@
 #ifndef __NFSD_NETNS_H__
 #define __NFSD_NETNS_H__
 
+#include <linux/fs.h>
 #include <net/net_namespace.h>
 #include <net/netns/generic.h>
 
diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index 5184404..d173ce9 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -4,6 +4,7 @@
  * Copyright (C) 1995, 1996 Olaf Kirch <okir@monad.swb.de>
  */
 
+#include <linux/proc_fs.h>
 #include <linux/slab.h>
 #include <linux/namei.h>
 #include <linux/ctype.h>
diff --git a/fs/nfsd/nfsfh.h b/fs/nfsd/nfsfh.h
index 2e89e70..02e9d73 100644
--- a/fs/nfsd/nfsfh.h
+++ b/fs/nfsd/nfsfh.h
@@ -7,6 +7,7 @@
 #ifndef _LINUX_NFSD_NFSFH_H
 #define _LINUX_NFSD_NFSFH_H
 
+#include <linux/fs.h>
 #include <linux/sunrpc/svc.h>
 #include <uapi/linux/nfsd/nfsfh.h>
 
diff --git a/fs/nfsd/stats.c b/fs/nfsd/stats.c
index cd90878..592d972 100644
--- a/fs/nfsd/stats.c
+++ b/fs/nfsd/stats.c
@@ -21,6 +21,7 @@
  * Copyright (C) 1995, 1996, 1997 Olaf Kirch <okir@monad.swb.de>
  */
 
+#include <linux/fs.h>
 #include <linux/seq_file.h>
 #include <linux/module.h>
 #include <linux/sunrpc/stats.h>
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index b571458..2644217 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -92,7 +92,7 @@ acpi_evaluate_dsm_typed(acpi_handle handle, const u8 *uuid, int rev, int func,
 
 #ifdef CONFIG_ACPI
 
-#include <linux/proc_fs.h>
+struct proc_dir_entry;
 
 #define ACPI_BUS_FILE_ROOT	"acpi"
 extern struct proc_dir_entry *acpi_root_dir;
diff --git a/include/linux/atmdev.h b/include/linux/atmdev.h
index c1da539..96665e3 100644
--- a/include/linux/atmdev.h
+++ b/include/linux/atmdev.h
@@ -14,7 +14,7 @@
 #include <uapi/linux/atmdev.h>
 
 #ifdef CONFIG_PROC_FS
-#include <linux/proc_fs.h>
+struct proc_dir_entry;
 
 extern struct proc_dir_entry *atm_proc_root;
 #endif
diff --git a/include/linux/crash_dump.h b/include/linux/crash_dump.h
index 72ab536..f07e2a3 100644
--- a/include/linux/crash_dump.h
+++ b/include/linux/crash_dump.h
@@ -3,7 +3,6 @@
 
 #ifdef CONFIG_CRASH_DUMP
 #include <linux/kexec.h>
-#include <linux/proc_fs.h>
 #include <linux/elf.h>
 
 #include <asm/pgtable.h> /* for pgprot_t */
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 41bbf8b..76a6954 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -15,7 +15,6 @@
 #include <linux/string.h>
 #include <linux/time.h>
 #include <linux/types.h>
-#include <linux/proc_fs.h>
 #include <linux/rtc.h>
 #include <linux/ioport.h>
 #include <linux/pfn.h>
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 93b5ca7..8316575 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -10,7 +10,6 @@
 #include <linux/ioport.h>
 #include <linux/ata.h>
 #include <linux/blkdev.h>
-#include <linux/proc_fs.h>
 #include <linux/interrupt.h>
 #include <linux/bitops.h>
 #include <linux/bio.h>
@@ -38,6 +37,7 @@
 #define ERROR_RECAL	1	/* Recalibrate every 2nd retry */
 
 struct device;
+struct proc_dir_entry;
 
 /* Error codes returned in rq->errors to the higher part of the driver. */
 enum {
diff --git a/include/linux/ipmi.h b/include/linux/ipmi.h
index 76d2acb..30b91f1 100644
--- a/include/linux/ipmi.h
+++ b/include/linux/ipmi.h
@@ -36,7 +36,6 @@
 #include <uapi/linux/ipmi.h>
 
 #include <linux/list.h>
-#include <linux/proc_fs.h>
 
 struct module;
 struct device;
diff --git a/include/linux/ipmi_smi.h b/include/linux/ipmi_smi.h
index bd34924..7a5e587 100644
--- a/include/linux/ipmi_smi.h
+++ b/include/linux/ipmi_smi.h
@@ -35,7 +35,6 @@
 #define __LINUX_IPMI_SMI_H
 
 #include <linux/ipmi_msgdefs.h>
-#include <linux/proc_fs.h>
 #include <linux/platform_device.h>
 #include <linux/ipmi.h>
 
diff --git a/include/linux/parport.h b/include/linux/parport.h
index c22f125..72498ad 100644
--- a/include/linux/parport.h
+++ b/include/linux/parport.h
@@ -8,7 +8,6 @@
 
 
 #include <linux/jiffies.h>
-#include <linux/proc_fs.h>
 #include <linux/spinlock.h>
 #include <linux/wait.h>
 #include <linux/irqreturn.h>
diff --git a/include/linux/posix_acl.h b/include/linux/posix_acl.h
index 3e96a6a..119d51a 100644
--- a/include/linux/posix_acl.h
+++ b/include/linux/posix_acl.h
@@ -9,6 +9,7 @@
 #define __LINUX_POSIX_ACL_H
 
 #include <linux/bug.h>
+#include <linux/fs.h>
 #include <linux/slab.h>
 #include <linux/rcupdate.h>
 
diff --git a/include/linux/sunrpc/cache.h b/include/linux/sunrpc/cache.h
index 437ddb6..0eb89f5 100644
--- a/include/linux/sunrpc/cache.h
+++ b/include/linux/sunrpc/cache.h
@@ -16,7 +16,8 @@
 #include <linux/kref.h>
 #include <linux/slab.h>
 #include <linux/atomic.h>
-#include <linux/proc_fs.h>
+
+struct proc_dir_entry;
 
 /*
  * Each cache requires:
diff --git a/include/linux/sunrpc/rpc_pipe_fs.h b/include/linux/sunrpc/rpc_pipe_fs.h
index 7f490be..0e21303 100644
--- a/include/linux/sunrpc/rpc_pipe_fs.h
+++ b/include/linux/sunrpc/rpc_pipe_fs.h
@@ -3,6 +3,7 @@
 
 #ifdef __KERNEL__
 
+#include <linux/fs.h>
 #include <linux/workqueue.h>
 
 struct rpc_pipe_dir_head {
diff --git a/include/linux/sunrpc/stats.h b/include/linux/sunrpc/stats.h
index edc6421..349946d 100644
--- a/include/linux/sunrpc/stats.h
+++ b/include/linux/sunrpc/stats.h
@@ -9,7 +9,7 @@
 #ifndef _LINUX_SUNRPC_STATS_H
 #define _LINUX_SUNRPC_STATS_H
 
-#include <linux/proc_fs.h>
+struct proc_dir_entry;
 
 struct rpc_stat {
 	const struct rpc_program *program;
diff --git a/include/net/netns/netfilter.h b/include/net/netns/netfilter.h
index 8874002..a50f814f 100644
--- a/include/net/netns/netfilter.h
+++ b/include/net/netns/netfilter.h
@@ -1,10 +1,10 @@
 #ifndef __NETNS_NETFILTER_H
 #define __NETNS_NETFILTER_H
 
-#include <linux/proc_fs.h>
 #include <linux/netfilter.h>
 
 struct nf_logger;
+struct proc_dir_entry;
 
 struct netns_nf {
 #if defined CONFIG_PROC_FS
diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index 8e4de46..cf0109b 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -59,7 +59,6 @@
 #include <linux/slab.h>
 #include <linux/in.h>
 #include <linux/tty.h>
-#include <linux/proc_fs.h>
 #include <linux/spinlock.h>
 #include <linux/jiffies.h>
 #include <linux/idr.h>
diff --git a/net/atm/br2684.c b/net/atm/br2684.c
index 403e71f..4c161fd 100644
--- a/net/atm/br2684.c
+++ b/net/atm/br2684.c
@@ -18,6 +18,7 @@
 #include <linux/rtnetlink.h>
 #include <linux/ip.h>
 #include <linux/uaccess.h>
+#include <linux/proc_fs.h>
 #include <linux/slab.h>
 #include <net/arp.h>
 #include <linux/atm.h>
diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synproxy_core.c
index 52e20c9..321dd9e 100644
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/proc_fs.h>
 #include <linux/skbuff.h>
 #include <asm/unaligned.h>
 #include <net/tcp.h>
diff --git a/net/sctp/objcnt.c b/net/sctp/objcnt.c
index 40e7fac..cf6317e 100644
--- a/net/sctp/objcnt.c
+++ b/net/sctp/objcnt.c
@@ -34,6 +34,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/kernel.h>
+#include <linux/proc_fs.h>
 #include <net/sctp/sctp.h>
 
 /*
diff --git a/net/sctp/proc.c b/net/sctp/proc.c
index 34229ee..09d65f9 100644
--- a/net/sctp/proc.c
+++ b/net/sctp/proc.c
@@ -28,6 +28,7 @@
  */
 
 #include <linux/types.h>
+#include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/init.h>
 #include <linux/export.h>
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index 6789d785..030b855 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -45,6 +45,7 @@
 #include <linux/init.h>
 #include <linux/netdevice.h>
 #include <linux/inetdevice.h>
+#include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/bootmem.h>
 #include <linux/highmem.h>
diff --git a/net/sunrpc/auth_gss/svcauth_gss.c b/net/sunrpc/auth_gss/svcauth_gss.c
index 4ce5ecce..fbb4c32 100644
--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -41,6 +41,7 @@
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/pagemap.h>
+#include <linux/proc_fs.h>
 #include <linux/user_namespace.h>
 
 #include <linux/sunrpc/auth_gss.h>
-- 
1.8.5.5


--u3/rZRmxL6MmkK24
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0002-headers-fs.h-vs-poll.h.patch"

>From 31204c8df760b28bec06d168d61d9786cd90f450 Mon Sep 17 00:00:00 2001
From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Sat, 21 Jun 2014 00:38:23 +0300
Subject: [PATCH 02/12] headers: fs.h vs poll.h

---
 drivers/char/ipmi/ipmi_watchdog.c           | 1 +
 drivers/char/ppdev.c                        | 1 +
 drivers/gpu/vga/vgaarb.c                    | 1 +
 drivers/input/serio/serio_raw.c             | 1 +
 drivers/misc/mic/host/mic_fops.c            | 1 +
 drivers/platform/goldfish/goldfish_pipe.c   | 1 +
 drivers/pps/pps.c                           | 1 +
 drivers/rtc/interface.c                     | 1 +
 drivers/rtc/rtc-dev.c                       | 1 +
 drivers/staging/comedi/drivers/serial2002.c | 1 +
 drivers/vfio/pci/vfio_pci_intrs.c           | 1 +
 include/linux/poll.h                        | 2 +-
 include/sound/pcm.h                         | 1 +
 sound/core/control.c                        | 1 +
 sound/core/hwdep.c                          | 1 +
 sound/core/init.c                           | 1 +
 sound/core/oss/mixer_oss.c                  | 1 +
 sound/core/rawmidi.c                        | 1 +
 sound/core/seq/oss/seq_oss.c                | 1 +
 sound/core/seq/oss/seq_oss_init.c           | 1 +
 sound/core/sound.c                          | 1 +
 sound/core/timer.c                          | 1 +
 22 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/char/ipmi/ipmi_watchdog.c b/drivers/char/ipmi/ipmi_watchdog.c
index 37b8be7..e96f3c4 100644
--- a/drivers/char/ipmi/ipmi_watchdog.c
+++ b/drivers/char/ipmi/ipmi_watchdog.c
@@ -31,6 +31,7 @@
  *  675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#include <linux/fs.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/ipmi.h>
diff --git a/drivers/char/ppdev.c b/drivers/char/ppdev.c
index ae0b42b..3964887 100644
--- a/drivers/char/ppdev.c
+++ b/drivers/char/ppdev.c
@@ -56,6 +56,7 @@
  * Added GETFLAGS/SETFLAGS ioctls, Fred Barnes, 04/2001
  */
 
+#include <linux/fs.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/sched.h>
diff --git a/drivers/gpu/vga/vgaarb.c b/drivers/gpu/vga/vgaarb.c
index af02597..158741b 100644
--- a/drivers/gpu/vga/vgaarb.c
+++ b/drivers/gpu/vga/vgaarb.c
@@ -29,6 +29,7 @@
  *
  */
 
+#include <linux/fs.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/pci.h>
diff --git a/drivers/input/serio/serio_raw.c b/drivers/input/serio/serio_raw.c
index c9a02fe..bf9a51b 100644
--- a/drivers/input/serio/serio_raw.c
+++ b/drivers/input/serio/serio_raw.c
@@ -9,6 +9,7 @@
  * the Free Software Foundation.
  */
 
+#include <linux/fs.h>
 #include <linux/kref.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
diff --git a/drivers/misc/mic/host/mic_fops.c b/drivers/misc/mic/host/mic_fops.c
index 85776d7..a6e621c 100644
--- a/drivers/misc/mic/host/mic_fops.c
+++ b/drivers/misc/mic/host/mic_fops.c
@@ -18,6 +18,7 @@
  * Intel MIC Host driver.
  *
  */
+#include <linux/fs.h>
 #include <linux/poll.h>
 #include <linux/pci.h>
 
diff --git a/drivers/platform/goldfish/goldfish_pipe.c b/drivers/platform/goldfish/goldfish_pipe.c
index d9a09d9..305db89 100644
--- a/drivers/platform/goldfish/goldfish_pipe.c
+++ b/drivers/platform/goldfish/goldfish_pipe.c
@@ -45,6 +45,7 @@
  * exchange is properly mapped during a transfer.
  */
 
+#include <linux/fs.h>
 #include <linux/module.h>
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
diff --git a/drivers/pps/pps.c b/drivers/pps/pps.c
index 2f07cd6..f39a069 100644
--- a/drivers/pps/pps.c
+++ b/drivers/pps/pps.c
@@ -21,6 +21,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/fs.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
index 5813fa5..17e19a5 100644
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -11,6 +11,7 @@
  * published by the Free Software Foundation.
 */
 
+#include <linux/fs.h>
 #include <linux/rtc.h>
 #include <linux/sched.h>
 #include <linux/module.h>
diff --git a/drivers/rtc/rtc-dev.c b/drivers/rtc/rtc-dev.c
index d049393..28d49f5 100644
--- a/drivers/rtc/rtc-dev.c
+++ b/drivers/rtc/rtc-dev.c
@@ -13,6 +13,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/fs.h>
 #include <linux/module.h>
 #include <linux/rtc.h>
 #include <linux/sched.h>
diff --git a/drivers/staging/comedi/drivers/serial2002.c b/drivers/staging/comedi/drivers/serial2002.c
index 441813f..6d32a5c 100644
--- a/drivers/staging/comedi/drivers/serial2002.c
+++ b/drivers/staging/comedi/drivers/serial2002.c
@@ -26,6 +26,7 @@ Status: in development
 
 */
 
+#include <linux/fs.h>
 #include <linux/module.h>
 #include "../comedidev.h"
 
diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 9dd49c9..00f8eb9 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -14,6 +14,7 @@
  */
 
 #include <linux/device.h>
+#include <linux/fs.h>
 #include <linux/interrupt.h>
 #include <linux/eventfd.h>
 #include <linux/pci.h>
diff --git a/include/linux/poll.h b/include/linux/poll.h
index c08386f..a1f2c6e 100644
--- a/include/linux/poll.h
+++ b/include/linux/poll.h
@@ -6,7 +6,6 @@
 #include <linux/ktime.h>
 #include <linux/wait.h>
 #include <linux/string.h>
-#include <linux/fs.h>
 #include <linux/sysctl.h>
 #include <asm/uaccess.h>
 #include <uapi/linux/poll.h>
@@ -23,6 +22,7 @@ extern struct ctl_table epoll_table[]; /* for sysctl */
 
 #define DEFAULT_POLLMASK (POLLIN | POLLOUT | POLLRDNORM | POLLWRNORM)
 
+struct file;
 struct poll_table_struct;
 
 /* 
diff --git a/include/sound/pcm.h b/include/sound/pcm.h
index d854fb3..c150d9f 100644
--- a/include/sound/pcm.h
+++ b/include/sound/pcm.h
@@ -26,6 +26,7 @@
 #include <sound/asound.h>
 #include <sound/memalloc.h>
 #include <sound/minors.h>
+#include <linux/fs.h>
 #include <linux/poll.h>
 #include <linux/mm.h>
 #include <linux/bitops.h>
diff --git a/sound/core/control.c b/sound/core/control.c
index f0b0e14..01071ef 100644
--- a/sound/core/control.c
+++ b/sound/core/control.c
@@ -19,6 +19,7 @@
  *
  */
 
+#include <linux/fs.h>
 #include <linux/threads.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
diff --git a/sound/core/hwdep.c b/sound/core/hwdep.c
index 69459e5..543174b 100644
--- a/sound/core/hwdep.c
+++ b/sound/core/hwdep.c
@@ -19,6 +19,7 @@
  *
  */
 
+#include <linux/fs.h>
 #include <linux/major.h>
 #include <linux/init.h>
 #include <linux/slab.h>
diff --git a/sound/core/init.c b/sound/core/init.c
index 7bdfd19..78321e7 100644
--- a/sound/core/init.c
+++ b/sound/core/init.c
@@ -19,6 +19,7 @@
  *
  */
 
+#include <linux/fs.h>
 #include <linux/init.h>
 #include <linux/sched.h>
 #include <linux/module.h>
diff --git a/sound/core/oss/mixer_oss.c b/sound/core/oss/mixer_oss.c
index 5e6349f..60ac476 100644
--- a/sound/core/oss/mixer_oss.c
+++ b/sound/core/oss/mixer_oss.c
@@ -19,6 +19,7 @@
  *
  */
 
+#include <linux/fs.h>
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/time.h>
diff --git a/sound/core/rawmidi.c b/sound/core/rawmidi.c
index 6fc71a4..656f6c6 100644
--- a/sound/core/rawmidi.c
+++ b/sound/core/rawmidi.c
@@ -20,6 +20,7 @@
  */
 
 #include <sound/core.h>
+#include <linux/fs.h>
 #include <linux/major.h>
 #include <linux/init.h>
 #include <linux/sched.h>
diff --git a/sound/core/seq/oss/seq_oss.c b/sound/core/seq/oss/seq_oss.c
index 16d4267..128cab6 100644
--- a/sound/core/seq/oss/seq_oss.c
+++ b/sound/core/seq/oss/seq_oss.c
@@ -20,6 +20,7 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
  */
 
+#include <linux/fs.h>
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
diff --git a/sound/core/seq/oss/seq_oss_init.c b/sound/core/seq/oss/seq_oss_init.c
index b9184d2..25bb61a 100644
--- a/sound/core/seq/oss/seq_oss_init.c
+++ b/sound/core/seq/oss/seq_oss_init.c
@@ -27,6 +27,7 @@
 #include "seq_oss_readq.h"
 #include "seq_oss_timer.h"
 #include "seq_oss_event.h"
+#include <linux/fs.h>
 #include <linux/init.h>
 #include <linux/export.h>
 #include <linux/moduleparam.h>
diff --git a/sound/core/sound.c b/sound/core/sound.c
index 38ad1a0..0e324b3 100644
--- a/sound/core/sound.c
+++ b/sound/core/sound.c
@@ -19,6 +19,7 @@
  *
  */
 
+#include <linux/fs.h>
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/time.h>
diff --git a/sound/core/timer.c b/sound/core/timer.c
index 777a45e..0a76d39 100644
--- a/sound/core/timer.c
+++ b/sound/core/timer.c
@@ -20,6 +20,7 @@
  */
 
 #include <linux/delay.h>
+#include <linux/fs.h>
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/time.h>
-- 
1.8.5.5


--u3/rZRmxL6MmkK24
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0003-headers-fs.h-vs-ftrace.h.patch"

>From 2a6fc69ffb523288269d8704965d58fc5a09826b Mon Sep 17 00:00:00 2001
From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Sat, 21 Jun 2014 00:51:39 +0300
Subject: [PATCH 03/12] headers: fs.h vs ftrace.h

---
 include/linux/ftrace.h | 3 ++-
 kernel/cred.c          | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 404a686..e8d4056 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -15,7 +15,6 @@
 #include <linux/sched.h>
 #include <linux/types.h>
 #include <linux/init.h>
-#include <linux/fs.h>
 
 #include <asm/ftrace.h>
 
@@ -42,6 +41,8 @@
 
 
 struct module;
+struct inode;
+struct file;
 struct ftrace_hash;
 
 #ifdef CONFIG_FUNCTION_TRACER
diff --git a/kernel/cred.c b/kernel/cred.c
index e0573a4..bb9df75 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -9,6 +9,7 @@
  * 2 of the Licence, or (at your option) any later version.
  */
 #include <linux/export.h>
+#include <linux/fs.h>
 #include <linux/cred.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
-- 
1.8.5.5


--u3/rZRmxL6MmkK24
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0004-headers-fs.h-vs-trace_seq.h.patch"

>From e00ea774d148c794ce7deeb490a221f30d717289 Mon Sep 17 00:00:00 2001
From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Sat, 21 Jun 2014 00:56:59 +0300
Subject: [PATCH 04/12] headers: fs.h vs trace_seq.h

---
 include/linux/trace_seq.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/linux/trace_seq.h b/include/linux/trace_seq.h
index 1361169..3ccac21 100644
--- a/include/linux/trace_seq.h
+++ b/include/linux/trace_seq.h
@@ -1,10 +1,9 @@
 #ifndef _LINUX_TRACE_SEQ_H
 #define _LINUX_TRACE_SEQ_H
-
-#include <linux/fs.h>
-
 #include <asm/page.h>
 
+struct path;
+
 /*
  * Trace sequences are used to allow a function to call several other functions
  * to create a string of data to use (up to a max of PAGE_SIZE).
-- 
1.8.5.5


--u3/rZRmxL6MmkK24
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0005-headers-fs.h-vs-compat.h.patch"

>From c851f2cac9033394039c0e8750cb3b974d3b9021 Mon Sep 17 00:00:00 2001
From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Sat, 21 Jun 2014 01:29:47 +0300
Subject: [PATCH 05/12] headers: fs.h vs compat.h

---
 drivers/char/ipmi/ipmi_devintf.c | 1 +
 drivers/char/lp.c                | 1 +
 include/linux/compat.h           | 3 ++-
 sound/core/seq/seq_clientmgr.c   | 1 +
 4 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/char/ipmi/ipmi_devintf.c b/drivers/char/ipmi/ipmi_devintf.c
index ec318bf..db366fe 100644
--- a/drivers/char/ipmi/ipmi_devintf.c
+++ b/drivers/char/ipmi/ipmi_devintf.c
@@ -31,6 +31,7 @@
  *  675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#include <linux/fs.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/errno.h>
diff --git a/drivers/char/lp.c b/drivers/char/lp.c
index c4094c4..6bb8538 100644
--- a/drivers/char/lp.c
+++ b/drivers/char/lp.c
@@ -111,6 +111,7 @@
  * Copyright (C) 2000 by Tim Waugh (added LPSETTIMEOUT ioctl)
  */
 
+#include <linux/fs.h>
 #include <linux/module.h>
 #include <linux/init.h>
 
diff --git a/include/linux/compat.h b/include/linux/compat.h
index e649426..7849cec 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -12,7 +12,6 @@
 #include <linux/sem.h>
 #include <linux/socket.h>
 #include <linux/if.h>
-#include <linux/fs.h>
 #include <linux/aio_abi.h>	/* for aio_context_t */
 #include <linux/unistd.h>
 
@@ -69,6 +68,8 @@ typedef struct compat_sigaltstack {
 #define compat_jiffies_to_clock_t(x)	\
 		(((unsigned long)(x) * COMPAT_USER_HZ) / HZ)
 
+struct file_handle;
+
 typedef __compat_uid32_t	compat_uid_t;
 typedef __compat_gid32_t	compat_gid_t;
 
diff --git a/sound/core/seq/seq_clientmgr.c b/sound/core/seq/seq_clientmgr.c
index 225c7315..8423da0 100644
--- a/sound/core/seq/seq_clientmgr.c
+++ b/sound/core/seq/seq_clientmgr.c
@@ -21,6 +21,7 @@
  *
  */
 
+#include <linux/fs.h>
 #include <linux/init.h>
 #include <linux/export.h>
 #include <linux/slab.h>
-- 
1.8.5.5


--u3/rZRmxL6MmkK24
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0006-headers-fs.h-vs-cgroup.h.patch"

>From 53c53df4d9d20277bf4daa85143900aa2d8200f3 Mon Sep 17 00:00:00 2001
From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Sat, 21 Jun 2014 02:03:15 +0300
Subject: [PATCH 06/12] headers: fs.h vs cgroup.h

---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x.h | 1 +
 include/linux/cgroup.h                      | 3 ++-
 include/linux/netpoll.h                     | 1 +
 include/net/sock.h                          | 1 +
 4 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
index 4cab09d..7cd1f1b 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x.h
@@ -19,6 +19,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/types.h>
 #include <linux/pci_regs.h>
+#include <linux/semaphore.h>
 
 /* compilation time flags */
 
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 8a111dd..63f25ab 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -17,16 +17,17 @@
 #include <linux/rwsem.h>
 #include <linux/idr.h>
 #include <linux/workqueue.h>
-#include <linux/fs.h>
 #include <linux/percpu-refcount.h>
 #include <linux/seq_file.h>
 #include <linux/kernfs.h>
 #include <linux/wait.h>
+#include <uapi/linux/limits.h>
 
 #ifdef CONFIG_CGROUPS
 
 struct cgroup_root;
 struct cgroup_subsys;
+struct dentry;
 struct inode;
 struct cgroup;
 
diff --git a/include/linux/netpoll.h b/include/linux/netpoll.h
index b25ee9f..a51b4de 100644
--- a/include/linux/netpoll.h
+++ b/include/linux/netpoll.h
@@ -10,6 +10,7 @@
 #include <linux/netdevice.h>
 #include <linux/interrupt.h>
 #include <linux/rcupdate.h>
+#include <linux/semaphore.h>
 #include <linux/list.h>
 
 union inet_addr {
diff --git a/include/net/sock.h b/include/net/sock.h
index 173cae4..3c38716 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -61,6 +61,7 @@
 #include <linux/sched.h>
 
 #include <linux/filter.h>
+#include <linux/fs.h>
 #include <linux/rculist_nulls.h>
 #include <linux/poll.h>
 
-- 
1.8.5.5


--u3/rZRmxL6MmkK24
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0007-headers-fs.h-vs-perf_event.h.patch"

>From fcfd998c6fb9fae99f382af302ab398dc210f3ec Mon Sep 17 00:00:00 2001
From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Sat, 21 Jun 2014 13:04:11 +0300
Subject: [PATCH 07/12] headers: fs.h vs perf_event.h

---
 drivers/misc/kgdbts.c      | 1 +
 include/linux/perf_event.h | 3 ++-
 kernel/capability.c        | 1 +
 kernel/groups.c            | 1 +
 kernel/nsproxy.c           | 1 +
 kernel/uid16.c             | 1 +
 security/keys/compat.c     | 1 +
 virt/kvm/eventfd.c         | 1 +
 8 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/kgdbts.c b/drivers/misc/kgdbts.c
index 36f5d52..79d1960 100644
--- a/drivers/misc/kgdbts.c
+++ b/drivers/misc/kgdbts.c
@@ -94,6 +94,7 @@
  *
  */
 
+#include <linux/fs.h>
 #include <linux/kernel.h>
 #include <linux/kgdb.h>
 #include <linux/ctype.h>
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 707617a..b4e5214 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -41,7 +41,6 @@ struct perf_guest_info_callbacks {
 #include <linux/rcupdate.h>
 #include <linux/spinlock.h>
 #include <linux/hrtimer.h>
-#include <linux/fs.h>
 #include <linux/pid_namespace.h>
 #include <linux/workqueue.h>
 #include <linux/ftrace.h>
@@ -54,6 +53,8 @@ struct perf_guest_info_callbacks {
 #include <linux/perf_regs.h>
 #include <asm/local.h>
 
+struct fasync_struct;
+
 struct perf_callchain_entry {
 	__u64				nr;
 	__u64				ip[PERF_MAX_STACK_DEPTH];
diff --git a/kernel/capability.c b/kernel/capability.c
index a5cf13c..6069e21 100644
--- a/kernel/capability.c
+++ b/kernel/capability.c
@@ -11,6 +11,7 @@
 
 #include <linux/audit.h>
 #include <linux/capability.h>
+#include <linux/fs.h>
 #include <linux/mm.h>
 #include <linux/export.h>
 #include <linux/security.h>
diff --git a/kernel/groups.c b/kernel/groups.c
index 451698f..a324d8f 100644
--- a/kernel/groups.c
+++ b/kernel/groups.c
@@ -7,6 +7,7 @@
 #include <linux/security.h>
 #include <linux/syscalls.h>
 #include <asm/uaccess.h>
+#include <uapi/linux/limits.h>
 
 /* init to 2 - one for init_task, one to ensure it is never freed */
 struct group_info init_groups = { .usage = ATOMIC_INIT(2) };
diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index 8e78110..341d958 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -13,6 +13,7 @@
  *             Pavel Emelianov <xemul@openvz.org>
  */
 
+#include <linux/fs.h>
 #include <linux/slab.h>
 #include <linux/export.h>
 #include <linux/nsproxy.h>
diff --git a/kernel/uid16.c b/kernel/uid16.c
index 602e5bb..bc92778 100644
--- a/kernel/uid16.c
+++ b/kernel/uid16.c
@@ -13,6 +13,7 @@
 #include <linux/highuid.h>
 #include <linux/security.h>
 #include <linux/syscalls.h>
+#include <uapi/linux/limits.h>
 
 #include <asm/uaccess.h>
 
diff --git a/security/keys/compat.c b/security/keys/compat.c
index 3478965..3d12bd9 100644
--- a/security/keys/compat.c
+++ b/security/keys/compat.c
@@ -9,6 +9,7 @@
  * 2 of the License, or (at your option) any later version.
  */
 
+#include <linux/fs.h>
 #include <linux/syscalls.h>
 #include <linux/keyctl.h>
 #include <linux/compat.h>
diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 20c3af7..9fdb172 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -28,6 +28,7 @@
 #include <linux/wait.h>
 #include <linux/poll.h>
 #include <linux/file.h>
+#include <linux/fs.h>
 #include <linux/list.h>
 #include <linux/eventfd.h>
 #include <linux/kernel.h>
-- 
1.8.5.5


--u3/rZRmxL6MmkK24
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0008-headers-fs.h-vs-usb.h.patch"

>From d290216e7ecd393d6085f09e69390ba6e9020060 Mon Sep 17 00:00:00 2001
From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Sat, 21 Jun 2014 13:22:09 +0300
Subject: [PATCH 08/12] headers: fs.h vs usb.h

---
 drivers/staging/comedi/drivers/dt9812.c | 1 +
 drivers/usb/class/cdc-wdm.c             | 1 +
 drivers/usb/class/usblp.c               | 1 +
 drivers/usb/core/file.c                 | 1 +
 drivers/usb/core/hub.c                  | 1 +
 drivers/usb/host/xhci.h                 | 1 +
 drivers/usb/misc/adutux.c               | 1 +
 drivers/usb/misc/ftdi-elan.c            | 1 +
 drivers/usb/misc/idmouse.c              | 1 +
 drivers/usb/misc/iowarrior.c            | 1 +
 drivers/usb/misc/legousbtower.c         | 1 +
 drivers/usb/misc/rio500.c               | 1 +
 drivers/usb/misc/usblcd.c               | 1 +
 include/linux/usb.h                     | 2 +-
 14 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/dt9812.c b/drivers/staging/comedi/drivers/dt9812.c
index b3aeb6f..5a51be8 100644
--- a/drivers/staging/comedi/drivers/dt9812.c
+++ b/drivers/staging/comedi/drivers/dt9812.c
@@ -41,6 +41,7 @@ for my needs.
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/errno.h>
+#include <linux/semaphore.h>
 #include <linux/uaccess.h>
 #include <linux/usb.h>
 
diff --git a/drivers/usb/class/cdc-wdm.c b/drivers/usb/class/cdc-wdm.c
index a051a7a..c713ff3 100644
--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -11,6 +11,7 @@
  *
  * Many thanks to Carl Nordbeck
  */
+#include <linux/fs.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/ioctl.h>
diff --git a/drivers/usb/class/usblp.c b/drivers/usb/class/usblp.c
index 0924ee4..2f5600c 100644
--- a/drivers/usb/class/usblp.c
+++ b/drivers/usb/class/usblp.c
@@ -47,6 +47,7 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  */
 
+#include <linux/fs.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
diff --git a/drivers/usb/core/file.c b/drivers/usb/core/file.c
index ea337a7..4c0d8c98 100644
--- a/drivers/usb/core/file.c
+++ b/drivers/usb/core/file.c
@@ -15,6 +15,7 @@
  *
  */
 
+#include <linux/fs.h>
 #include <linux/module.h>
 #include <linux/errno.h>
 #include <linux/rwsem.h>
diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 21b99b4..bc5bae8 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -9,6 +9,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/kdev_t.h>
 #include <linux/errno.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 9ffecd5..4fd10cc 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -23,6 +23,7 @@
 #ifndef __LINUX_XHCI_HCD_H
 #define __LINUX_XHCI_HCD_H
 
+#include <linux/radix-tree.h>
 #include <linux/usb.h>
 #include <linux/timer.h>
 #include <linux/kernel.h>
diff --git a/drivers/usb/misc/adutux.c b/drivers/usb/misc/adutux.c
index 493c7f2..14e96b1 100644
--- a/drivers/usb/misc/adutux.c
+++ b/drivers/usb/misc/adutux.c
@@ -20,6 +20,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/fs.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/slab.h>
diff --git a/drivers/usb/misc/ftdi-elan.c b/drivers/usb/misc/ftdi-elan.c
index 8ab1f8f..db69287 100644
--- a/drivers/usb/misc/ftdi-elan.c
+++ b/drivers/usb/misc/ftdi-elan.c
@@ -38,6 +38,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/fs.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/init.h>
diff --git a/drivers/usb/misc/idmouse.c b/drivers/usb/misc/idmouse.c
index 4e38683c..837fd77 100644
--- a/drivers/usb/misc/idmouse.c
+++ b/drivers/usb/misc/idmouse.c
@@ -16,6 +16,7 @@
 
 */
 
+#include <linux/fs.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/delay.h>
diff --git a/drivers/usb/misc/iowarrior.c b/drivers/usb/misc/iowarrior.c
index c6bfd13..381a985 100644
--- a/drivers/usb/misc/iowarrior.c
+++ b/drivers/usb/misc/iowarrior.c
@@ -13,6 +13,7 @@
  *  Released under the GPLv2.
  */
 
+#include <linux/fs.h>
 #include <linux/module.h>
 #include <linux/usb.h>
 #include <linux/slab.h>
diff --git a/drivers/usb/misc/legousbtower.c b/drivers/usb/misc/legousbtower.c
index 97cd9e2..e3c692b 100644
--- a/drivers/usb/misc/legousbtower.c
+++ b/drivers/usb/misc/legousbtower.c
@@ -77,6 +77,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/fs.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/slab.h>
diff --git a/drivers/usb/misc/rio500.c b/drivers/usb/misc/rio500.c
index 13731d5..a83e2a2 100644
--- a/drivers/usb/misc/rio500.c
+++ b/drivers/usb/misc/rio500.c
@@ -28,6 +28,7 @@
  *             Daniele Bellucci  bellucda@tiscali.it
  * */
 
+#include <linux/fs.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/signal.h>
diff --git a/drivers/usb/misc/usblcd.c b/drivers/usb/misc/usblcd.c
index 1184390..d5a4e4c 100644
--- a/drivers/usb/misc/usblcd.c
+++ b/drivers/usb/misc/usblcd.c
@@ -12,6 +12,7 @@
  *          This new driver allows more than one USB-LCD to be connected     *
  *          and controlled, at once                                          *
  *****************************************************************************/
+#include <linux/fs.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
diff --git a/include/linux/usb.h b/include/linux/usb.h
index d2465bc..2a23d52 100644
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -16,12 +16,12 @@
 #include <linux/list.h>		/* for struct list_head */
 #include <linux/kref.h>		/* for struct kref */
 #include <linux/device.h>	/* for struct device */
-#include <linux/fs.h>		/* for struct file_operations */
 #include <linux/completion.h>	/* for struct completion */
 #include <linux/sched.h>	/* for current && schedule_timeout */
 #include <linux/mutex.h>	/* for struct mutex */
 #include <linux/pm_runtime.h>	/* for runtime PM */
 
+struct file_operations;
 struct usb_device;
 struct usb_driver;
 struct wusb_dev;
-- 
1.8.5.5


--u3/rZRmxL6MmkK24
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0009-headers-fs.h-vs-input.h.patch"

>From 81a2cca294e6f3ee22ddeeab4a358a077438734f Mon Sep 17 00:00:00 2001
From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Sat, 21 Jun 2014 13:41:09 +0300
Subject: [PATCH 09/12] headers: fs.h vs input.h

---
 drivers/hid/hid-roccat.c                     | 1 +
 drivers/hid/usbhid/hiddev.c                  | 1 +
 drivers/input/evdev.c                        | 1 +
 drivers/input/joydev.c                       | 1 +
 drivers/input/mousedev.c                     | 1 +
 drivers/media/rc/imon.c                      | 1 +
 drivers/misc/lis3lv02d/lis3lv02d.c           | 1 +
 drivers/staging/comedi/drivers/usbdux.c      | 1 +
 drivers/staging/comedi/drivers/usbduxfast.c  | 1 +
 drivers/staging/comedi/drivers/usbduxsigma.c | 1 +
 drivers/staging/comedi/drivers/vmk80xx.c     | 1 +
 drivers/staging/frontier/alphatrack.c        | 1 +
 drivers/staging/frontier/tranzport.c         | 1 +
 drivers/usb/gadget/f_hid.c                   | 1 +
 drivers/usb/misc/ldusb.c                     | 1 +
 drivers/usb/misc/yurex.c                     | 1 +
 include/linux/input.h                        | 3 ++-
 17 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-roccat.c b/drivers/hid/hid-roccat.c
index 65c4ccfc..c7e1e37 100644
--- a/drivers/hid/hid-roccat.c
+++ b/drivers/hid/hid-roccat.c
@@ -24,6 +24,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/cdev.h>
+#include <linux/fs.h>
 #include <linux/poll.h>
 #include <linux/sched.h>
 #include <linux/hid-roccat.h>
diff --git a/drivers/hid/usbhid/hiddev.c b/drivers/hid/usbhid/hiddev.c
index 2f1ddca..8617b1f 100644
--- a/drivers/hid/usbhid/hiddev.c
+++ b/drivers/hid/usbhid/hiddev.c
@@ -25,6 +25,7 @@
  * e-mail - mail your message to Paul Stewart <stewart@wetlogic.net>
  */
 
+#include <linux/fs.h>
 #include <linux/poll.h>
 #include <linux/slab.h>
 #include <linux/module.h>
diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index fd325ec..1003005 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -15,6 +15,7 @@
 #define EVDEV_MIN_BUFFER_SIZE	64U
 #define EVDEV_BUF_PACKETS	8
 
+#include <linux/fs.h>
 #include <linux/poll.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
diff --git a/drivers/input/joydev.c b/drivers/input/joydev.c
index f362883..71d1558 100644
--- a/drivers/input/joydev.c
+++ b/drivers/input/joydev.c
@@ -15,6 +15,7 @@
 #include <asm/io.h>
 #include <linux/delay.h>
 #include <linux/errno.h>
+#include <linux/fs.h>
 #include <linux/joystick.h>
 #include <linux/input.h>
 #include <linux/kernel.h>
diff --git a/drivers/input/mousedev.c b/drivers/input/mousedev.c
index b604564..e9dc31f 100644
--- a/drivers/input/mousedev.c
+++ b/drivers/input/mousedev.c
@@ -15,6 +15,7 @@
 #define MOUSEDEV_MINORS		31
 #define MOUSEDEV_MIX		63
 
+#include <linux/fs.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/poll.h>
diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index 6f24e77..3859b96 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -29,6 +29,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ":%s: " fmt, __func__
 
 #include <linux/errno.h>
+#include <linux/fs.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
diff --git a/drivers/misc/lis3lv02d/lis3lv02d.c b/drivers/misc/lis3lv02d/lis3lv02d.c
index 3ef4627..b6e6e48 100644
--- a/drivers/misc/lis3lv02d/lis3lv02d.c
+++ b/drivers/misc/lis3lv02d/lis3lv02d.c
@@ -22,6 +22,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/fs.h>
 #include <linux/kernel.h>
 #include <linux/dmi.h>
 #include <linux/module.h>
diff --git a/drivers/staging/comedi/drivers/usbdux.c b/drivers/staging/comedi/drivers/usbdux.c
index 5f65e42..d34b111 100644
--- a/drivers/staging/comedi/drivers/usbdux.c
+++ b/drivers/staging/comedi/drivers/usbdux.c
@@ -80,6 +80,7 @@ sampling rate. If you sample two channels you get 4kHz and so on.
 
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/semaphore.h>
 #include <linux/slab.h>
 #include <linux/input.h>
 #include <linux/usb.h>
diff --git a/drivers/staging/comedi/drivers/usbduxfast.c b/drivers/staging/comedi/drivers/usbduxfast.c
index 85f9dcf..4636f45 100644
--- a/drivers/staging/comedi/drivers/usbduxfast.c
+++ b/drivers/staging/comedi/drivers/usbduxfast.c
@@ -37,6 +37,7 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/semaphore.h>
 #include <linux/slab.h>
 #include <linux/input.h>
 #include <linux/usb.h>
diff --git a/drivers/staging/comedi/drivers/usbduxsigma.c b/drivers/staging/comedi/drivers/usbduxsigma.c
index ccc3ef7..dc2abbd 100644
--- a/drivers/staging/comedi/drivers/usbduxsigma.c
+++ b/drivers/staging/comedi/drivers/usbduxsigma.c
@@ -43,6 +43,7 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/semaphore.h>
 #include <linux/slab.h>
 #include <linux/input.h>
 #include <linux/usb.h>
diff --git a/drivers/staging/comedi/drivers/vmk80xx.c b/drivers/staging/comedi/drivers/vmk80xx.c
index 0adf3cf..2dac777 100644
--- a/drivers/staging/comedi/drivers/vmk80xx.c
+++ b/drivers/staging/comedi/drivers/vmk80xx.c
@@ -39,6 +39,7 @@ Supports:
 #include <linux/mutex.h>
 #include <linux/errno.h>
 #include <linux/input.h>
+#include <linux/semaphore.h>
 #include <linux/slab.h>
 #include <linux/poll.h>
 #include <linux/usb.h>
diff --git a/drivers/staging/frontier/alphatrack.c b/drivers/staging/frontier/alphatrack.c
index 226b231..0c55bb2 100644
--- a/drivers/staging/frontier/alphatrack.c
+++ b/drivers/staging/frontier/alphatrack.c
@@ -33,6 +33,7 @@
  * can be buffered up before the light change makes it to the interface.
  */
 
+#include <linux/fs.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/slab.h>
diff --git a/drivers/staging/frontier/tranzport.c b/drivers/staging/frontier/tranzport.c
index 2f86163..8b5382a 100644
--- a/drivers/staging/frontier/tranzport.c
+++ b/drivers/staging/frontier/tranzport.c
@@ -32,6 +32,7 @@
  * can be buffered up before the light change makes it to the interface.
  */
 
+#include <linux/fs.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/slab.h>
diff --git a/drivers/usb/gadget/f_hid.c b/drivers/usb/gadget/f_hid.c
index a95290a..ade6ea7 100644
--- a/drivers/usb/gadget/f_hid.c
+++ b/drivers/usb/gadget/f_hid.c
@@ -9,6 +9,7 @@
  * (at your option) any later version.
  */
 
+#include <linux/fs.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/hid.h>
diff --git a/drivers/usb/misc/ldusb.c b/drivers/usb/misc/ldusb.c
index 82503a7..098bff5 100644
--- a/drivers/usb/misc/ldusb.c
+++ b/drivers/usb/misc/ldusb.c
@@ -22,6 +22,7 @@
  *		 2001-2004 Juergen Stuber <starblue@users.sourceforge.net>
  */
 
+#include <linux/fs.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/slab.h>
diff --git a/drivers/usb/misc/yurex.c b/drivers/usb/misc/yurex.c
index 1472805..36014668 100644
--- a/drivers/usb/misc/yurex.c
+++ b/drivers/usb/misc/yurex.c
@@ -9,6 +9,7 @@
  *
  */
 
+#include <linux/fs.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/slab.h>
diff --git a/include/linux/input.h b/include/linux/input.h
index 82ce323..818ed96 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -20,10 +20,11 @@
  */
 
 #include <linux/device.h>
-#include <linux/fs.h>
 #include <linux/timer.h>
 #include <linux/mod_devicetable.h>
 
+struct file;
+
 /**
  * struct input_value - input value representation
  * @type: type of value (EV_KEY, EV_ABS, etc)
-- 
1.8.5.5


--u3/rZRmxL6MmkK24
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0010-headers-fs.h-vs-include-linux-tty.h.patch"

>From 6e0187fe9f10e2bc4f187492b57a86d9b6211f90 Mon Sep 17 00:00:00 2001
From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Sun, 29 Jun 2014 21:54:11 +0300
Subject: [PATCH 10/12] headers: fs.h vs include/linux/tty.h

---
 include/linux/tty.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/tty.h b/include/linux/tty.h
index 1c3316a..8959746 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -1,7 +1,6 @@
 #ifndef _LINUX_TTY_H
 #define _LINUX_TTY_H
 
-#include <linux/fs.h>
 #include <linux/major.h>
 #include <linux/termios.h>
 #include <linux/workqueue.h>
@@ -13,6 +12,9 @@
 #include <linux/rwsem.h>
 #include <linux/llist.h>
 
+struct file;
+struct inode;
+
 
 
 /*
-- 
1.8.5.5


--u3/rZRmxL6MmkK24
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0011-headers-fs.h-vs-include-linux-posix-clock.h.patch"

>From 27dbd3f946c7be29196296fa1ff3c1c3749564eb Mon Sep 17 00:00:00 2001
From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Sun, 29 Jun 2014 22:03:09 +0300
Subject: [PATCH 11/12] headers: fs.h vs include/linux/posix-clock.h

---
 drivers/ptp/ptp_clock.c     | 1 +
 include/linux/posix-clock.h | 2 +-
 kernel/time/posix-clock.c   | 1 +
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
index 296b0ec..ecf3ce9 100644
--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -17,6 +17,7 @@
  *  along with this program; if not, write to the Free Software
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
+#include <linux/fs.h>
 #include <linux/idr.h>
 #include <linux/device.h>
 #include <linux/err.h>
diff --git a/include/linux/posix-clock.h b/include/linux/posix-clock.h
index 34c4498..924ec64 100644
--- a/include/linux/posix-clock.h
+++ b/include/linux/posix-clock.h
@@ -21,11 +21,11 @@
 #define _LINUX_POSIX_CLOCK_H_
 
 #include <linux/cdev.h>
-#include <linux/fs.h>
 #include <linux/poll.h>
 #include <linux/posix-timers.h>
 #include <linux/rwsem.h>
 
+struct file;
 struct posix_clock;
 
 /**
diff --git a/kernel/time/posix-clock.c b/kernel/time/posix-clock.c
index ce033c7..438e828 100644
--- a/kernel/time/posix-clock.c
+++ b/kernel/time/posix-clock.c
@@ -20,6 +20,7 @@
 #include <linux/device.h>
 #include <linux/export.h>
 #include <linux/file.h>
+#include <linux/fs.h>
 #include <linux/posix-clock.h>
 #include <linux/slab.h>
 #include <linux/syscalls.h>
-- 
1.8.5.5


--u3/rZRmxL6MmkK24
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0012-headers-sock.h-vs-include-linux-mroute.h.patch"

>From 46eb22758bbe066dfdd70bd023e7a54f061fc494 Mon Sep 17 00:00:00 2001
From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Sun, 29 Jun 2014 22:16:44 +0300
Subject: [PATCH 12/12] headers: sock.h vs include/linux/mroute.h

---
 include/linux/mroute.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/mroute.h b/include/linux/mroute.h
index 79aaa9f..74f2d5b 100644
--- a/include/linux/mroute.h
+++ b/include/linux/mroute.h
@@ -3,9 +3,11 @@
 
 #include <linux/in.h>
 #include <linux/pim.h>
-#include <net/sock.h>
+#include <linux/skbuff.h>
 #include <uapi/linux/mroute.h>
 
+struct sock;
+
 #ifdef CONFIG_IP_MROUTE
 static inline int ip_mroute_opt(int opt)
 {
-- 
1.8.5.5


--u3/rZRmxL6MmkK24--
