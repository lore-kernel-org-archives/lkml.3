Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424AbaDELUH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2014 07:20:07 -0400
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:61874 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752158AbaDELUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2014 07:20:05 -0400
Message-ID: <1396696802.27142.15.camel@x220>
Subject: [PATCH] [media] drx-j: use customise option correctly
From: Paul Bolle <pebolle@tiscali.nl>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 05 Apr 2014 13:20:02 +0200
In-Reply-To: <20140403131143.69f324c7@samsung.com>
References: <20140403131143.69f324c7@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Apr 2014 11:20:02.0876 (UTC) FILETIME=[FD3007C0:01CF50C0]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-04-03 at 13:11 -0300, Mauro Carvalho Chehab wrote:
> Devin Heitmueller (3):
>       [...]
>       [media] drx-j: add a driver for Trident drx-j frontend

This commit introduced a reference to DVB_FE_CUSTOMISE. But that Kconfig
symbol was removed in v3.7. It seems that the intent was to use
MEDIA_SUBDRV_AUTOSELECT here.

So the following (untested!) patch makes the Kconfig entry for "Micronas
DRX-J demodulator" use the current symbol. It is basically a copy of
d65fcbb0007b "([media] ts2020: use customise option correctly").
--------- >8 ---------
From: Paul Bolle <pebolle@tiscali.nl>

The Kconfig entry for "Micronas DRX-J demodulator" defaults to modular
if DVB_FE_CUSTOMISE is set. But that Kconfig symbol was replaced with
MEDIA_SUBDRV_AUTOSELECT as of v3.7. So use the new symbol. And negate
the logic, because MEDIA_SUBDRV_AUTOSELECT's logic is the opposite of
the former logic.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 drivers/media/dvb-frontends/drx39xyj/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/Kconfig b/drivers/media/dvb-frontends/drx39xyj/Kconfig
index 15628eb5cf0c..6c2ccb6a506b 100644
--- a/drivers/media/dvb-frontends/drx39xyj/Kconfig
+++ b/drivers/media/dvb-frontends/drx39xyj/Kconfig
@@ -1,7 +1,7 @@
 config DVB_DRX39XYJ
 	tristate "Micronas DRX-J demodulator"
 	depends on DVB_CORE && I2C
-	default m if DVB_FE_CUSTOMISE
+	default m if !MEDIA_SUBDRV_AUTOSELECT
 	help
 	  An ATSC 8VSB and QAM64/256 tuner module. Say Y when you want
 	  to support this frontend.
-- 
1.9.0

