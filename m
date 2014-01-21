Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932141AbaAUV3V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 16:29:21 -0500
Received: from mail.windriver.com ([147.11.1.11]:56631 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755042AbaAUVZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 16:25:53 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arch@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 72/73] drivers: delete remaining non-required instances of <linux/init.h>
Date: Tue, 21 Jan 2014 16:23:15 -0500
Message-ID: <1390339396-3479-73-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.4.1
In-Reply-To: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
References: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

None of these files are actually using any __init type directives
and hence don't need to include <linux/init.h>.  Most are just a
left over from __devinit and __cpuinit removal, or simply due to
code getting copied from one driver to the next.

This covers off all the remaining scattered instances in drivers
in order to avoid a bunch more separate smaller commits.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/atm/idt77105.c                       | 1 -
 drivers/atm/suni.c                           | 1 -
 drivers/block/nvme-scsi.c                    | 1 -
 drivers/clk/mxs/clk-ssp.c                    | 1 -
 drivers/cpuidle/cpuidle-kirkwood.c           | 1 -
 drivers/extcon/extcon-gpio.c                 | 1 -
 drivers/firewire/nosy.c                      | 1 -
 drivers/firewire/ohci.c                      | 1 -
 drivers/firmware/efi/vars.c                  | 1 -
 drivers/fmc/fmc-chardev.c                    | 1 -
 drivers/fmc/fmc-core.c                       | 1 -
 drivers/fmc/fmc-fakedev.c                    | 1 -
 drivers/fmc/fmc-trivial.c                    | 1 -
 drivers/fmc/fmc-write-eeprom.c               | 1 -
 drivers/hid/usbhid/hiddev.c                  | 1 -
 drivers/hid/usbhid/usbkbd.c                  | 1 -
 drivers/hid/usbhid/usbmouse.c                | 1 -
 drivers/ide/delkin_cb.c                      | 1 -
 drivers/ide/ide-io.c                         | 1 -
 drivers/ide/setup-pci.c                      | 1 -
 drivers/lguest/lg.h                          | 1 -
 drivers/md/bitmap.c                          | 1 -
 drivers/md/dm-region-hash.c                  | 1 -
 drivers/message/fusion/mptlan.h              | 1 -
 drivers/message/fusion/mptscsih.c            | 1 -
 drivers/ntb/ntb_hw.c                         | 1 -
 drivers/of/device.c                          | 1 -
 drivers/oprofile/timer_int.c                 | 1 -
 drivers/parisc/eisa_enumerator.c             | 1 -
 drivers/parport/parport_cs.c                 | 1 -
 drivers/parport/parport_gsc.c                | 1 -
 drivers/parport/parport_sunbpp.c             | 1 -
 drivers/pnp/manager.c                        | 1 -
 drivers/pnp/pnpbios/bioscalls.c              | 1 -
 drivers/pps/clients/pps-gpio.c               | 1 -
 drivers/pps/kapi.c                           | 1 -
 drivers/pps/kc.c                             | 1 -
 drivers/pwm/pwm-atmel-tcb.c                  | 1 -
 drivers/pwm/pwm-renesas-tpu.c                | 1 -
 drivers/rapidio/devices/tsi721_dma.c         | 1 -
 drivers/rapidio/rio.c                        | 1 -
 drivers/regulator/ab8500-ext.c               | 1 -
 drivers/regulator/arizona-ldo1.c             | 1 -
 drivers/regulator/arizona-micsupp.c          | 1 -
 drivers/regulator/mc13xxx-regulator-core.c   | 1 -
 drivers/regulator/wm8994-regulator.c         | 1 -
 drivers/target/target_core_fabric_configfs.c | 1 -
 drivers/target/tcm_fc/tfc_cmd.c              | 1 -
 drivers/target/tcm_fc/tfc_io.c               | 1 -
 drivers/target/tcm_fc/tfc_sess.c             | 1 -
 drivers/thermal/ti-soc-thermal/ti-bandgap.c  | 1 -
 drivers/uio/uio_aec.c                        | 1 -
 drivers/uwb/beacon.c                         | 1 -
 drivers/uwb/hwa-rc.c                         | 1 -
 drivers/vlynq/vlynq.c                        | 1 -
 drivers/w1/masters/ds2482.c                  | 1 -
 drivers/w1/masters/w1-gpio.c                 | 1 -
 drivers/xen/xen-stub.c                       | 1 -
 58 files changed, 58 deletions(-)

