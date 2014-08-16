Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751714AbaHPXhs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 19:37:48 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:53581 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbaHPXhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 19:37:47 -0400
Date: Sun, 17 Aug 2014 02:37:47 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] headers: remove fs.h from poll.h
Message-ID: <20140816233746.GA32332@p183.telecom.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* remove fs.h from poll.h
  it is not necessary to include full header,

* fixup compilation with additional includes where needed.

Cross-compile tested on hundreds of configs across 15 archs.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 arch/m68k/bvme6000/rtc.c                    |    1 +
 arch/m68k/mvme16x/rtc.c                     |    1 +
 drivers/gpu/vga/vgaarb.c                    |    1 +
 drivers/input/serio/serio_raw.c             |    1 +
 drivers/misc/mic/host/mic_fops.c            |    1 +
 drivers/platform/goldfish/goldfish_pipe.c   |    1 +
 drivers/pps/pps.c                           |    1 +
 drivers/rtc/interface.c                     |    1 +
 drivers/rtc/rtc-dev.c                       |    1 +
 drivers/s390/char/monwriter.c               |    1 +
 drivers/staging/comedi/drivers/serial2002.c |    1 +
 drivers/vfio/pci/vfio_pci_intrs.c           |    1 +
 include/linux/poll.h                        |    3 ++-
 include/media/videobuf-core.h               |    2 ++
 include/sound/pcm.h                         |    1 +
 include/uapi/linux/rtc.h                    |    1 +
 sound/core/control.c                        |    1 +
 sound/core/hwdep.c                          |    1 +
 sound/core/init.c                           |    1 +
 sound/core/oss/mixer_oss.c                  |    1 +
 sound/core/rawmidi.c                        |    1 +
 sound/core/seq/oss/seq_oss.c                |    1 +
 sound/core/seq/oss/seq_oss_init.c           |    1 +
 sound/core/seq/seq_clientmgr.c              |    1 +
 sound/core/sound.c                          |    1 +
 sound/core/timer.c                          |    1 +
 sound/isa/wavefront/wavefront_fx.c          |    1 +
 sound/isa/wavefront/wavefront_synth.c       |    1 +
 28 files changed, 30 insertions(+), 1 deletion(-)

--- a/arch/m68k/bvme6000/rtc.c
+++ b/arch/m68k/bvme6000/rtc.c
@@ -12,6 +12,7 @@
 #include <linux/ioport.h>
 #include <linux/capability.h>
 #include <linux/fcntl.h>
+#include <linux/fs.h>
 #include <linux/init.h>
 #include <linux/poll.h>
 #include <linux/module.h>
--- a/arch/m68k/mvme16x/rtc.c
+++ b/arch/m68k/mvme16x/rtc.c
@@ -12,6 +12,7 @@
 #include <linux/ioport.h>
 #include <linux/capability.h>
 #include <linux/fcntl.h>
+#include <linux/fs.h>
 #include <linux/init.h>
 #include <linux/poll.h>
 #include <linux/mc146818rtc.h>	/* For struct rtc_time and ioctls, etc */
--- a/drivers/gpu/vga/vgaarb.c
+++ b/drivers/gpu/vga/vgaarb.c
@@ -29,6 +29,7 @@
  *
  */
 
+#include <linux/fs.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/pci.h>
--- a/drivers/input/serio/serio_raw.c
+++ b/drivers/input/serio/serio_raw.c
@@ -9,6 +9,7 @@
  * the Free Software Foundation.
  */
 
+#include <linux/fs.h>
 #include <linux/kref.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
--- a/drivers/misc/mic/host/mic_fops.c
+++ b/drivers/misc/mic/host/mic_fops.c
@@ -18,6 +18,7 @@
  * Intel MIC Host driver.
  *
  */
+#include <linux/fs.h>
 #include <linux/poll.h>
 #include <linux/pci.h>
 
--- a/drivers/platform/goldfish/goldfish_pipe.c
+++ b/drivers/platform/goldfish/goldfish_pipe.c
@@ -45,6 +45,7 @@
  * exchange is properly mapped during a transfer.
  */
 
+#include <linux/fs.h>
 #include <linux/module.h>
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
--- a/drivers/pps/pps.c
+++ b/drivers/pps/pps.c
@@ -21,6 +21,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/fs.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -11,6 +11,7 @@
  * published by the Free Software Foundation.
 */
 
+#include <linux/fs.h>
 #include <linux/rtc.h>
 #include <linux/sched.h>
 #include <linux/module.h>
--- a/drivers/rtc/rtc-dev.c
+++ b/drivers/rtc/rtc-dev.c
@@ -13,6 +13,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/fs.h>
 #include <linux/module.h>
 #include <linux/rtc.h>
 #include <linux/sched.h>
--- a/drivers/s390/char/monwriter.c
+++ b/drivers/s390/char/monwriter.c
@@ -9,6 +9,7 @@
 #define KMSG_COMPONENT "monwriter"
 #define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
 
