Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351AbaA0Bzs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 20:55:48 -0500
Received: from s72.web-hosting.com ([198.187.29.21]:54398 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121AbaA0Bzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 20:55:46 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <21221.47960.726835.615315@gargle.gargle.HOWL>
Date: Mon, 27 Jan 2014 07:20:16 +0530
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        <ath9k-devel@venema.h4ckr.net>, netdev <netdev@vger.kernel.org>,
        "Linux-Kernel\@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: ath9k ARM build error with v3.13-8330-g4ba9920
In-Reply-To: <CA+5PVA4fnCo8anT0HZCVu4+AFAseibm=0yD8nL3Lm7Q5dA-qZQ@mail.gmail.com>
References: <CA+5PVA4fnCo8anT0HZCVu4+AFAseibm=0yD8nL3Lm7Q5dA-qZQ@mail.gmail.com>
X-Mailer: VM 8.2.0b under 24.3.50.1 (x86_64-unknown-linux-gnu)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - server72.web-hosting.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - msujith.org
X-Get-Message-Sender-Via: server72.web-hosting.com: authenticated_id: sujith@msujith.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Josh Boyer wrote:
> adds a udelay(10000) call to the ath9k driver.  This will cause a
> build error on various ARM configs because the value passed to udelay
> is too large:
> 
> ERROR: "__bad_udelay" [drivers/net/wireless/ath/ath9k/ath9k_hw.ko] undefined!
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2
> 
> Is the 10000 microsecond udelay really required?  I believe the limit
> on ARM is 2000.  Perhaps something else could be done in this case?

The delay is a workaround for a HW issue. Does this patch fix the problem ?

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index fbf43c0..11eab9f 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1316,7 +1316,7 @@ static bool ath9k_hw_set_reset(struct ath_hw *ah, int type)
 	if (AR_SREV_9300_20_OR_LATER(ah))
 		udelay(50);
 	else if (AR_SREV_9100(ah))
-		udelay(10000);
+		mdelay(10);
 	else
 		udelay(100);
 
@@ -2051,9 +2051,8 @@ static bool ath9k_hw_set_power_awake(struct ath_hw *ah)
 
 	REG_SET_BIT(ah, AR_RTC_FORCE_WAKE,
 		    AR_RTC_FORCE_WAKE_EN);
-
 	if (AR_SREV_9100(ah))
-		udelay(10000);
+		mdelay(10);
 	else
 		udelay(50);
 

Sujith
