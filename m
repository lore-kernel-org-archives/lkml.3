Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097AbaEHNyF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 09:54:05 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:61652 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959AbaEHNwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 09:52:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 0/8] usb: various fixes for ARM randconfig failures
Date: Thu,  8 May 2014 15:52:13 +0200
Message-Id: <1399557141-1346645-1-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
X-Provags-ID: V02:K0:emTEl9aneTXm7WflOrZuyp3aHPA6sQRNFijR7kLmIDe
 LnuwDyld/dSCd7NlNegKinqmg08dcAyjlkrhLp9jJXaP6u/f1C
 4pow9GpSbOISg8n7ynLerMKpbyl24scc9PcNrwon4PZKZTjqzK
 n8r3CE1wos0zRGGaEM8dxfB9nmgPECDKIy+btqSvveW4jenF1b
 NFzR/Yl6yUV4GzUl174TrzkD34/Tk9hFU1uiYhefGMbpsA/pDa
 BV4QImp1nmGa02LqWDgonzzK6XOZULGxav/xoaYLONsAt1bBM6
 BfCoTJAKgf2Emb3jLp+2c5DMuZ5l2cruuO7c4CSI/xBZkkOf4p
 39PLwYTYp2AKz+0VNLu40vrs/WXLGRbZfcVm/mIG8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These is the usb part of my longer ARM randconfig build bug
series. None of these are actually needed for 3.15 as far as
I can tell, but it would be good to have them included in the
next merge window.

The xhci patch is only for a build warning, not a failure, but
we see this one all the time because it happens in one of the
defconfigs.

Arnd Bergmann (8):
  usb/gadget: s3c2410_udc: don't use pr_debug return value
  usb: musb: tusb-dma can't be built-in if tusb is not
  usb: musb: omap2plus bus glue needs USB host support
  usb: phy: fix isp1301-omap dependency on tps65010
  usb: phy: msm: reset controller is mandatory now
  usb: xhci: avoid warning for !PM_SLEEP
  usb: ohci: sort out dependencies for lpc32xx and omap
  usb: ohci-da8xx can only be built-in

 drivers/usb/gadget/Kconfig         |  4 ++--
 drivers/usb/gadget/s3c2410_udc.c   |  3 ++-
 drivers/usb/host/Kconfig           | 16 +++++++++++++---
 drivers/usb/host/ohci-hcd.c        |  2 +-
 drivers/usb/host/xhci-plat.c       |  2 +-
 drivers/usb/musb/Kconfig           |  4 ++--
 drivers/usb/phy/Kconfig            |  1 +
 drivers/usb/phy/phy-isp1301-omap.c |  2 +-
 8 files changed, 23 insertions(+), 11 deletions(-)

-- 
1.8.3.2

