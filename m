Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751787AbaKDCV7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 21:21:59 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:58205 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343AbaKDCV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 21:21:58 -0500
From: varkabhadram@gmail.com
To: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org
Cc: balbi@ti.com, stern@rowland.harvard.edu,
        sergei.shtylyov@cogentembedded.com, linux-kernel@vger.kernel.org,
        Varka Bhadram <varkab@cdac.in>
Subject: [PATCH usb v4 00/27] cleanup on resource check
Date: Tue,  4 Nov 2014 07:51:07 +0530
Message-Id: <1415067694-9473-1-git-send-email-varkabhadram@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Varka Bhadram <varkab@cdac.in>

This series removes the duplication of sanity check for
platform_get_resource() return resource. It will be checked
with devm_ioremap_resource().

This entire series rebased on usb-next of [1].

changes since v1:
	- removed broken patches
	- added Ack of Alan Stern for all the ehci, ohci, and uhci changes.

changes since v2:
	- addressed Sergei Shtylyov comments

changes since v3:
	- separated as two serieses, one for fixes another for cleanup
	- added Acked-by of Felipe balbi
	- added Reviewed-by of Gregory CLEMENT


[1]: https://git.kernel.org/cgit/linux/kernel/git/gregkh/usb.git


Varka Bhadram (27):
  host: ehci-atmel: remove duplicate check on resource
  host: ohci-da8xx: remove duplicate check on resource
  host: ehci-tegra: remove duplicate check on resource
  host: ehci-w90x900: remove duplicate check on resource
  host: ohci-at91: remove duplicate check on resource
  host: ohci-exynos: remove duplicate check on resource
  host: ohci-jz4740: remove duplicate check on resource
  host: ohci-octeon: remove duplicate check on resource
  host: ohci-platform: remove duplicate check on resource
  host: ohci-pxa27x: remove duplicate check on resource
  host: ehci-sh: remove duplicate check on resource
  host: ohci-spear: remove duplicate check on resource
  host: ehci-msm: remove duplicate check on resource
  host: ehci-mv: remove duplicate check on resource
  host: ehci-mxc: remove duplicate check on resource
  host: ehci-octeon: remove duplicate check on resource
  host: ehci-orion: remove duplicate check on resource
  host: ehci-platform: remove duplicate check on resource
  host: ehci-spear: remove duplicate check on resource
  host: xhci-plat: remove duplicate check on resource
  musb: musb_core: remove duplicate check on resource
  musb: musb_dsps: remove duplicate check on resource
  phy: phy-rcar-usb: remove duplicate check on resource
  dwc3: dwc3-keystone: remove duplicate check on resource
  host: ehci-fsl: remove duplicate check on resource
  host: ehci-exynos: remove duplicate check on resource
  renesas_usbhs: common: remove duplicate check on resource

 drivers/usb/dwc3/dwc3-keystone.c   |    5 -----
 drivers/usb/host/ehci-atmel.c      |   13 +++----------
 drivers/usb/host/ehci-exynos.c     |   11 +++--------
 drivers/usb/host/ehci-fsl.c        |   12 +++---------
 drivers/usb/host/ehci-msm.c        |   10 ++--------
 drivers/usb/host/ehci-mv.c         |   12 ------------
 drivers/usb/host/ehci-mxc.c        |   11 ++---------
 drivers/usb/host/ehci-octeon.c     |   12 +++---------
 drivers/usb/host/ehci-orion.c      |   10 +---------
 drivers/usb/host/ehci-platform.c   |   12 ++++--------
 drivers/usb/host/ehci-sh.c         |   15 +++------------
 drivers/usb/host/ehci-spear.c      |    9 ++-------
 drivers/usb/host/ehci-tegra.c      |   10 +++-------
 drivers/usb/host/ehci-w90x900.c    |   13 +++----------
 drivers/usb/host/ohci-at91.c       |   11 +++--------
 drivers/usb/host/ohci-da8xx.c      |    7 ++-----
 drivers/usb/host/ohci-exynos.c     |   10 ++--------
 drivers/usb/host/ohci-jz4740.c     |   13 +++----------
 drivers/usb/host/ohci-octeon.c     |   12 +++---------
 drivers/usb/host/ohci-platform.c   |   13 ++++---------
 drivers/usb/host/ohci-pxa27x.c     |   11 ++---------
 drivers/usb/host/ohci-spear.c      |   11 +++--------
 drivers/usb/host/xhci-plat.c       |   10 ++++------
 drivers/usb/musb/musb_core.c       |    4 ++--
 drivers/usb/musb/musb_dsps.c       |    3 ---
 drivers/usb/phy/phy-rcar-usb.c     |    8 +++-----
 drivers/usb/renesas_usbhs/common.c |    4 ++--
 27 files changed, 65 insertions(+), 207 deletions(-)

-- 
1.7.9.5