diff --git a/drivers/atm/idt77105.c b/drivers/atm/idt77105.c
index 45d5063..e792482 100644
--- a/drivers/atm/idt77105.c
+++ b/drivers/atm/idt77105.c
@@ -11,7 +11,6 @@
 #include <linux/sonet.h>
 #include <linux/delay.h>
 #include <linux/timer.h>
-#include <linux/init.h>
 #include <linux/capability.h>
 #include <linux/atm_idt77105.h>
 #include <linux/spinlock.h>
diff --git a/drivers/atm/suni.c b/drivers/atm/suni.c
index 0215934..bc79c9f 100644
--- a/drivers/atm/suni.c
+++ b/drivers/atm/suni.c
@@ -18,7 +18,6 @@
 #include <linux/sonet.h>
 #include <linux/delay.h>
 #include <linux/timer.h>
-#include <linux/init.h>
 #include <linux/capability.h>
 #include <linux/atm_suni.h>
 #include <linux/slab.h>
diff --git a/drivers/block/nvme-scsi.c b/drivers/block/nvme-scsi.c
index 4a4ff4e..1ce4223 100644
--- a/drivers/block/nvme-scsi.c
+++ b/drivers/block/nvme-scsi.c
@@ -30,7 +30,6 @@
 #include <linux/fs.h>
 #include <linux/genhd.h>
 #include <linux/idr.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/kdev_t.h>
diff --git a/drivers/clk/mxs/clk-ssp.c b/drivers/clk/mxs/clk-ssp.c
index af7bdbf..a57f0ba 100644
--- a/drivers/clk/mxs/clk-ssp.c
+++ b/drivers/clk/mxs/clk-ssp.c
@@ -17,7 +17,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/clk.h>
 #include <linux/module.h>
 #include <linux/device.h>
diff --git a/drivers/cpuidle/cpuidle-kirkwood.c b/drivers/cpuidle/cpuidle-kirkwood.c
index 41ba843..1c88bfd 100644
--- a/drivers/cpuidle/cpuidle-kirkwood.c
+++ b/drivers/cpuidle/cpuidle-kirkwood.c
@@ -16,7 +16,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/cpuidle.h>
 #include <linux/io.h>
diff --git a/drivers/extcon/extcon-gpio.c b/drivers/extcon/extcon-gpio.c
index a63a6b2..d5b6d55 100644
--- a/drivers/extcon/extcon-gpio.c
+++ b/drivers/extcon/extcon-gpio.c
@@ -22,7 +22,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
diff --git a/drivers/firewire/nosy.c b/drivers/firewire/nosy.c
index 76b2d39..a33ae46 100644
--- a/drivers/firewire/nosy.c
+++ b/drivers/firewire/nosy.c
@@ -20,7 +20,6 @@
 #include <linux/device.h>
 #include <linux/errno.h>
 #include <linux/fs.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/kernel.h>
diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index 6f74d8d..f27efbe 100644
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -26,7 +26,6 @@
 #include <linux/dma-mapping.h>
 #include <linux/firewire.h>
 #include <linux/firewire-constants.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/kernel.h>
diff --git a/drivers/firmware/efi/vars.c b/drivers/firmware/efi/vars.c
index b22659c..ba7f316 100644
--- a/drivers/firmware/efi/vars.c
+++ b/drivers/firmware/efi/vars.c
@@ -22,7 +22,6 @@
 #include <linux/capability.h>
 #include <linux/types.h>
 #include <linux/errno.h>
