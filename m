Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089Ab3HOJoo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 05:44:44 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:54843 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089Ab3HOJom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 05:44:42 -0400
Subject: [PULL] Miscellaneous trivialities
Date: Thu, 15 Aug 2013 09:44:01 -0000
From: Michael Witten <mfwitten@gmail.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>, David Airlie <airlied@linux.ie>,
        linux-kernel@vger.kernel.org
Message-ID: <e3119c5240504890b8fd3ce2e38231c1-mfwitten@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been sitting on some trivial patches for a while, and I'd just
like to get them out of the way.

Here is the series:

  [1] Docs: Kconfig: For readability, offset modifiers with commas
  [2] Docs: Kconfig: Use consistent whitespace indentation
  [3] Docs: Kconfig: Clean up the radiotap documentation
  [4] Docs: Kconfig: `devlopers' -> `developers'
  [5] Docs: Replace `hotplug' with `udev'
  [6] DRM: comment: halve -> half
  [7] DRM: comment: gdm_proc_lists -> drm_proc_lists
  [8] DRM: cleanup: Remove unused `gamma_size'

  Documentation/networking/README.ipw2200 |   5 +-
  drivers/gpu/drm/drm_fb_helper.c         |   3 -
  drivers/gpu/drm/drm_irq.c               |   4 +-
  drivers/gpu/drm/drm_proc.c              |   2 +-
  drivers/net/wireless/ipw2x00/Kconfig    | 102 ++++++++++++++++----------------
  fs/btrfs/Kconfig                        |   3 +-
  init/Kconfig                            |   4 +-
  7 files changed, 60 insertions(+), 63 deletions(-)

Those commits merge cleanly with:

  28fbc8b6a29c849a3f03a6b05010d4b584055665
  Merge branch 'sched-urgent-for-linus' of
    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
    (2013-08-13 16:58:17 -0700)

and they can be pulled from here:

  https://github.com/mfwitten/linux.git trivial/misc/0

While it is much easier to review the individual commits, a combined
diff is appended to the end of this email in case that is convenient.

Sincerely
Michael Witten

----------------------------------------------------------------

diff --git a/Documentation/networking/README.ipw2200 b/Documentation/networking/README.ipw2200
index b7658be..aeb6494 100644
--- a/Documentation/networking/README.ipw2200
+++ b/Documentation/networking/README.ipw2200
@@ -256,7 +256,7 @@ You can set the debug level via:
 
 Where $VALUE would be a number in the case of this sysfs entry.  The 
 input to sysfs files does not have to be a number.  For example, the 
-firmware loader used by hotplug utilizes sysfs entries for transferring 
+firmware loader used by udev utilizes sysfs entries for transferring
 the firmware image from user space into the driver.
 
 The Intel(R) PRO/Wireless 2915ABG Driver for Linux exposes sysfs entries 
@@ -425,8 +425,7 @@ are made to the driver.  Currently, there are no major changes planned.
 ----------------------------------------------
 
 The driver requires a firmware image, download it and extract the
-files under /lib/firmware (or wherever your hotplug's firmware.agent
-will look for firmware files)
+files under /lib/firmware (or wherever udev will look for firmware files)
 
 The firmware can be downloaded from the following URL:
 
diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
index 3d13ca6e2..a6aab13 100644
--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -888,7 +888,6 @@ static int drm_fb_helper_single_fb_probe(struct drm_fb_helper *fb_helper,
 	int i;
 	struct fb_info *info;
 	struct drm_fb_helper_surface_size sizes;
-	int gamma_size = 0;
 
 	memset(&sizes, 0, sizeof(struct drm_fb_helper_surface_size));
 	sizes.surface_depth = 24;
@@ -938,8 +937,6 @@ static int drm_fb_helper_single_fb_probe(struct drm_fb_helper *fb_helper,
 		desired_mode = fb_helper->crtc_info[i].desired_mode;
 
 		if (desired_mode) {
-			if (gamma_size == 0)
-				gamma_size = fb_helper->crtc_info[i].mode_set.crtc->gamma_size;
 			if (desired_mode->hdisplay < sizes.fb_width)
 				sizes.fb_width = desired_mode->hdisplay;
 			if (desired_mode->vdisplay < sizes.fb_height)
diff --git a/drivers/gpu/drm/drm_irq.c b/drivers/gpu/drm/drm_irq.c
index f92da0a..062dc22 100644
--- a/drivers/gpu/drm/drm_irq.c
+++ b/drivers/gpu/drm/drm_irq.c
@@ -497,8 +497,8 @@ void drm_calc_timestamping_constants(struct drm_crtc *crtc)
 	/* Dot clock in Hz: */
 	dotclock = (u64) crtc->hwmode.clock * 1000;
 
-	/* Fields of interlaced scanout modes are only halve a frame duration.
-	 * Double the dotclock to get halve the frame-/line-/pixelduration.
+	/* Fields of interlaced scanout modes are only half a frame duration.
+	 * Double the dotclock to get half the frame-/line-/pixelduration.
 	 */
 	if (crtc->hwmode.flags & DRM_MODE_FLAG_INTERLACE)
 		dotclock *= 2;
diff --git a/drivers/gpu/drm/drm_proc.c b/drivers/gpu/drm/drm_proc.c
index d7f2324..f7cec4e 100644
--- a/drivers/gpu/drm/drm_proc.c
+++ b/drivers/gpu/drm/drm_proc.c
@@ -87,7 +87,7 @@ static const struct file_operations drm_proc_fops = {
  * \return Zero on success, non-zero on failure
  *
  * Create a given set of proc files represented by an array of
- * gdm_proc_lists in the given root directory.
+ * drm_proc_lists in the given root directory.
  */
 static int drm_proc_create_files(const struct drm_info_list *files, int count,
 			  struct proc_dir_entry *root, struct drm_minor *minor)
diff --git a/drivers/net/wireless/ipw2x00/Kconfig b/drivers/net/wireless/ipw2x00/Kconfig
index 91c0cb3..5abf297 100644
--- a/drivers/net/wireless/ipw2x00/Kconfig
+++ b/drivers/net/wireless/ipw2x00/Kconfig
@@ -12,35 +12,35 @@ config IPW2100
 	select LIB80211
 	select LIBIPW
 	---help---
-          A driver for the Intel PRO/Wireless 2100 Network 
+	  A driver for the Intel PRO/Wireless 2100 Network 
 	  Connection 802.11b wireless network adapter.
 
-          See <file:Documentation/networking/README.ipw2100> for information on
-          the capabilities currently enabled in this driver and for tips
-          for debugging issues and problems.
+	  See <file:Documentation/networking/README.ipw2100> for information on
+	  the capabilities currently enabled in this driver and for tips
+	  for debugging issues and problems.
 
 	  In order to use this driver, you will need a firmware image for it.
-          You can obtain the firmware from
+	  You can obtain the firmware from
 	  <http://ipw2100.sf.net/>.  Once you have the firmware image, you 
 	  will need to place it in /lib/firmware.
 
-          You will also very likely need the Wireless Tools in order to
-          configure your card:
+	  You will also very likely need the Wireless Tools in order to
+	  configure your card:
 
-          <http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/Tools.html>.
+	  <http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/Tools.html>.
 
-          It is recommended that you compile this driver as a module (M)
-          rather than built-in (Y). This driver requires firmware at device
-          initialization time, and when built-in this typically happens
-          before the filesystem is accessible (hence firmware will be
-          unavailable and initialization will fail). If you do choose to build
-          this driver into your kernel image, you can avoid this problem by
-          including the firmware and a firmware loader in an initramfs.
+	  It is recommended that you compile this driver as a module (M)
+	  rather than built-in (Y). This driver requires firmware at device
+	  initialization time, and when built-in this typically happens
+	  before the filesystem is accessible (hence firmware will be
+	  unavailable and initialization will fail). If you do choose to build
+	  this driver into your kernel image, you can avoid this problem by
+	  including the firmware and a firmware loader in an initramfs.
  
 config IPW2100_MONITOR
-        bool "Enable promiscuous mode"
-        depends on IPW2100
-        ---help---
+	bool "Enable promiscuous mode"
+	depends on IPW2100
+	---help---
 	  Enables promiscuous/monitor mode support for the ipw2100 driver.
 	  With this feature compiled into the driver, you can switch to 
 	  promiscuous mode via the Wireless Tool's Monitor mode.  While in this
@@ -73,35 +73,35 @@ config IPW2200
 	select LIB80211
 	select LIBIPW
 	---help---
-          A driver for the Intel PRO/Wireless 2200BG and 2915ABG Network
+	  A driver for the Intel PRO/Wireless 2200BG and 2915ABG Network
 	  Connection adapters. 
 
-          See <file:Documentation/networking/README.ipw2200> for 
+	  See <file:Documentation/networking/README.ipw2200> for 
 	  information on the capabilities currently enabled in this 
 	  driver and for tips for debugging issues and problems.
 
 	  In order to use this driver, you will need a firmware image for it.
-          You can obtain the firmware from
+	  You can obtain the firmware from
 	  <http://ipw2200.sf.net/>.  See the above referenced README.ipw2200 
 	  for information on where to install the firmware images.
 
-          You will also very likely need the Wireless Tools in order to
-          configure your card:
+	  You will also very likely need the Wireless Tools in order to
+	  configure your card:
 
-          <http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/Tools.html>.
+	  <http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/Tools.html>.
 
-          It is recommended that you compile this driver as a module (M)
-          rather than built-in (Y). This driver requires firmware at device
-          initialization time, and when built-in this typically happens
-          before the filesystem is accessible (hence firmware will be
-          unavailable and initialization will fail). If you do choose to build
-          this driver into your kernel image, you can avoid this problem by
-          including the firmware and a firmware loader in an initramfs.
+	  It is recommended that you compile this driver as a module (M)
+	  rather than built-in (Y). This driver requires firmware at device
+	  initialization time, and when built-in this typically happens
+	  before the filesystem is accessible (hence firmware will be
+	  unavailable and initialization will fail). If you do choose to build
+	  this driver into your kernel image, you can avoid this problem by
+	  including the firmware and a firmware loader in an initramfs.
 
 config IPW2200_MONITOR
-        bool "Enable promiscuous mode"
-        depends on IPW2200
-        ---help---
+	bool "Enable promiscuous mode"
+	depends on IPW2200
+	---help---
 	  Enables promiscuous/monitor mode support for the ipw2200 driver.
 	  With this feature compiled into the driver, you can switch to 
 	  promiscuous mode via the Wireless Tool's Monitor mode.  While in this
@@ -112,32 +112,32 @@ config IPW2200_RADIOTAP
 	depends on IPW2200_MONITOR
 
 config IPW2200_PROMISCUOUS
-	bool "Enable creation of a RF radiotap promiscuous interface"
+	bool "Enable creation of a radiotap promiscuous interface"
 	depends on IPW2200_MONITOR
 	select IPW2200_RADIOTAP
 	---help---
-          Enables the creation of a second interface prefixed 'rtap'. 
-          This second interface will provide every received in radiotap
-	  format.
+	  Enables the creation of a second interface (the name of which
+	  is prefixed with 'rtap'), which provides every received frame
+	  in radiotap format.
+
+	  This is useful for performing wireless network analysis while
+	  maintaining an active association.
 
-          This is useful for performing wireless network analysis while
-          maintaining an active association.
+	  Example usage:
 
-          Example usage:
+	    % modprobe ipw2200 rtap_iface=1
+	    % ifconfig rtap0 up
+	    % tethereal -i rtap0
 
-            % modprobe ipw2200 rtap_iface=1
-            % ifconfig rtap0 up
-            % tethereal -i rtap0
+	  If you do not specify 'rtap_iface=1' as a module parameter, then
+	  the rtap interface will not be created automatically, but it can
+	  still be created via sysfs:
 
-          If you do not specify 'rtap_iface=1' as a module parameter then 
-          the rtap interface will not be created and you will need to turn 
-          it on via sysfs:
-	
-            % echo 1 > /sys/bus/pci/drivers/ipw2200/*/rtap_iface
+	    % echo 1 > /sys/bus/pci/drivers/ipw2200/*/rtap_iface
 
 config IPW2200_QOS
-        bool "Enable QoS support"
-        depends on IPW2200
+	bool "Enable QoS support"
+	depends on IPW2200
 
 config IPW2200_DEBUG
 	bool "Enable full debugging output in IPW2200 module."
diff --git a/fs/btrfs/Kconfig b/fs/btrfs/Kconfig
index 2b3b832..e374bf9 100644
--- a/fs/btrfs/Kconfig
+++ b/fs/btrfs/Kconfig
@@ -59,7 +59,8 @@ config BTRFS_FS_RUN_SANITY_TESTS
 	help
 	  This will run some basic sanity tests on the free space cache
 	  code to make sure it is acting as it should.  These are mostly
-	  regression tests and are only really interesting to btrfs devlopers.
+	  regression tests and are only really interesting to btrfs
+	  developers.
 
 	  If unsure, say N.
 
diff --git a/init/Kconfig b/init/Kconfig
index 247084b..6ba39b6 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1093,7 +1093,7 @@ config UTS_NS
 	bool "UTS namespace"
 	default y
 	help
-	  In this namespace tasks see different info provided with the
+	  In this namespace, tasks see different info provided with the
 	  uname() system call
 
 config IPC_NS
@@ -1101,7 +1101,7 @@ config IPC_NS
 	depends on (SYSVIPC || POSIX_MQUEUE)
 	default y
 	help
-	  In this namespace tasks work with IPC ids which correspond to
+	  In this namespace, tasks work with IPC ids which correspond to
 	  different IPC objects in different namespaces.
 
 config USER_NS
