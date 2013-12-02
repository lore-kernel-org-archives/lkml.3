Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183Ab3LBHFr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 02:05:47 -0500
Received: from mail.fpasia.hk ([202.130.89.98]:53269 "EHLO fpa01n0.fpasia.hk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753107Ab3LBHFc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 02:05:32 -0500
From: Chris Ruehl <chris.ruehl@gtsys.com.hk>
To: balbi@ti.com, gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chris Ruehl <chris.ruehl@gtsys.com.hk>
Subject: [PATCH] usb: phy-generic, phy-ulpi patch set 
Date: Mon,  2 Dec 2013 15:05:16 +0800
Message-Id: <1385967919-13258-1-git-send-email-chris.ruehl@gtsys.com.hk>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set add support 
* GPIO ChipSelect
* ULPI support to set VBUS flags for EXTVBUSIND,CHRGVBUS
* ULPI support to set VBUS flags from DT

[PATCH 1/3] usb: phy-generic: Add GPIO based ChipSelect
	The ULPI ISP1504 uses the CHIP_SELECT_N (low active) pin to active the
	chip. This patch add support for GPIO based ChipSelect almost the same
	way implemented for the Reset feature.

[PATCH 2/3] usb: phy-ulpi: Add EXTVBUSIND,CHRGVBUS flag support
	ULPI like ISP1504 support external vbus power indication
	used in combination with vbus switches mic2075.

[PATCH 3/3] usb: phy-generic: Add ULPI VBUS support
	Some platforms need to set the VBUS parameters of the ULPI
	like ISP1504 which interact with overcurrent protection and
	power switch MIC2575. Therefore it requires to set
	* DRVVBUS
	* DRVVBUS_EXT
	* EXTVBUSIND
	* CHRGVBUS
	of the ULPI.

Signed-off-by: Chris Ruehl <chris.ruehl@gtsys.com.hk>
---
