Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932878Ab3DYRbI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 13:31:08 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:63358 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932769Ab3DYR3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 13:29:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>,
        Pavankumar Kondeti <pkondeti@codeaurora.org>
Subject: [PATCH 18/21] USB: ehci-msm: USB_MSM_OTG needs USB_PHY
Date: Thu, 25 Apr 2013 19:29:01 +0200
Message-Id: <1366910944-3033663-19-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366910944-3033663-1-git-send-email-arnd@arndb.de>
References: <1366910944-3033663-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:oudxmIdlwRzSm8LSvNHblVoRXVlhDls0NXopSszVTHv
 vzE/2ezrt5tqVw1BYsxIBJ0UrVYxMLK3DcCb0hybV0eLoKkcUO
 AfrMO7UXjhPJK/eEYsi+wL6XxwJNggU2CgEIXy0lydV7vEelzq
 ZMr2m9pH3gJEsQgpRIP+K0rawEYvKVAiiG7M7LAaKmAhYdCrSB
 3wBC1QMyJ/7FJ9qurfSzhLAjuW2jx1G+0n7ocAtdL+kQjLXH/x
 +Jw20nnM/OXOn++Ft9gYF2GkWIkrb3pLQSaXyf+4sha/w66Mml
 AHMTlyyEeFo2T2ix+my/ZP0loGVi/Ps6X8gK8yRNyR2cpoFBTx
 dKuld06+GK+0PoRmC/8pFRMYGnBTx2IUradzE/fL6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig entry for USB_EHCI_MSM unconditionally selects USB_MSM_OTG,
which is now only visible when USB_PHY is also enabled.

This adds an appropriate dependency and enables USB_PHY in the msm
defconfig, avoiding the Kbuild warning:

warning: (USB_EHCI_MSM) selects USB_MSM_OTG which has unmet direct dependencies (USB_SUPPORT && USB_PHY && (USB || USB_GADGET) && ARCH_MSM)

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: linux-usb@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Pavankumar Kondeti <pkondeti@codeaurora.org>
---
 arch/arm/configs/msm_defconfig | 1 +
 drivers/usb/host/Kconfig       | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/arm/configs/msm_defconfig b/arch/arm/configs/msm_defconfig
index 44f9291..690b5f9 100644
--- a/arch/arm/configs/msm_defconfig
+++ b/arch/arm/configs/msm_defconfig
@@ -101,6 +101,7 @@ CONFIG_SND_DYNAMIC_MINORS=y
 CONFIG_SND_SOC=y
 CONFIG_HID_BATTERY_STRENGTH=y
 CONFIG_USB=y
+CONFIG_USB_PHY=y
 CONFIG_USB_ANNOUNCE_NEW_DEVICES=y
 CONFIG_USB_MON=y
 CONFIG_USB_EHCI_HCD=y
diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index c558472..de94f26 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -188,6 +188,7 @@ config USB_EHCI_HCD_AT91
 config USB_EHCI_MSM
 	tristate "Support for Qualcomm QSD/MSM on-chip EHCI USB controller"
 	depends on ARCH_MSM
+	depends on USB_PHY
 	select USB_EHCI_ROOT_HUB_TT
 	select USB_MSM_OTG
 	---help---
-- 
1.8.1.2

