Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030863AbaDJNRZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 09:17:25 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:37845 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030661AbaDJNRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 09:17:21 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-cb-534699da2f8f
From: Robert Baldyga <r.baldyga@samsung.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        myungjoo.ham@samsung.com, cw00.choi@samsung.com, dbaryshkov@gmail.com,
        dwmw2@infradead.org, balbi@ti.com, gregkh@linuxfoundation.org,
        grant.likely@linaro.org, ldewangan@nvidia.com, kishon@ti.com,
        gg@slimlogic.co.uk, anton@enomsg.org, jonghwa3.lee@samsung.com,
        rongjun.ying@csr.com, linux@roeck-us.net, aaro.koskinen@iki.fi,
        tony@atomide.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, Robert Baldyga <r.baldyga@samsung.com>
Subject: [PATCH 00/13] extcon: major rework
Date: Thu, 10 Apr 2014 15:16:38 +0200
Message-id: <1397135811-12866-1-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDIsWRmVeSWpSXmKPExsVy+t9jAd1bM92CDab0mluseeFgcXCrpsXB
	+/UW1788Z7WY9OQ9s8X8I+dYLSaunMxs0f9mIatF/xYXiwN/djBaNC9ez2Zx7tVKRovOs0+Y
	LS487WGzWLpvNYvFwrYlLBaXd81hs5i9pJ/FYtGyVmaLJwvPMFksvX6RyeJ24wo2i+Vv/7NZ
	TJi+lsXiweGd7BbrXk5nsWjde4TdYt+FP6wW+694Och6rJm3htHj29dJLB6X+3qZPHbtnMPq
	MaH/E6PHzll32T1WLv/C5nH460IWj80rtDw2repk83i1eiarx51re9g89s9dw+7R2/yOzePl
	xN9sHju/N7AHiERx2aSk5mSWpRbp2yVwZVw5PY+1oEOhonXzebYGxsmSXYycHBICJhJ31yxi
	hbDFJC7cW8/WxcjFISSwiFHi39y7TBBOO5PExcfv2UCq2AR0JLZ8n8AIYosIMEssmHqeEaSI
	WeAkq8Sqg/uZQRLCAtoS369eBmtgEVCVWDd3D5jNK+Aq8XvpDKB1HEDrFCTmTLKZwMi9gJFh
	FaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZwnD2T3sG4qsHiEKMAB6MSD++BZa7BQqyJZcWV
	uYcYJTiYlUR4N051CxbiTUmsrEotyo8vKs1JLT7EKM3BoiTOe7DVOlBIID2xJDU7NbUgtQgm
	y8TBKdXAmLgwpzGfsV5k+lYr2e5HnB/Ubz4MnvGl07Wnebm5YJDqy//xmVtU/TczZ/PXPFmz
	Y03Zg+nsp3UzGVZPWSNxrPahcUfSTcEWzTlfWsM3L85jMtM3rQ9QmbOipGaJvs1/97035STW
	JzxWNLyteJf72XeGW34PxCYtTxU+6pCwjW3ObSNBVnMpJZbijERDLeai4kQAF3WSeq8CAAA=
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
 .../devicetree/bindings/extcon/extcon-arizona.txt  |   47 +++
 .../devicetree/bindings/extcon/extcon-bindings.txt |   36 ++
 .../devicetree/bindings/extcon/extcon-gpio.txt     |   63 +++
 .../devicetree/bindings/extcon/extcon-max14577.txt |   49 +++
 .../devicetree/bindings/extcon/extcon-max77693.txt |   56 +++
 .../devicetree/bindings/extcon/extcon-max8997.txt  |   49 +++
 .../devicetree/bindings/extcon/extcon-palmas.txt   |   37 +-
 .../bindings/power_supply/charger-manager.txt      |   11 +-
 Documentation/extcon/extcon.txt                    |  108 +++++
 drivers/extcon/extcon-adc-jack.c                   |   75 ++++
 drivers/extcon/extcon-arizona.c                    |    1 +
 drivers/extcon/extcon-class.c                      |  412 +++++++++-----------
 drivers/extcon/extcon-gpio.c                       |   64 ++-
 drivers/extcon/extcon-max14577.c                   |   26 +-
 drivers/extcon/extcon-max77693.c                   |   82 ++--
 drivers/extcon/extcon-max8997.c                    |   35 +-
 drivers/extcon/extcon-palmas.c                     |   28 +-
 drivers/power/charger-manager.c                    |   36 +-
 drivers/usb/dwc3/dwc3-omap.c                       |   68 ++--
 drivers/usb/phy/phy-omap-otg.c                     |   72 ++--
 include/linux/extcon.h                             |  157 +++-----
 include/linux/extcon/extcon-gpio.h                 |    2 +-
 include/linux/platform_data/usb-omap1.h            |    2 -
 include/linux/power/charger-manager.h              |    6 +-
 25 files changed, 1067 insertions(+), 515 deletions(-)
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