-#include <linux/init.h>
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/string.h>
diff --git a/drivers/fmc/fmc-chardev.c b/drivers/fmc/fmc-chardev.c
index ace6ef2..7a055ad 100644
--- a/drivers/fmc/fmc-chardev.c
+++ b/drivers/fmc/fmc-chardev.c
@@ -8,7 +8,6 @@
  * by CERN, the European Institute for Nuclear Research.
  */
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/list.h>
 #include <linux/slab.h>
 #include <linux/fs.h>
diff --git a/drivers/fmc/fmc-core.c b/drivers/fmc/fmc-core.c
index 24d5249..5f0a15c 100644
--- a/drivers/fmc/fmc-core.c
+++ b/drivers/fmc/fmc-core.c
@@ -10,7 +10,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/slab.h>
-#include <linux/init.h>
 #include <linux/device.h>
 #include <linux/fmc.h>
 
diff --git a/drivers/fmc/fmc-fakedev.c b/drivers/fmc/fmc-fakedev.c
index 941d093..9144596 100644
--- a/drivers/fmc/fmc-fakedev.c
+++ b/drivers/fmc/fmc-fakedev.c
@@ -11,7 +11,6 @@
  * applicable law.
  */
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/string.h>
 #include <linux/device.h>
 #include <linux/slab.h>
diff --git a/drivers/fmc/fmc-trivial.c b/drivers/fmc/fmc-trivial.c
index 6c590f5..611a05b 100644
--- a/drivers/fmc/fmc-trivial.c
+++ b/drivers/fmc/fmc-trivial.c
@@ -13,7 +13,6 @@
 
 /* A trivial fmc driver that can load a gateware file and reports interrupts */
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/gpio.h>
 #include <linux/fmc.h>
diff --git a/drivers/fmc/fmc-write-eeprom.c b/drivers/fmc/fmc-write-eeprom.c
index ee5b479..30e451e 100644
--- a/drivers/fmc/fmc-write-eeprom.c
+++ b/drivers/fmc/fmc-write-eeprom.c
@@ -10,7 +10,6 @@
 #include <linux/module.h>
 #include <linux/string.h>
 #include <linux/firmware.h>
-#include <linux/init.h>
 #include <linux/fmc.h>
 #include <asm/unaligned.h>
 
diff --git a/drivers/hid/usbhid/hiddev.c b/drivers/hid/usbhid/hiddev.c
index 2f1ddca..2cad378 100644
--- a/drivers/hid/usbhid/hiddev.c
+++ b/drivers/hid/usbhid/hiddev.c
@@ -28,7 +28,6 @@
 #include <linux/poll.h>
 #include <linux/slab.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/input.h>
 #include <linux/usb.h>
 #include <linux/hid.h>
diff --git a/drivers/hid/usbhid/usbkbd.c b/drivers/hid/usbhid/usbkbd.c
index 9a332e6..30c236b 100644
--- a/drivers/hid/usbhid/usbkbd.c
+++ b/drivers/hid/usbhid/usbkbd.c
@@ -29,7 +29,6 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/usb/input.h>
 #include <linux/hid.h>
 
diff --git a/drivers/hid/usbhid/usbmouse.c b/drivers/hid/usbhid/usbmouse.c
index bf16d72..c3a2e29 100644
--- a/drivers/hid/usbhid/usbmouse.c
+++ b/drivers/hid/usbhid/usbmouse.c
@@ -27,7 +27,6 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/usb/input.h>
 #include <linux/hid.h>
 
