Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556AbaFWVrV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 17:47:21 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:45192 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286AbaFWVrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 17:47:19 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        "John W. Linville" <linville@tuxdriver.com>,
        Ben Hutchings <ben@decadent.org.uk>, Peter Wu <peter@lekensteyn.nl>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCHv3 0/6] rtlwifi: Fix incorrect MSR mask
Date: Mon, 23 Jun 2014 23:48:16 +0200
Message-Id: <1403560098-7520-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

An error was found in many rtlwifi drivers where an invalid mask was used,
(bt_msr & 0xfc) will never match 0x3. This has been corrected by supplying
a valid mask as a macro. Drivers which did not have this bug are still
modified for consistency.

Rickard Strandqvist (1):
  rtlwifi: Fix media status register mask AND Replace magic number by macro

 drivers/net/wireless/rtlwifi/rtl8188ee/hw.c  |    2 +-
 drivers/net/wireless/rtlwifi/rtl8188ee/reg.h |    1 +
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c  |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/reg.h |    1 +
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c  |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192de/hw.c  |    2 +-
 drivers/net/wireless/rtlwifi/rtl8192de/reg.h |    1 +
 drivers/net/wireless/rtlwifi/rtl8723ae/hw.c  |    2 +-
 drivers/net/wireless/rtlwifi/rtl8723ae/reg.h |    1 +
 drivers/net/wireless/rtlwifi/rtl8723be/hw.c  |    2 +-
 drivers/net/wireless/rtlwifi/rtl8723be/reg.h |    1 +
 drivers/staging/rtl8821ae/rtl8821ae/hw.c     |    2 +-
 drivers/staging/rtl8821ae/rtl8821ae/reg.h    |    1 +
 13 files changed, 13 insertions(+), 7 deletions(-)

-- 
1.7.10.4

