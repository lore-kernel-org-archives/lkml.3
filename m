Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757445AbaCDPYt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 10:24:49 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:41360 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757188AbaCDPYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 10:24:47 -0500
X-AuditID: cbfee61a-b7fb26d00000724f-fc-5315f0383e82
From: Kamil Debski <k.debski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org
Cc: kyungmin.park@samsung.com, kishon@ti.com, t.figa@samsung.com,
        s.nawrocki@samsung.com, m.szyprowski@samsung.com,
        gautam.vivek@samsung.com, mat.krawczuk@gmail.com,
        yulgon.kim@samsung.com, p.paneri@samsung.com,
        av.tikhomirov@samsung.com, jg1.han@samsung.com, galak@codeaurora.org,
        matt.porter@linaro.org, k.debski@samsung.com,
        tjakobi@math.uni-bielefeld.de, stern@rowland.harvard.edu
Subject: [PATCH v7 0/4] phy: Add new Exynos USB 2.0 PHY driver
Date: Tue, 04 Mar 2014 16:23:32 +0100
Message-id: <1393946616-20062-1-git-send-email-k.debski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJLMWRmVeSWpSXmKPExsVy+t9jAV3LD6LBBi8WsFks2X2D1WL+kXOs
	Fv1vFrJatF05yG5xeeElVosfry+wWVx42sNmcbbpDVBs1xw2ixnn9zFZLFrWymyx9shddouz
	/bfZLCY2TWO3OL+lk8ni8Jt2VosJv4Ha1s94zWLRtvoDq0XH2YPsDiIel/t6mTx2zrrL7nHn
	2h42j3/H2D1m3/3B6NG3ZRWjx/Eb25k8Pm+SC+CI4rJJSc3JLEst0rdL4Mq4++4we8F3x4qd
	vf+ZGxhXG3cxcnBICJhIvNot3sXICWSKSVy4t56ti5GLQ0hgEaPE8e4vLBBOB5NEy8HpLCAN
	bAKaEqvueYA0iAjUSEy5dYUdpIZZoItZYsK202wgCWEBO4nvH58zgtgsAqoSd6ccB4vzCrhI
	vLp9ng1isYLEnEk2Exi5FzAyrGIUTS1ILihOSs811CtOzC0uzUvXS87P3cQIDuBnUjsYVzZY
	HGIU4GBU4uGdMU0kWIg1say4MvcQowQHs5IIr+kL0WAh3pTEyqrUovz4otKc1OJDjNIcLEri
	vAdarQOFBNITS1KzU1MLUotgskwcnFINjItMttcKtEi1zApbGfqe83/M8gXGOclhLR07V3XF
	Ppln37iM6/M915bM35ovr5za7SZ28PU9zt0rPDd6M98ofBCRk7L19I1AiaaazfdqQqN21105
	vKB6adYzu1/nZ6lZ5nDPylx8yL1P7siH6e7qkyu/6p9lPblHbmEBi8DWrcn/UzzYrv1zDVBi
	Kc5INNRiLipOBAAEaLd2XAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the seventh version of this patchset. First and most significant change
is that this patchset includes only patches touching the Generic PHY Framework.
Patches to the USB controllers were stripped as they require additional work.
S5PV210 support is also omitted - it requires more testing.

Thank you to everyone who joined the discussion, reviewed the patched and
contributed to making the code and consequently the Linux Kernel better.

Best wishes,
Kamil Debski

--------------
Changes from v6: (not including the change that controller patches were removed
form this patchset, also this patchset excludes S5PV210 support - it needs more
testing)
1) phy: core: Add an exported of_phy_get function
   - No changes since v6.
2) phy: core: Add devm_of_phy_get to phy-core
   - No changes since v6.
3) phy: Add new Exynos USB 2.0 PHY driver
   - Changed the way clocks are supplied to the driver. Prior to version v7
     there were reference clocks for every phy instance, now a single "ref"
     clock was introduced.
   - Updated documentation to match the aforementioned change.
   - Add offset EXYNOS_*_UPHYCLK_PHYFSEL_OFFSET to the clock register content
     defines.
   - Corrected way clock register is modified. Instead of a simple write, a
     proper read, modify, write sequence was introduced.
   - Important stability fix - added udelay after PHY reset. This fixes a bug
     causing instability in USB LAN adapters. Without the delay the DMA burst
     mode was could not be enabled.
4) phy: Add Exynos 5250 support to the Exynos USB 2.0 PHY
   - Changed handling of clocks to use a single "ref" clock.

----------------
Changes from v5:
1) phy: core: Add an exported of_phy_get function
- corrected behaviour of the modification when GENERIC_PHY is not enabled
  by adding a stub of the of_phy_get function
2) phy: core: Add devm_of_phy_get to phy-core
- corrected behaviour of the modification when GENERIC_PHY is not enabled
  by adding a stub of the devm_of_phy_get function
3) dts: Add usb2phy to Exynos 4
- no change
4) dts: Add usb2phy to Exynos 5250
- in the previous version, this patch included some phy-exynos5250-usb2.c code
  by mistake, the code has been remove and added to the proper patch
5) phy: Add new Exynos USB PHY driver
- changed strings from Exynos 4212 to Exynos 4x12, as the Exynos 4212 driver is
  actually a driver for the whole Exynos 4x12 family
- added documentation to the Exynos USB 2.0 PHY driver adaptaion layer
- corrected strings HSCI -> HSIC
- fixed a problem introduced by previous change - on Exynos 4x12 the HSIC did
  not work on its own
- mode switch support was added to Exynos 4x12 (same io pins are used by host
  and device)
