Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147Ab3KZNif (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 08:38:35 -0500
Received: from mail.precitec.de ([85.115.17.50]:41640 "EHLO mail.precitec.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751852Ab3KZNib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 08:38:31 -0500
X-CTCH-RefID: str=0001.0A0C0206.5294A453.003E,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
From: Bockholdt Arne <a.bockholdt@precitec-optronik.de>
To: Len Brown <lenb@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
CC: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] intel_idle: Fixed C6 state on Avoton/Rangeley processors
Thread-Topic: [PATCH v2] intel_idle: Fixed C6 state on Avoton/Rangeley
 processors
Thread-Index: AQHO6qzItA/IIsyujUi+mxa+QbcU0w==
Date: Tue, 26 Nov 2013 13:38:25 +0000
Message-ID: <1385473105.4588.14.camel@po-d-abo-ubu>
References: <1385450037.4588.10.camel@po-d-abo-ubu>
	 <1574800.Vl6NB1rGSk@amdc1032>
In-Reply-To: <1574800.Vl6NB1rGSk@amdc1032>
Accept-Language: en-US, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.201.50]
Content-Type: text/plain; charset="utf-8"
Content-ID: <FF23D130EEE8E54A80D1868AC0E15327@precitecgroup.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rAQDcs17011451

Corrected the MWAIT flag for C-State C6 on Intel Avoton/Rangeley processors.

v1..v2: Dropped additional fixup already handled by previous patch

Signed-off-by: Arne Bockholdt <linux-kernel@bockholdt.com>
---

diff -up linux/drivers/idle/intel_idle.c.orig linux/drivers/idle/intel_idle.c
--- linux/drivers/idle/intel_idle.c.orig	2013-11-26 14:23:39.371706228 +0100
+++ linux/drivers/idle/intel_idle.c	2013-11-26 14:24:05.399674929 +0100
@@ -340,7 +340,7 @@ static struct cpuidle_state avn_cstates[
 	{
 		.name = "C6-AVN",
 		.desc = "MWAIT 0x51",
-		.flags = MWAIT2flg(0x58) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
+		.flags = MWAIT2flg(0x51) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
 		.exit_latency = 15,
 		.target_residency = 45,
 		.enter = &intel_idle },

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
