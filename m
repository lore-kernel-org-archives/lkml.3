Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417AbaDNLq5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 07:46:57 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:29694 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbaDNLqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 07:46:52 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-fc-534bcaaa79e3
From: Robert Baldyga <r.baldyga@samsung.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        myungjoo.ham@samsung.com, cw00.choi@samsung.com, dbaryshkov@gmail.com,
        dwmw2@infradead.org, balbi@ti.com, gregkh@linuxfoundation.org,
        grant.likely@linaro.org, ldewangan@nvidia.com, kishon@ti.com,
        gg@slimlogic.co.uk, anton@enomsg.org, jonghwa3.lee@samsung.com,
        rongjun.ying@csr.com, linux@roeck-us.net, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, aaro.koskinen@iki.fi,
        m.szyprowski@samsung.com, t.figa@samsung.com,
        Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH v2 00/13] extcon: major rework
Date: Mon, 14 Apr 2014 13:46:11 +0200
Message-id: <1397475984-28001-1-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAAzXRaUiTcQAGcP97j83p4GVaviqFLgqytAypf2WlkPBOyQM/CILV1Ncpbjo2
	Nc2oeZX3DqlZWTlv52zglJyk6TaozFvLwpNSSzuEUCy0wxl9+/E8H54PDwvhVqNurKSUNFqa
	IhDxcDb66vcHwlvXHxJ59Gf3caj/FAD7Og7CvrkbcHLtIwbVC6sIfGQdwqCquQKBii9aDCra
	z8PerU4A82oNOBxaaQawaHABgSOLpTis72lBofZmHQrHu6pweL9OgcKahgIELmgHGLDVOsOE
	9ZOjDDiV04TDxq9/cKjUtKJw3mJiwsfLGhQWdFuZsGdkC4OGys9owF5K/1APqPHyMgbVZarC
	KKXiO6BM92aYVHPjGk5Z1rUoZWzyotp0RTi10nIXo6bfPMWpZw/0TKos7xtOLas2ccq0IWdS
	5e06EO4UzfaPp0VJGbT0yNnL7MTqXwYgmfDIrNCoMDmYci0G9iyS8CO19fnMf95NjswacJu5
	RA0gx0r4xYC97VsM8rmxh2ErcOIw2b6hBDY7EwhZfXt4xwixiJFPfpyx2YnwITdntTs5Suwn
	cy2tqM0cIoi0lqxixYC1PeZBVqn9lcChGtjpwC5aEieRxQrFx3xkArEsPUXoE5cqbgM7vy25
	dwKdHJoBwQI8R05hVUgkFxNkyLLEZkCyEJ4zJ6hjO+LEC7Ku0tLUS9J0ES0zA3cWynPh9BWc
	juASQkEanUzTElr6v2Ww7N3kwC95LjRKmnQgtLbhmvJd6fDb2hieJiAixlHSq34P+GGvL4gm
	5/2iw7MnpsY8tzJ9W1+6NKH8sLBp19zxwRN2RocEhqFu8Iq6fJ47Snf1XvfsN+d797hbgmcv
	ZgdzloSVaaZze2JP5SR4nDykWTauD8Ty77gVRqoCo8QvAvepHXioLFHg64VIZYK/zCaCALMC	AAA=
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds many improvements to extcon class driver and extcon
provider drivers. It changes extcon API to faster and safer by replaceing
function taking extcon and cable names with functions working with
structures representing this objects.

It adds more advanced devicetree support which allows to pass specified
cables to client drivers. It gives independency from cable naming
conventions in individual extcon provider drivers, and allows to simply
connect client drivers with providers in way that being transpatent for
both of them.

It adds also some minor fixes like additional checks for safety increase,
and another improvements.

Also added some improvements to extcon provider drivers, improved devicetree
support and updated them to use faster extcon API.

Patches contains also documentation for extcon, and devicetree bindings
for all provider drivers.

More details can be found in commit messages and Documentation.

Best regards
Robert Baldyga
Samsung R&D Institute Poland

Changelog:
v2:
- add support for platforms without devicetree support
- update Documentation

v1: https://lkml.org/lkml/2014/4/10/603

Robert Baldyga (13):
  Documentation: add extcon devicetree bindings
  Documentation: update charger-manager devicetree bindings
  extcon: extcon-class: remove extcon_set_cable_state() function
  extcon: extcon-class: match extcon device by devicetree node
  extcon: extcon-class: improve extcon client API
  extcon: extcon-class: remove unused functions
  extcon: extcon-class: improve get_cable_state_()/set_cable_state_()
    functions
  extcon: extcon-class: simplify extcon_updata_state() function
  extcon: extcon-class: move example to Documentation
  extcon: extcon-gpio: add devicetree support
  extcon: extcon-adc-jack: add devicetree support
  extcon: extcon-max8997: check if pdata exists
  extcon: extcon-max77693: check if pdata exists

 .../devicetree/bindings/extcon/extcon-adc-jack.txt |   60 +++
 .../devicetree/bindings/extcon/extcon-arizona.txt  |   47 ++
 .../devicetree/bindings/extcon/extcon-bindings.txt |   36 ++
 .../devicetree/bindings/extcon/extcon-gpio.txt     |   63 +++
 .../devicetree/bindings/extcon/extcon-max14577.txt |   49 +++
 .../devicetree/bindings/extcon/extcon-max77693.txt |   56 +++
 .../devicetree/bindings/extcon/extcon-max8997.txt  |   49 +++
 .../devicetree/bindings/extcon/extcon-palmas.txt   |   37 +-
 .../bindings/power_supply/charger-manager.txt      |   11 +-
 Documentation/extcon/extcon.txt                    |  112 +++++
 drivers/extcon/extcon-adc-jack.c                   |   82 ++++
 drivers/extcon/extcon-arizona.c                    |    1 +
 drivers/extcon/extcon-class.c                      |  451 ++++++++++----------
 drivers/extcon/extcon-gpio.c                       |   71 ++-
 drivers/extcon/extcon-max14577.c                   |   26 +-
 drivers/extcon/extcon-max77693.c                   |   82 ++--
 drivers/extcon/extcon-max8997.c                    |   35 +-
 drivers/extcon/extcon-palmas.c                     |   28 +-
 drivers/power/charger-manager.c                    |   36 +-
 drivers/usb/dwc3/dwc3-omap.c                       |   68 +--
 drivers/usb/phy/phy-omap-otg.c                     |   70 +--
 include/linux/extcon.h                             |  165 +++----
 include/linux/extcon/extcon-gpio.h                 |    2 +-
 include/linux/power/charger-manager.h              |    6 +-
 24 files changed, 1136 insertions(+), 507 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/extcon/extcon-adc-jack.txt
 create mode 100644 Documentation/devicetree/bindings/extcon/extcon-arizona.txt
 create mode 100644 Documentation/devicetree/bindings/extcon/extcon-bindings.txt
 create mode 100644 Documentation/devicetree/bindings/extcon/extcon-gpio.txt
 create mode 100644 Documentation/devicetree/bindings/extcon/extcon-max14577.txt
 create mode 100644 Documentation/devicetree/bindings/extcon/extcon-max77693.txt
 create mode 100644 Documentation/devicetree/bindings/extcon/extcon-max8997.txt
 create mode 100644 Documentation/extcon/extcon.txt

-- 
1.7.9.5

