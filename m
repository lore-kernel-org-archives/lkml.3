Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835Ab3KQD22 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 22:28:28 -0500
Received: from void.printf.net ([89.145.121.20]:38687 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753595Ab3KQD2W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 22:28:22 -0500
From: Chris Ball <cjb@laptop.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] MMC updates for 3.13-rc1
Date: Sun, 17 Nov 2013 03:28:20 +0000
Message-ID: <868uwnlnaj.fsf@void.printf.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git tags/mmc-updates-for-3.13-rc1

to receive the MMC merge for 3.13.  These patches have been tested in
linux-next, and there's a conflict with the resolution below.  Thanks.


diff --cc drivers/mmc/host/mvsdio.c
index deecee0,22ba4d3..0000000
--- a/drivers/mmc/host/mvsdio.c
+++ b/drivers/mmc/host/mvsdio.c
@@@ -872,10 -845,7 +845,8 @@@ static const struct of_device_id mvsdio
  MODULE_DEVICE_TABLE(of, mvsdio_dt_ids);
  
  static struct platform_driver mvsd_driver = {
 -	.remove		= __exit_p(mvsd_remove),
 +	.probe		= mvsd_probe,
 +	.remove		= mvsd_remove,
- 	.suspend	= mvsd_suspend,
- 	.resume		= mvsd_resume,
  	.driver		= {
  		.name	= DRIVER_NAME,
  		.of_match_table = mvsdio_dt_ids,

  
The following changes since commit 4b97280675f45c1650ee4e388bd711ecbb18c4b4:

  Merge tag 'stable/for-linus-3.12-rc2-tag' of git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip (2013-09-25 15:50:53 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git tags/mmc-updates-for-3.13-rc1

for you to fetch changes up to e395c4387c746b4cc7aace4c44baecd7e69a3249:

  mmc: wbsd: Silence compiler warning (2013-11-08 14:32:03 -0500)

----------------------------------------------------------------
MMC highlights for 3.13:
Core:
 - Improve runtime PM support, remove mmc_{suspend,resume}_host().
 - Add MMC_CAP_RUNTIME_RESUME, for delaying MMC resume until we're
   outside of the resume sequence (in runtime_resume) to decrease
   system resume time.

Drivers:
 - dw_mmc: Support HS200 mode.
 - sdhci-eshdc-imx: Support SD3.0 SDR clock tuning, DDR on IMX6.
 - sdhci-pci: Add support for Intel Clovertrail and Merrifield.

----------------------------------------------------------------
Alexey Neyman (1):
      mmc: sdhci: Avoid needless loop while handling SDIO interrupts in sdhci_irq

Axel Lin (3):
      mmc: sdhci-bcm-kona: Use sdhci_pltfm_unregister instead of open coded
      mmc: sdhci-bcm2835: Use sdhci_pltfm_unregister instead of open coded
      mmc: wmt-sdmmc: Simplify wmt_set_sd_power implementation

Balaji T K (3):
      mmc: omap_hsmmc: Fix pbias_disable for omap4
      mmc: omap_hsmmc: correct max value of clkd
      mmc: omap_hsmmc: remove unused no_off

David Cohen (1):
      mmc: sdhci-pci: add Intel Merrifield support

Dong Aisheng (16):
      mmc: sdhci: add hooks for platform specific tuning
      mmc: sdhci: allow platform access of sdhci_send_command
      mmc: sdhci-esdhc: move common esdhc_set_clock to platform driver
      mmc: sdhci-esdhc-imx: support real clock on and off for imx6q
      mmc: sdhci-esdhc-imx: add sd3.0 SDR clock tuning support
      mmc: sdhci-esdhc-imx: change pinctrl state according to uhs mode
      mmc: sdhci-esdhc-imx: correct pre_div for imx6q
      mmc: sdhci-esdhc-imx: set actual_clock in clock setting
      mmc: sdhci-esdhc-imx: add std tuning support for mx6sl
      mmc: sdhci-esdhc-imx: fix reading cap_1 register value for mx6sl
      mmc: sdhci: report error once the maximum tuning loops exhausted or timeout
      mmc: sdhci-esdhc-imx: add DDR mode support for mx6
      mmc: sdhci-esdhc-imx: add delay line setting support
      mmc: sdhci-esdhc-imx: enable SDR50 tuning for imx6q/dl
      mmc: sdhci-esdhc-imx: add preset value quirk for mx6
      mmc: sdhci: remove unneeded call when have preset value quirk

Doug Anderson (4):
      mmc: dw_mmc: don't queue up a card detect at slot startup
      mmc: dw_mmc: Add exynos resume_noirq callback to clear WAKEUP_INT
      mmc: dw_mmc: Honor requests to set the clock to 0
      mmc: dw_mmc: Set timeout to max upon resume

Eric Ernst (1):
      mmc: sdhci-pci: Add SDIO/MMC device ID support for Intel Clovertrail

Grant Grundler (1):
      mmc: core: remove dead function mmc_try_claim_host

Jackey Shen (1):
      mmc: core: clean up duplicate macros

Jianpeng Ma (1):
      mmc: omap_hsmmc: fix timeout for cmd and data soft reset

Kuninori Morimoto (1):
      sh: ecovec: fixup compile error on sdhi

Ludovic Desroches (1):
      mmc: atmel-mci: abort transfer on timeout error

Rodolfo Giometti (1):
      mmc: atmel-mci: fix oops in atmci_tasklet_func

Sachin Kamat (3):
      mmc: mvsdio: Convert to devm_ioremap_resource
      mmc: dw_mmc-socfpga: Remove redundant of_match_ptr
      mmc: dw_mmc-socfpga: Staticize dw_mci_socfpga_probe

Seungwon Jeon (15):
      mmc: dw_mmc: add support tuning scheme
      mmc: dw_mmc: exynos: add variable delay tuning sequence
      mmc: dw_mmc: exynos: adjust the clock rate with speed mode
      mmc: dw_mmc: add the capability to support hs200 mode
      mmc: dw_mmc: move supports-highspeed of quirks to caps
      mmc: dw_mmc: set the supported max/min frequency
      mmc: dw_mmc: adjust the fifoth with block size
      mmc: dw_mmc: control card read threshold
      mmc: dw_mmc: fix error handling on response error
      mmc: dw_mmc: guarantee stop-abort cmd in data errors
      mmc: dw_mmc: rework the code related to cmd/data completion
      mmc: dw_mmc: gather each reset code into functions
      mmc: dw_mmc: amend use of idmac sw reset
      mmc: dw_mmc: fix the transfer termination in IDMAC mode
      mmc: add ignorance case for CMD13 CRC error

Shawn Guo (4):
      mmc: sdhci-esdhc-imx: add flag ESDHC_FLAG_ENGCM07207
      mmc: sdhci-esdhc-imx: add flag ESDHC_FLAG_USDHC
      mmc: sdhci-esdhc-imx: pdev->id_entry should be immutable
      mmc: sdhci-esdhc-imx: create struct esdhc_soc_data

Sonic Zhang (1):
      mmc: bfin_sdh: Forgot to write SDH_CFG register in function set_ios.

Tony Lindgren (1):
      mmc: omap_hsmmc: context save and restore for DT

Ulf Hansson (44):
      mmc: core: Do not poll for busy with status cmd for all switch cmds
      mmc: core: Let mmc_power_up|cycle take ocr as parameter
      mmc: core: Let mmc_set_signal_voltage take ocr as parameter
      mmc: core: Remove unnecessary retry mechanism at SDIO attach
      mmc: core: Cleanup code for setting ocr mask for SDIO
      mmc: core: Move cached value of the negotiated ocr mask to card struct
      mmc: core: Prevent violation of specs while initializing cards
      mmc: core: Collect common code for card ocr validation
      mmc: core: Signal wakeup event at card insert/removal
      mmc: atmel-mci: Remove redundant suspend and resume callbacks
      mmc: au1xmmc: Move away from using deprecated APIs
      mmc: bfin_sdh: Move away from using deprecated APIs
      mmc: cb710: Move away from using deprecated APIs
      mmc: davinci_mmc: Move away from using deprecated APIs
      mmc: dw_mmc: Move away from using deprecated APIs
      mmc: jz4740: Move away from using deprecated APIs
      mmc: msm_sdcc: Move away from using deprecated APIs
      mmc: mvsdio: Remove redundant suspend and resume callbacks
      mmc: vub300: Move away from using deprecated APIs
      mmc: sdhci: Move away from using deprecated APIs
      mmc: tifm_sd: Move away from using deprecated APIs
      mmc: omap: Remove redundant suspend and resume callbacks
      mmc: mxs-mmc: Move away from using deprecated APIs
      mmc: mxcmmc: Move away from using deprecated APIs
      mmc: wmt-sdmmc: Move away from using deprecated APIs
      mmc: s3cmci: Remove redundant suspend and resume callbacks
      mmc: pxamci: Remove redundant suspend and resume callbacks
      mmc: wbsd: Move away from using deprecated APIs
      mmc: rtsx: Remove redundant suspend and resume callbacks
      mmc: sdricoh_cs: Move away from using deprecated APIs
      mmc: sh_mmcif: Move away from using deprecated APIs
      mmc: tmio: Move away from using deprecated APIs
      mmc: via-sdmmc: Move away from using deprecated APIs
      mmc: mmci: Move away from using deprecated APIs
      mmc: core: Remove deprecated mmc_suspend|resume_host APIs
      MIPS: db1235: Don't use MMC_CLKGATE
      mmc: Don't force card to active state when entering suspend/shutdown
      mmc: core: Remove redundant mmc_power_up|off at runtime callbacks
      mmc: core: Improve runtime PM support during suspend/resume for sd/mmc
      mmc: core: Add MMC_CAP_RUNTIME_RESUME to resume at runtime_resume
      mmc: sh_mmcif: Convert to PM macros when defining dev_pm_ops
      mmc: sh_mmcif: Convert to clk_prepare|unprepare
      mmc: core: Silence compiler warning in __mmc_switch
      mmc: wbsd: Silence compiler warning

Yuvaraj Kumar C D (5):
      mmc: dw_mmc: exynos: move the exynos private init
      mmc: dw_mmc: socfpga: move socfpga private init
      mmc: dw_mmc: move the platform specific init call
      mmc: dw_mmc: exynos: configure SMU in exynos5420
      mmc: dw_mmc: exynos: Revert the sdr_timing assignment

 .../devicetree/bindings/mmc/fsl-imx-esdhc.txt      |   5 +
 .../devicetree/bindings/mmc/synopsis-dw-mshc.txt   |   9 +
 arch/mips/configs/db1235_defconfig                 |   1 -
 arch/sh/boards/mach-ecovec24/setup.c               |   1 +
 drivers/mmc/card/block.c                           |   2 -
 drivers/mmc/core/bus.c                             |   2 +-
 drivers/mmc/core/core.c                            | 154 ++----
 drivers/mmc/core/core.h                            |   6 +-
 drivers/mmc/core/mmc.c                             | 127 +++--
 drivers/mmc/core/mmc_ops.c                         |  96 ++--
 drivers/mmc/core/sd.c                              | 118 ++--
 drivers/mmc/core/sdio.c                            |  82 +--
 drivers/mmc/host/atmel-mci.c                       |  82 +--
 drivers/mmc/host/au1xmmc.c                         |   7 +-
 drivers/mmc/host/bfin_sdh.c                        |  15 +-
 drivers/mmc/host/cb710-mmc.c                       |  10 +-
 drivers/mmc/host/davinci_mmc.c                     |  26 +-
 drivers/mmc/host/dw_mmc-exynos.c                   | 291 +++++++++-
 drivers/mmc/host/dw_mmc-pltfm.c                    |   7 -
 drivers/mmc/host/dw_mmc-socfpga.c                  |  34 +-
 drivers/mmc/host/dw_mmc.c                          | 604 ++++++++++++++-------
 drivers/mmc/host/dw_mmc.h                          |  55 ++
 drivers/mmc/host/jz4740_mmc.c                      |   4 -
 drivers/mmc/host/mmci.c                            |  17 +-
 drivers/mmc/host/msm_sdcc.c                        |  27 +-
 drivers/mmc/host/mvsdio.c                          |  35 +-
 drivers/mmc/host/mxcmmc.c                          |  12 +-
 drivers/mmc/host/mxs-mmc.c                         |  12 +-
 drivers/mmc/host/omap.c                            |  53 --
 drivers/mmc/host/omap_hsmmc.c                      | 112 ++--
 drivers/mmc/host/pxamci.c                          |  32 --
 drivers/mmc/host/rtsx_pci_sdmmc.c                  |  35 +-
 drivers/mmc/host/s3cmci.c                          |  29 -
 drivers/mmc/host/sdhci-bcm-kona.c                  |  14 +-
 drivers/mmc/host/sdhci-bcm2835.c                   |   8 +-
 drivers/mmc/host/sdhci-esdhc-imx.c                 | 550 +++++++++++++++++--
 drivers/mmc/host/sdhci-esdhc.h                     |  37 --
 drivers/mmc/host/sdhci-of-esdhc.c                  |  35 +-
 drivers/mmc/host/sdhci-pci.c                       |  76 +++
 drivers/mmc/host/sdhci.c                           |  44 +-
 drivers/mmc/host/sdhci.h                           |   3 +
 drivers/mmc/host/sdricoh_cs.c                      |   3 -
 drivers/mmc/host/sh_mmcif.c                        |  32 +-
 drivers/mmc/host/tifm_sd.c                         |   4 +-
 drivers/mmc/host/tmio_mmc_pio.c                    |   9 +-
 drivers/mmc/host/via-sdmmc.c                       |   7 +-
 drivers/mmc/host/vub300.c                          |  18 +-
 drivers/mmc/host/wbsd.c                            |  34 +-
 drivers/mmc/host/wmt-sdmmc.c                       |  57 +-
 include/linux/mmc/card.h                           |   7 +-
 include/linux/mmc/core.h                           |   4 +-
 include/linux/mmc/dw_mmc.h                         |   4 +
 include/linux/mmc/host.h                           |   5 +-
 include/linux/platform_data/mmc-esdhc-imx.h        |   5 +
 54 files changed, 1818 insertions(+), 1240 deletions(-)

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