diff --git a/drivers/ide/delkin_cb.c b/drivers/ide/delkin_cb.c
index 300daab..9ab3268 100644
--- a/drivers/ide/delkin_cb.c
+++ b/drivers/ide/delkin_cb.c
@@ -20,7 +20,6 @@
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/ide.h>
-#include <linux/init.h>
 #include <linux/pci.h>
 
 #include <asm/io.h>
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index 177db6d..954a5a2 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -36,7 +36,6 @@
 #include <linux/genhd.h>
 #include <linux/blkpg.h>
 #include <linux/slab.h>
-#include <linux/init.h>
 #include <linux/pci.h>
 #include <linux/delay.h>
 #include <linux/ide.h>
diff --git a/drivers/ide/setup-pci.c b/drivers/ide/setup-pci.c
index 34a5e52..3518548 100644
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -10,7 +10,6 @@
 #include <linux/kernel.h>
 #include <linux/export.h>
 #include <linux/pci.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/ide.h>
 #include <linux/dma-mapping.h>
diff --git a/drivers/lguest/lg.h b/drivers/lguest/lg.h
index 2eef40b..b517698 100644
--- a/drivers/lguest/lg.h
+++ b/drivers/lguest/lg.h
@@ -3,7 +3,6 @@
 
 #ifndef __ASSEMBLY__
 #include <linux/types.h>
-#include <linux/init.h>
 #include <linux/stringify.h>
 #include <linux/lguest.h>
 #include <linux/lguest_launcher.h>
diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 4195a01..5d89cce 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -19,7 +19,6 @@
 #include <linux/module.h>
 #include <linux/errno.h>
 #include <linux/slab.h>
-#include <linux/init.h>
 #include <linux/timer.h>
 #include <linux/sched.h>
 #include <linux/list.h>
diff --git a/drivers/md/dm-region-hash.c b/drivers/md/dm-region-hash.c
index b929fd5..9d44713 100644
--- a/drivers/md/dm-region-hash.c
+++ b/drivers/md/dm-region-hash.c
@@ -9,7 +9,6 @@
 #include <linux/dm-region-hash.h>
 
 #include <linux/ctype.h>
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
diff --git a/drivers/message/fusion/mptlan.h b/drivers/message/fusion/mptlan.h
index 69e9d54..3a483a5 100644
--- a/drivers/message/fusion/mptlan.h
+++ b/drivers/message/fusion/mptlan.h
@@ -62,7 +62,6 @@
 // #include <linux/fddidevice.h>
 #include <linux/skbuff.h>
 #include <linux/if_arp.h>
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/miscdevice.h>
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index 727819c..459192cd 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -47,7 +47,6 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
-#include <linux/init.h>
 #include <linux/errno.h>
 #include <linux/kdev_t.h>
 #include <linux/blkdev.h>
diff --git a/drivers/ntb/ntb_hw.c b/drivers/ntb/ntb_hw.c
index 170e8e6..71fe171 100644
--- a/drivers/ntb/ntb_hw.c
+++ b/drivers/ntb/ntb_hw.c
@@ -47,7 +47,6 @@
  */
 #include <linux/debugfs.h>
 #include <linux/delay.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/pci.h>
diff --git a/drivers/of/device.c b/drivers/of/device.c
index dafb973..cf1b8ea 100644
--- a/drivers/of/device.c
+++ b/drivers/of/device.c
@@ -2,7 +2,6 @@
 #include <linux/kernel.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/mod_devicetable.h>
 #include <linux/slab.h>
diff --git a/drivers/oprofile/timer_int.c b/drivers/oprofile/timer_int.c
index 61be1d9..9d728e6 100644
--- a/drivers/oprofile/timer_int.c
+++ b/drivers/oprofile/timer_int.c
@@ -12,7 +12,6 @@
 #include <linux/smp.h>
 #include <linux/oprofile.h>
 #include <linux/profile.h>
-#include <linux/init.h>
 #include <linux/cpu.h>
 #include <linux/hrtimer.h>
 #include <asm/irq_regs.h>
