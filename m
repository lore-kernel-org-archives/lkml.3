Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372Ab3GHIwI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 04:52:08 -0400
Received: from 17.mo3.mail-out.ovh.net ([87.98.178.58]:58820 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752159Ab3GHIwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 04:52:05 -0400
Date: Mon, 8 Jul 2013 10:52:05 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fbdev <linux-fbdev@vger.kernel.org>, linux-kernel@vger.kernel.org
X-Ovh-Mailout: 178.32.228.3 (mo3.mail-out.ovh.net)
Subject: [PULL] fbdev changes for 3.11
Message-ID: <20130708085205.GB18477@ns203013.ovh.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Ovh-Tracer-Id: 10513090382092282682
X-Ovh-Remote: 91.121.171.124 (ns203013.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedrtdejucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedrtdejucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

	Here is the first fbdev pull for 3.11

The following changes since commit 317ddd256b9c24b0d78fa8018f80f1e495481a10:

  Linux 3.10-rc5 (2013-06-08 17:41:04 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/plagnioj/linux-fbdev.git tags/fbdev-for-3.11

for you to fetch changes up to 1b6c79361ba5ce30b40f0f7d6fc2421dc5fcbe0c:

  video: imxfb: Add DT support (2013-07-08 16:36:49 +0800)

----------------------------------------------------------------
Various fbdev changes for 3.11

 * xilinxfb updates
 * Small cleanups and fixes to multiple drivers
 * OMAP display subsystem bug updates
 * imxfb dt support

----------------------------------------------------------------
Borislav Petkov (1):
      uvesafb: Correct/simplify warning message

Dan Carpenter (1):
      fbmem: return -EFAULT on copy_to_user() failure

Emil Goode (1):
      OMAPDSS: Remove kfree for memory allocated with devm_kzalloc

Fabio Estevam (1):
      video: of_display_timing.h: Declare 'display_timing'

Jean-Christophe PLAGNIOL-VILLARD (4):
      Merge branch 'fbdev-3.11' of git://gitorious.org/linux-omap-dss2/linux into fbdev/for-next
      Merge tag 'omapdss-for-3.11-1' of git://gitorious.org/linux-omap-dss2/linux into fbdev/for-next
      Merge tag 'omapdss-for-3.11-2' of git://gitorious.org/linux-omap-dss2/linux into fbdev/for-next
      Merge tag 'fbdev-3.11-2' of git://gitorious.org/linux-omap-dss2/linux into fbdev/for-next

Jing Xiang (2):
      video: mmp: fix memcpy wrong size for mmp_addr issue
      video: mmp: fix graphics/video layer enable/mask swap issue

Jingoo Han (2):
      video: remove unnecessary platform_set_drvdata()
      video: replace strict_strtoul() with kstrtoul()

Lars-Peter Clausen (1):
      fbdev: bfin-lq035q1-fb: Use dev_pm_ops

Markus Pargmann (1):
      video: imxfb: Add DT support

Maxime Ripard (4):
      video: ssd1307fb: Add support for SSD1306 OLED controller
      video: ssd1307fb: Rework the communication functions
      video: ssd1307fb: Speed up the communication with the controller
      video: ssd1307fb: Make use of horizontal addressing mode

Michal Simek (7):
      video: xilinxfb: Fix OF probing on little-endian systems
      video: xilinxfb: Do not name out_be32 in function name
      video: xilinxfb: Rename PLB_ACCESS_FLAG to BUS_ACCESS_FLAG
      video: xilinxfb: Use drvdata->regs_phys instead of physaddr
      video: xilinxfb: Group bus initialization
      video: xilinxfb: Add support for little endian accesses
      video: xilinxfb: Use driver for Xilinx ARM Zynq

Randy Dunlap (2):
      fb: fix atyfb build warning
      fb: fix atyfb unused data warnings

Sachin Kamat (5):
      video: smscufx: Use NULL instead of 0
      video: udlfb: Use NULL instead of 0
      video: udlfb: Make local symbol static
      video: imxfb: Make local symbols static
      video: i740fb: Make i740fb_init static

Sergey Kibrik (1):
      OMAPDSS: gracefully disable overlay at error

Tomi Valkeinen (62):
      videomode: don't allocate mem in of_get_display_timing()
      videomode: implement public of_get_display_timing()
      OMAPDSS: add pdata->default_display_name
      OMAPDSS: only probe pdata if there's one
      OMAPDSS: add omap_dss_find_output()
      OMAPDSS: add omap_dss_find_output_by_node()
      OMAPDSS: fix dss_get_ctx_loss_count for DT
      OMAPDSS: clean up dss_[ovl|mgr]_get_device()
      OMAPDSS: add helpers to get mgr or output from display
      OMAPDSS: split overlay manager creation
      OMAPDRM: fix overlay manager handling
      OMAPDSS: Implement display (dis)connect support
      OMAPDSS: CORE: use devm_regulator_get
      OMAPDSS: DSI: cleanup regulator init
      OMAPDSS: DPI: cleanup pll & regulator init
      OMAPDSS: DPI: fix regulators for DT
      OMAPDSS: HDMI: add hdmi_init_regulator
      OMAPDSS: SDI: clean up regulator init
      OMAPDSS: SDI: fix regulators for DT
      OMAPDSS: VENC: clean up regulator init
      OMAPDSS: add videomode conversion support
      OMAPDSS: remove dssdev uses in trivial cases
      OMAPDSS: add panel list
      OMAPDSS: use the panel list in omap_dss_get_next_device
      OMAPDSS: don't use dss bus in suspend/resume
      OMAPDSS: implement display sysfs without dss bus
      OMAPDSS: Add panel dev pointer to dssdev
      OMAPDSS: remove omap_dss_start/stop_device()
      OMAPDSS: combine omap_dss_output into omap_dss_device
      OMAPDSS: omapdss.h: add owner field to omap_dss_device
      OMAPDSS: add module_get/put to omap_dss_get/put_device()
      OMAPDSS: add THIS_MODULE owner to DSS outputs
      OMAPDSS: output: increase refcount in find_output funcs
      OMAPFB: use EPROBE_DEFER if default display is not present
      OMAPDSS: HDMI: clean up PHY power handling
      OMAPDSS: HDMI clean up hpd_gpio
      OMAPDSS: remove unused fields in omap_dss_device
      OMAPDSS: remove dispc's dependency to VENC/HDMI
      OMAPDSS: public omapdss_register_output()
      OMAPDSS: modify get/find functions to go through the device chain
      OMAPDSS: add OMAP_DISPLAY_TYPE_DVI
      drm/omap: DVI connector fix
      OMAPDSS: DPI: Add ops
      OMAPDSS: SDI: Add ops
      OMAPDSS: DVI: Add ops
      OMAPDSS: AnalogTV: Add ops
      OMAPDSS: HDMI: Add ops
      OMAPDSS: DSI: Add ops
      OMAPDSS: Add new TFP410 Encoder driver
      OMAPDSS: Add new TPD12S015 Encoder driver
      OMAPDSS: Add new DVI Connector driver
      OMAPDSS: Add new HDMI Connector driver
      OMAPDSS: Add new Analog TV Connector driver
      OMAPDSS: Add new simple DPI panel driver
      OMAPDSS: Add new DSI Command Mode panel  driver
      OMAPDSS: Add Sony ACX565AKM panel driver
      OMAPDSS: Add LG.Philips LB035Q02 panel driver
      OMAPDSS: Add Sharp LS037V7DW01 panel driver
      OMAPDSS: Add TPO TD043MTEA1 panel driver
      OMAPDSS: Add NEC NL8048HL11 panel driver
      OMAPDSS: panels: add Kconfig comment
      OMAPDSS: DPI: Fix wrong pixel clock limit

Vincent Stehlé (1):
      fb: make fp_get_options name argument const

Wei Yongjun (1):
      video: mxsfb: remove redundant dev_err call in mxsfb_probe()

Yijing Wang (2):
      aty128fb: use pdev->pm_cap instead of pci_find_capability(..,PCI_CAP_ID_PM)
      radeon: use pdev->pm_cap instead of pci_find_capability(..,PCI_CAP_ID_PM)

 Documentation/devicetree/bindings/video/fsl,imx-fb.txt      |   51 ++++++
 Documentation/devicetree/bindings/video/ssd1307fb.txt       |   10 +-
 drivers/gpu/drm/omapdrm/omap_crtc.c                         |   46 +++++-
 drivers/gpu/drm/omapdrm/omap_drv.c                          |   27 +++-
 drivers/gpu/drm/omapdrm/omap_drv.h                          |    1 +
 drivers/video/Kconfig                                       |    4 +-
 drivers/video/aty/aty128fb.c                                |    2 +-
 drivers/video/aty/atyfb_base.c                              |    9 +-
 drivers/video/aty/radeon_pm.c                               |    2 +-
 drivers/video/au1100fb.c                                    |    1 -
 drivers/video/bf54x-lq043fb.c                               |    1 -
 drivers/video/bfin-lq035q1-fb.c                             |   24 +--
 drivers/video/bfin-t350mcqb-fb.c                            |    2 -
 drivers/video/ep93xx-fb.c                                   |    2 -
 drivers/video/fbmem.c                                       |    6 +-
 drivers/video/fsl-diu-fb.c                                  |    4 +-
 drivers/video/i740fb.c                                      |    2 +-
 drivers/video/imxfb.c                                       |  201 ++++++++++++++++++-----
 drivers/video/jz4740_fb.c                                   |    2 -
 drivers/video/mmp/fb/mmpfb.c                                |    1 -
 drivers/video/mmp/hw/mmp_ctrl.c                             |    9 +-
 drivers/video/mxsfb.c                                       |    3 -
 drivers/video/nuc900fb.c                                    |    1 -
 drivers/video/of_display_timing.c                           |   55 +++++--
 drivers/video/omap2/Kconfig                                 |    1 +
 drivers/video/omap2/Makefile                                |    1 +
 drivers/video/omap2/displays-new/Kconfig                    |   73 +++++++++
 drivers/video/omap2/displays-new/Makefile                   |   12 ++
 drivers/video/omap2/displays-new/connector-analog-tv.c      |  265 ++++++++++++++++++++++++++++++
 drivers/video/omap2/displays-new/connector-dvi.c            |  351 ++++++++++++++++++++++++++++++++++++++++
 drivers/video/omap2/displays-new/connector-hdmi.c           |  375 ++++++++++++++++++++++++++++++++++++++++++
 drivers/video/omap2/displays-new/encoder-tfp410.c           |  267 ++++++++++++++++++++++++++++++
 drivers/video/omap2/displays-new/encoder-tpd12s015.c        |  395 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/video/omap2/displays-new/panel-dpi.c                |  270 +++++++++++++++++++++++++++++++
 drivers/video/omap2/displays-new/panel-dsi-cm.c             | 1336 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/video/omap2/displays-new/panel-lgphilips-lb035q02.c |  358 ++++++++++++++++++++++++++++++++++++++++
 drivers/video/omap2/displays-new/panel-nec-nl8048hl11.c     |  394 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/video/omap2/displays-new/panel-sharp-ls037v7dw01.c  |  324 +++++++++++++++++++++++++++++++++++++
 drivers/video/omap2/displays-new/panel-sony-acx565akm.c     |  865 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/video/omap2/displays-new/panel-tpo-td043mtea1.c     |  646 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/video/omap2/displays/Kconfig                        |    2 +-
 drivers/video/omap2/displays/panel-acx565akm.c              |   16 +-
 drivers/video/omap2/displays/panel-generic-dpi.c            |   26 +--
 drivers/video/omap2/displays/panel-lgphilips-lb035q02.c     |   10 +-
 drivers/video/omap2/displays/panel-n8x0.c                   |   30 ++--
 drivers/video/omap2/displays/panel-nec-nl8048hl11-01b.c     |    4 +-
 drivers/video/omap2/displays/panel-picodlp.c                |   34 ++--
 drivers/video/omap2/displays/panel-sharp-ls037v7dw01.c      |   10 +-
 drivers/video/omap2/displays/panel-taal.c                   |  170 +++++++++----------
 drivers/video/omap2/displays/panel-tfp410.c                 |   32 ++--
 drivers/video/omap2/displays/panel-tpo-td043mtea1.c         |   36 ++---
 drivers/video/omap2/dss/Kconfig                             |    1 +
 drivers/video/omap2/dss/apply.c                             |   59 ++++---
 drivers/video/omap2/dss/core.c                              |  108 +++++++------
 drivers/video/omap2/dss/dispc-compat.c                      |    3 +-
 drivers/video/omap2/dss/dispc.c                             |   24 ++-
 drivers/video/omap2/dss/display-sysfs.c                     |  154 ++++++++++--------
 drivers/video/omap2/dss/display.c                           |  247 +++++++++++++++++++---------
 drivers/video/omap2/dss/dpi.c                               |  209 ++++++++++++++++--------
 drivers/video/omap2/dss/dsi.c                               |  232 ++++++++++++++++----------
 drivers/video/omap2/dss/dss.c                               |    3 +-
 drivers/video/omap2/dss/dss.h                               |   35 +---
 drivers/video/omap2/dss/dss_features.c                      |    1 -
 drivers/video/omap2/dss/hdmi.c                              |  345 ++++++++++++++++++++++++++++++++-------
 drivers/video/omap2/dss/manager-sysfs.c                     |   47 ++++--
 drivers/video/omap2/dss/manager.c                           |   29 +++-
 drivers/video/omap2/dss/output.c                            |   87 +++++++++-
 drivers/video/omap2/dss/rfbi.c                              |   43 +++--
 drivers/video/omap2/dss/sdi.c                               |  143 ++++++++++++----
 drivers/video/omap2/dss/ti_hdmi.h                           |    5 +-
 drivers/video/omap2/dss/ti_hdmi_4xxx_ip.c                   |   87 +++++-----
 drivers/video/omap2/dss/ti_hdmi_4xxx_ip.h                   |    1 +
 drivers/video/omap2/dss/venc.c                              |  163 ++++++++++++-------
 drivers/video/omap2/dss/venc_panel.c                        |   16 +-
 drivers/video/omap2/omapfb/omapfb-ioctl.c                   |    9 +-
 drivers/video/omap2/omapfb/omapfb-main.c                    |   27 ++--
 drivers/video/pxa3xx-gcu.c                                  |    2 -
 drivers/video/pxafb.c                                       |    1 -
 drivers/video/s3c2410fb.c                                   |    2 -
 drivers/video/sa1100fb.c                                    |    1 -
 drivers/video/sh7760fb.c                                    |    1 -
 drivers/video/sh_mipi_dsi.c                                 |    1 -
 drivers/video/smscufx.c                                     |    2 +-
 drivers/video/ssd1307fb.c                                   |  392 ++++++++++++++++++++++++++++++++------------
 drivers/video/tmiofb.c                                      |    3 -
 drivers/video/udlfb.c                                       |   12 +-
 drivers/video/uvesafb.c                                     |    4 +-
 drivers/video/vga16fb.c                                     |    1 -
 drivers/video/vt8500lcdfb.c                                 |    1 -
 drivers/video/wm8505fb.c                                    |    2 +-
 drivers/video/xilinxfb.c                                    |  135 ++++++++--------
 include/linux/fb.h                                          |    2 +-
 include/video/of_display_timing.h                           |    3 +
 include/video/omap-panel-data.h                             |  209 ++++++++++++++++++++++++
 include/video/omapdss.h                                     |  293 ++++++++++++++++++++++++++++-----
 95 files changed, 8700 insertions(+), 1214 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/video/fsl,imx-fb.txt
 create mode 100644 drivers/video/omap2/displays-new/Kconfig
 create mode 100644 drivers/video/omap2/displays-new/Makefile
 create mode 100644 drivers/video/omap2/displays-new/connector-analog-tv.c
 create mode 100644 drivers/video/omap2/displays-new/connector-dvi.c
 create mode 100644 drivers/video/omap2/displays-new/connector-hdmi.c
 create mode 100644 drivers/video/omap2/displays-new/encoder-tfp410.c
 create mode 100644 drivers/video/omap2/displays-new/encoder-tpd12s015.c
 create mode 100644 drivers/video/omap2/displays-new/panel-dpi.c
 create mode 100644 drivers/video/omap2/displays-new/panel-dsi-cm.c
 create mode 100644 drivers/video/omap2/displays-new/panel-lgphilips-lb035q02.c
 create mode 100644 drivers/video/omap2/displays-new/panel-nec-nl8048hl11.c
 create mode 100644 drivers/video/omap2/displays-new/panel-sharp-ls037v7dw01.c
 create mode 100644 drivers/video/omap2/displays-new/panel-sony-acx565akm.c
 create mode 100644 drivers/video/omap2/displays-new/panel-tpo-td043mtea1.c

Best Regards,
J.