+#include <linux/fs.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/init.h>
--- a/drivers/staging/comedi/drivers/serial2002.c
+++ b/drivers/staging/comedi/drivers/serial2002.c
@@ -26,6 +26,7 @@ Status: in development
 
 */
 
+#include <linux/fs.h>
 #include <linux/module.h>
 #include "../comedidev.h"
 
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -14,6 +14,7 @@
  */
 
 #include <linux/device.h>
+#include <linux/fs.h>
 #include <linux/interrupt.h>
 #include <linux/eventfd.h>
 #include <linux/pci.h>
--- a/include/linux/poll.h
+++ b/include/linux/poll.h
@@ -6,11 +6,12 @@
 #include <linux/ktime.h>
 #include <linux/wait.h>
 #include <linux/string.h>
-#include <linux/fs.h>
 #include <linux/sysctl.h>
 #include <asm/uaccess.h>
 #include <uapi/linux/poll.h>
 
+struct file;
+
 extern struct ctl_table epoll_table[]; /* for sysctl */
 /* ~832 bytes of stack space used max in sys_select/sys_poll before allocating
    additional memory. */
--- a/include/media/videobuf-core.h
+++ b/include/media/videobuf-core.h
@@ -16,6 +16,7 @@
 #ifndef _VIDEOBUF_CORE_H
 #define _VIDEOBUF_CORE_H
 
+#include <linux/mutex.h>
 #include <linux/poll.h>
 #include <linux/videodev2.h>
 
@@ -24,6 +25,7 @@
 
 struct videobuf_buffer;
 struct videobuf_queue;
+struct vm_area_struct;
 
 /* --------------------------------------------------------------------- */
 
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
--- a/include/uapi/linux/rtc.h
+++ b/include/uapi/linux/rtc.h
@@ -10,6 +10,7 @@
  */
 #ifndef _UAPI_LINUX_RTC_H_
 #define _UAPI_LINUX_RTC_H_
+#include <linux/ioctl.h>
 
 /*
  * The struct used to pass data via the following ioctl. Similar to the
--- a/sound/core/control.c
+++ b/sound/core/control.c
@@ -19,6 +19,7 @@
  *
  */
 
+#include <linux/fs.h>
 #include <linux/threads.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
--- a/sound/core/hwdep.c
+++ b/sound/core/hwdep.c
@@ -19,6 +19,7 @@
  *
  */
 
+#include <linux/fs.h>
 #include <linux/major.h>
 #include <linux/init.h>
 #include <linux/slab.h>
--- a/sound/core/init.c
+++ b/sound/core/init.c
@@ -19,6 +19,7 @@
  *
  */
 
+#include <linux/fs.h>
 #include <linux/init.h>
 #include <linux/sched.h>
 #include <linux/module.h>
--- a/sound/core/oss/mixer_oss.c
+++ b/sound/core/oss/mixer_oss.c
@@ -19,6 +19,7 @@
  *
  */
 
+#include <linux/fs.h>
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/time.h>
--- a/sound/core/rawmidi.c
+++ b/sound/core/rawmidi.c
@@ -20,6 +20,7 @@
  */
 
 #include <sound/core.h>
+#include <linux/fs.h>
 #include <linux/major.h>
 #include <linux/init.h>
 #include <linux/sched.h>
--- a/sound/core/seq/oss/seq_oss.c
+++ b/sound/core/seq/oss/seq_oss.c
@@ -20,6 +20,7 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
  */
 
+#include <linux/fs.h>
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
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
--- a/sound/core/seq/seq_clientmgr.c
+++ b/sound/core/seq/seq_clientmgr.c
@@ -21,6 +21,7 @@
  *
  */
 
+#include <linux/fs.h>
 #include <linux/init.h>
 #include <linux/export.h>
 #include <linux/slab.h>
--- a/sound/core/sound.c
+++ b/sound/core/sound.c
@@ -19,6 +19,7 @@
  *
  */
 
+#include <linux/fs.h>
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/time.h>
--- a/sound/core/timer.c
+++ b/sound/core/timer.c
@@ -20,6 +20,7 @@
  */
 
 #include <linux/delay.h>
+#include <linux/fs.h>
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/time.h>
--- a/sound/isa/wavefront/wavefront_fx.c
+++ b/sound/isa/wavefront/wavefront_fx.c
@@ -17,6 +17,7 @@
  */
 
 #include <asm/io.h>
+#include <linux/fs.h>
 #include <linux/init.h>
 #include <linux/time.h>
 #include <linux/wait.h>
--- a/sound/isa/wavefront/wavefront_synth.c
+++ b/sound/isa/wavefront/wavefront_synth.c
@@ -21,6 +21,7 @@
  */
 
 #include <asm/io.h>
+#include <linux/fs.h>
 #include <linux/interrupt.h>
 #include <linux/init.h>
 #include <linux/delay.h>