diff --git a/drivers/parisc/eisa_enumerator.c b/drivers/parisc/eisa_enumerator.c
index caa1531..e72fca6 100644
--- a/drivers/parisc/eisa_enumerator.c
+++ b/drivers/parisc/eisa_enumerator.c
@@ -11,7 +11,6 @@
  */
 
 #include <linux/ioport.h>
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <asm/io.h>
diff --git a/drivers/parport/parport_cs.c b/drivers/parport/parport_cs.c
index e9b52e4..e109d76 100644
--- a/drivers/parport/parport_cs.c
+++ b/drivers/parport/parport_cs.c
@@ -36,7 +36,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/ptrace.h>
 #include <linux/slab.h>
 #include <linux/string.h>
diff --git a/drivers/parport/parport_gsc.c b/drivers/parport/parport_gsc.c
index 6e3a60c..bad80a3 100644
--- a/drivers/parport/parport_gsc.c
+++ b/drivers/parport/parport_gsc.c
@@ -22,7 +22,6 @@
 #undef DEBUG	/* undef for production */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/errno.h>
 #include <linux/interrupt.h>
diff --git a/drivers/parport/parport_sunbpp.c b/drivers/parport/parport_sunbpp.c
index dffd6d0b..5a7e51f 100644
--- a/drivers/parport/parport_sunbpp.c
+++ b/drivers/parport/parport_sunbpp.c
@@ -25,7 +25,6 @@
 #include <linux/ioport.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
-#include <linux/init.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
 
diff --git a/drivers/pnp/manager.c b/drivers/pnp/manager.c
index 9357aa7..01db66f 100644
--- a/drivers/pnp/manager.c
+++ b/drivers/pnp/manager.c
@@ -9,7 +9,6 @@
 
 #include <linux/errno.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/pnp.h>
 #include <linux/bitmap.h>
diff --git a/drivers/pnp/pnpbios/bioscalls.c b/drivers/pnp/pnpbios/bioscalls.c
index 769d265..6665b91 100644
--- a/drivers/pnp/pnpbios/bioscalls.c
+++ b/drivers/pnp/pnpbios/bioscalls.c
@@ -4,7 +4,6 @@
 
 #include <linux/types.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/linkage.h>
 #include <linux/kernel.h>
 #include <linux/device.h>
diff --git a/drivers/pps/clients/pps-gpio.c b/drivers/pps/clients/pps-gpio.c
index f41bacf..d849aa3 100644
--- a/drivers/pps/clients/pps-gpio.c
+++ b/drivers/pps/clients/pps-gpio.c
@@ -23,7 +23,6 @@
 #define PPS_GPIO_NAME "pps-gpio"
 #define pr_fmt(fmt) PPS_GPIO_NAME ": " fmt
 
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
diff --git a/drivers/pps/kapi.c b/drivers/pps/kapi.c
index cdad4d9..a19e137 100644
--- a/drivers/pps/kapi.c
+++ b/drivers/pps/kapi.c
@@ -23,7 +23,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/sched.h>
 #include <linux/time.h>
 #include <linux/timex.h>
diff --git a/drivers/pps/kc.c b/drivers/pps/kc.c
index e219db1..256401f 100644
--- a/drivers/pps/kc.c
+++ b/drivers/pps/kc.c
@@ -23,7 +23,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/device.h>
-#include <linux/init.h>
 #include <linux/spinlock.h>
 #include <linux/pps_kernel.h>
 
diff --git a/drivers/pwm/pwm-atmel-tcb.c b/drivers/pwm/pwm-atmel-tcb.c
index f3dcd02..54d1800 100644
--- a/drivers/pwm/pwm-atmel-tcb.c
+++ b/drivers/pwm/pwm-atmel-tcb.c
@@ -6,7 +6,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/clocksource.h>
 #include <linux/clockchips.h>
 #include <linux/interrupt.h>