- support for phy_set_bus_width introduced by Matt Porter was added
6) phy: Add support for S5PV210 to the Exynos USB PHY
- setting of clk register was fixed
7) phy: Add Exynos 5250 support to the Exynos USB 2.0 PHY
- supoprt was added for HSIC and device
8) usb: ehci-exynos: Change to use phy provided by the generic phy framework
- DT documentation was moved from usb-ehci.txt to exynos-usb.txt

----------------
Changes from v4:
1) phy: core: Add an exported of_phy_get function
- the new exported function of_phy_get was changed to take the phy's name as a
  parameter instead of the index
2) phy: core: Add devm_of_phy_get to phy-core
- fixes made in the comments to devm_of_phy_get
3) phy: Add new Exynos USB PHY driver
- move the documentation from a new to an existing file - samsung-phy.txt
- fix typos and uppercase hex addresses
- add more explanations to Kconfig (checkpatch still complains, but I find it
  hard to think what else could I add)
- add selects MFD_SYSCON as the driver needs it (Thank you, Tobias!)
- cleanup included headers in both *.c and .h files
- use BIT(x) macro instead of (1 << x)
- replaced HOST and DEV with PHY0 and PHY1 in phy-exynos4212-usb2.c, the
  registers are described as PHYx in the documentation hence the decision to
  leave the PHYx naming
- fixed typo in exynos4210_rate_to_clk reg -> *reg
- change hax_mode_switch and enabled type to bool
4) usb: ehci-s5p: Change to use phy provided by the generic phy framework
- Put the issue of phy->otg in order - since the new phy driver does not provide
  this field. With the new driver the switch between host and device is done in
  power_on of the respective host and device phys.
5) usb: s3c-hsotg: Use the new Exynos USB phy driver with the generic phy
   framework
- fixed the example in the documentation
6) phy: Add support for S5PV210 to the Exynos USB PHY driver
- include files cleanup
- use BIT(x) macro instead of (1 << x)
7) phy: Add Exynos 5250 support to the Exynos USB 2.0 PHY driver
- include files cleanup
- use BIT(x) macro instead of (1 << x)
8) dts: Add usb2phy to Exynos 4
- no changes
9) dts: Add usb2phy to Exynos 5250
- no changes

----------------
Changes from v3:
- using PMU and system registers indirectly via syscon
- change labelling
- change Kconfig name
- fixed typos/stray whitespace
- move of_phy_provider_register() to the end of probe
- add a regular error return code to the rate_to_clk functions
- cleanup code and remove unused code
- change struct names to avoid collisions
- add mechanism to support multiple phys by the ehci driver

----------------
Changes from v2:
- rebase all patches to the usb-next branch
- fixes in the documentation file
  - remove wrong entries in the phy node (ranges, and #address- & #size-cells)
  - add clocks and clock-names as required properites
  - rephrase a few sentences
- fixes in the ehci-exynos.c file
  - move phy_name variable next to phy in exynos_ehci_hcd
  - remove otg from exynos_ehci_hcd as it was no longer used
  - move devm_phy_get after the Exynos5440 skip_phy check
- fixes in the s3c-hsotg.c file
  - cosmetic fixes (remove empty line that was wrongfully added)
- fixes in the main driver
  - remove cpu_type in favour for a boolean flag matched with the compatible
    value
  - rename files, structures, variables and Kconfig entires - change from simple
    "uphy" to "usb2_phy"
  - fix multiline comments style
  - simplify #ifdefs in of_device_id
  - fix Kconfig description
  - change dev_info to dev_dbg where reasonable
  - cosmetic changes (remove wrongful blank lines)
  - remove unnecessary reference counting

----------------
Changes from v1:
- the changes include minor fixes of the hardware initialization of the PHY
  module
- some other minor fixes were introduced

----------------------
Original cover letter:

Hi,

This patch adds a new drive for USB PHYs for Samsung SoCs. The driver is
using the Generic PHY Framework created by Kishon Vijay Abrahan I. It
can be found here https://lkml.org/lkml/2013/8/21/29. This patch adds
support to Exynos4 family of SoCs. Support for Exynos3 and Exynos5 is
planned to be added in the near future.

I welcome your comments.

----------------------

Kamil Debski (4):
  phy: core: Add an exported of_phy_get function
  phy: core: Add devm_of_phy_get to phy-core
  phy: Add new Exynos USB 2.0 PHY driver
  phy: Add Exynos 5250 support to the Exynos USB 2.0 PHY driver

 .../devicetree/bindings/phy/samsung-phy.txt        |   54 +++
 Documentation/phy/samsung-usb2.txt                 |  134 +++++++
 drivers/phy/Kconfig                                |   40 ++
 drivers/phy/Makefile                               |    4 +
 drivers/phy/phy-core.c                             |   76 +++-
 drivers/phy/phy-exynos4210-usb2.c                  |  262 +++++++++++++
 drivers/phy/phy-exynos4x12-usb2.c                  |  330 ++++++++++++++++
 drivers/phy/phy-exynos5250-usb2.c                  |  405 ++++++++++++++++++++
 drivers/phy/phy-samsung-usb2.c                     |  229 +++++++++++
 drivers/phy/phy-samsung-usb2.h                     |   68 ++++
 include/linux/phy/phy.h                            |   14 +
 11 files changed, 1607 insertions(+), 9 deletions(-)
 create mode 100644 Documentation/phy/samsung-usb2.txt
 create mode 100644 drivers/phy/phy-exynos4210-usb2.c
 create mode 100644 drivers/phy/phy-exynos4x12-usb2.c
 create mode 100644 drivers/phy/phy-exynos5250-usb2.c
 create mode 100644 drivers/phy/phy-samsung-usb2.c
 create mode 100644 drivers/phy/phy-samsung-usb2.h

-- 
1.7.9.5

