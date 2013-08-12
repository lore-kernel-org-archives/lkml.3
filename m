Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986Ab3HLWzd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 18:55:33 -0400
Received: from mo-p05-ob.rzone.de ([81.169.146.181]:27792 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755722Ab3HLWzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 18:55:31 -0400
X-RZG-AUTH: :OmsBZ2C7d7IBoB6EHwegNiNxh/xpjMmBYR0YjlTttojRtSoTy+fSJcJG
X-RZG-CLASS-ID: mo05
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 3/3] wistron_btns: add MODULE_DEVICE_TABLE
Date: Tue, 13 Aug 2013 00:55:22 +0200
User-Agent: KMail/1.13.7 (Linux/3.10-5.slh.2-aptosid-686; KDE/4.8.4; i686; ; )
Cc: Miloslav Trmac <mitr@volny.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <201308130050.52800.s.L-H@gmx.de>
In-Reply-To: <201308130050.52800.s.L-H@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201308130055.29423.s.L-H@gmx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows the wistron_btns module to be autoloaded on boot, its functionality
is required to support the hardware rfkill switches on most of the supported
notebooks, in order to unblock the hard blocked rfkill state for wireless and
bluetooth devices.

Tested on a Medion MD96500:
alias:          dmi*:svn*MEDIONPC*:pn*WIM2040*:

Signed-off-by: Stefan Lippers-Hollmann <s.l-h@gmx.de>
---
This patch may be considered RFC, while it is certainly the right thing to do,
some of the DMI matches might be a bit wide, e.g.:
dmi*:svn*FUJITSUSIEMENS*:pn*AMILOD*:
dmi*:svn*FUJITSUSIEMENS*:pn*AmiloD*:
dmi*:svn*FUJITSUSIEMENS*:pn*AMILOM*:
all others are very targetted - and I haven't noticed any issues by forcing
wistron_btns on system not requiring it so far.

 drivers/input/misc/wistron_btns.c | 1 +
 1 file changed, 1 insertion(+)

--- a/drivers/input/misc/wistron_btns.c
+++ b/drivers/input/misc/wistron_btns.c
@@ -971,6 +971,7 @@ static const struct dmi_system_id __init
 	},
 	{ NULL, }
 };
+MODULE_DEVICE_TABLE(dmi, dmi_ids);
 
 /* Copy the good keymap, as the original ones are free'd */
 static int __init copy_keymap(void)