diff --git a/drivers/pwm/pwm-renesas-tpu.c b/drivers/pwm/pwm-renesas-tpu.c
index aff6ba9..7ecdd5d 100644
--- a/drivers/pwm/pwm-renesas-tpu.c
+++ b/drivers/pwm/pwm-renesas-tpu.c
@@ -16,7 +16,6 @@
 #include <linux/clk.h>
 #include <linux/err.h>
 #include <linux/io.h>
-#include <linux/init.h>
 #include <linux/ioport.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
diff --git a/drivers/rapidio/devices/tsi721_dma.c b/drivers/rapidio/devices/tsi721_dma.c
index 502663f..3c7e563 100644
--- a/drivers/rapidio/devices/tsi721_dma.c
+++ b/drivers/rapidio/devices/tsi721_dma.c
@@ -21,7 +21,6 @@
 
 #include <linux/io.h>
 #include <linux/errno.h>
-#include <linux/init.h>
 #include <linux/ioport.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
diff --git a/drivers/rapidio/rio.c b/drivers/rapidio/rio.c
index 2e8a20c..d202e31 100644
--- a/drivers/rapidio/rio.c
+++ b/drivers/rapidio/rio.c
@@ -18,7 +18,6 @@
 #include <linux/kernel.h>
 
 #include <linux/delay.h>
-#include <linux/init.h>
 #include <linux/rio.h>
 #include <linux/rio_drv.h>
 #include <linux/rio_ids.h>
diff --git a/drivers/regulator/ab8500-ext.c b/drivers/regulator/ab8500-ext.c
index 29c0faa..741c999 100644
--- a/drivers/regulator/ab8500-ext.c
+++ b/drivers/regulator/ab8500-ext.c
@@ -12,7 +12,6 @@
  * ab8500-ext supports the following regulators:
  * - VextSupply3
  */
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/err.h>
 #include <linux/module.h>
diff --git a/drivers/regulator/arizona-ldo1.c b/drivers/regulator/arizona-ldo1.c
index 4f6c205..69bc957 100644
--- a/drivers/regulator/arizona-ldo1.c
+++ b/drivers/regulator/arizona-ldo1.c
@@ -13,7 +13,6 @@
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <linux/init.h>
 #include <linux/bitops.h>
 #include <linux/err.h>
 #include <linux/platform_device.h>
diff --git a/drivers/regulator/arizona-micsupp.c b/drivers/regulator/arizona-micsupp.c
index 034ece7..daf6b45 100644
--- a/drivers/regulator/arizona-micsupp.c
+++ b/drivers/regulator/arizona-micsupp.c
@@ -13,7 +13,6 @@
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <linux/init.h>
 #include <linux/bitops.h>
 #include <linux/err.h>
 #include <linux/platform_device.h>
diff --git a/drivers/regulator/mc13xxx-regulator-core.c b/drivers/regulator/mc13xxx-regulator-core.c
index da48592..41915da 100644
--- a/drivers/regulator/mc13xxx-regulator-core.c
+++ b/drivers/regulator/mc13xxx-regulator-core.c
@@ -22,7 +22,6 @@
 #include <linux/platform_device.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
-#include <linux/init.h>
 #include <linux/err.h>
 #include <linux/module.h>
 #include <linux/of.h>
diff --git a/drivers/regulator/wm8994-regulator.c b/drivers/regulator/wm8994-regulator.c
index 71c5911..b195a3e 100644
--- a/drivers/regulator/wm8994-regulator.c
+++ b/drivers/regulator/wm8994-regulator.c
@@ -13,7 +13,6 @@
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <linux/init.h>
 #include <linux/bitops.h>
 #include <linux/err.h>
 #include <linux/platform_device.h>
diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index 7de9f04..0ea1889 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -22,7 +22,6 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/utsname.h>
-#include <linux/init.h>
 #include <linux/fs.h>
 #include <linux/namei.h>
 #include <linux/slab.h>
diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
index 479ec56..99daa16 100644
--- a/drivers/target/tcm_fc/tfc_cmd.c
+++ b/drivers/target/tcm_fc/tfc_cmd.c
@@ -20,7 +20,6 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/utsname.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/kthread.h>
 #include <linux/types.h>
diff --git a/drivers/target/tcm_fc/tfc_io.c b/drivers/target/tcm_fc/tfc_io.c
index e415af3..4a460cb 100644
--- a/drivers/target/tcm_fc/tfc_io.c
+++ b/drivers/target/tcm_fc/tfc_io.c
@@ -29,7 +29,6 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/utsname.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/kthread.h>
 #include <linux/types.h>
diff --git a/drivers/target/tcm_fc/tfc_sess.c b/drivers/target/tcm_fc/tfc_sess.c
index ae52c08..23201a9 100644
--- a/drivers/target/tcm_fc/tfc_sess.c
+++ b/drivers/target/tcm_fc/tfc_sess.c
@@ -20,7 +20,6 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/utsname.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/kthread.h>
 #include <linux/types.h>
diff --git a/drivers/thermal/ti-soc-thermal/ti-bandgap.c b/drivers/thermal/ti-soc-thermal/ti-bandgap.c
index 74c0e34..5e4f432 100644
--- a/drivers/thermal/ti-soc-thermal/ti-bandgap.c
+++ b/drivers/thermal/ti-soc-thermal/ti-bandgap.c
@@ -25,7 +25,6 @@
 
 #include <linux/module.h>
 #include <linux/export.h>
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/interrupt.h>
 #include <linux/clk.h>
diff --git a/drivers/uio/uio_aec.c b/drivers/uio/uio_aec.c
index 1549fab..2dbc795 100644
--- a/drivers/uio/uio_aec.c
+++ b/drivers/uio/uio_aec.c
@@ -20,7 +20,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/pci.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/cdev.h>
 #include <linux/fs.h>
diff --git a/drivers/uwb/beacon.c b/drivers/uwb/beacon.c
index 57b5ff6..511576e 100644
--- a/drivers/uwb/beacon.c
+++ b/drivers/uwb/beacon.c
@@ -23,7 +23,6 @@
  * FIXME: docs
  */
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/device.h>
 #include <linux/err.h>
diff --git a/drivers/uwb/hwa-rc.c b/drivers/uwb/hwa-rc.c
index 0257f35..fa986bd 100644
--- a/drivers/uwb/hwa-rc.c
+++ b/drivers/uwb/hwa-rc.c
@@ -51,7 +51,6 @@
  *
  *
  */
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/usb.h>
diff --git a/drivers/vlynq/vlynq.c b/drivers/vlynq/vlynq.c
index c0227f9..0530d7f 100644
--- a/drivers/vlynq/vlynq.c
+++ b/drivers/vlynq/vlynq.c
@@ -19,7 +19,6 @@
  * http://www.ti.com/litv/pdf/sprue36a
  */
 
-#include <linux/init.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
diff --git a/drivers/w1/masters/ds2482.c b/drivers/w1/masters/ds2482.c
index e033491..263a950 100644
--- a/drivers/w1/masters/ds2482.c
+++ b/drivers/w1/masters/ds2482.c
@@ -14,7 +14,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
 #include <linux/delay.h>
diff --git a/drivers/w1/masters/w1-gpio.c b/drivers/w1/masters/w1-gpio.c
index 9709b8b..2469045 100644
--- a/drivers/w1/masters/w1-gpio.c
+++ b/drivers/w1/masters/w1-gpio.c
@@ -8,7 +8,6 @@
  * as published by the Free Software Foundation.
  */
 
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
diff --git a/drivers/xen/xen-stub.c b/drivers/xen/xen-stub.c
index bbef194..a9630da 100644
--- a/drivers/xen/xen-stub.c
+++ b/drivers/xen/xen-stub.c
@@ -21,7 +21,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/export.h>
 #include <linux/types.h>
 #include <linux/acpi.h>
-- 
1.8.4.1

