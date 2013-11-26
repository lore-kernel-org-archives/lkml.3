Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889Ab3KZHYG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 02:24:06 -0500
Received: from mail.precitec.de ([85.115.17.50]:44728 "EHLO mail.precitec.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754386Ab3KZHYB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 02:24:01 -0500
X-Greylist: delayed 589 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Nov 2013 02:24:00 EST
X-CTCH-RefID: str=0001.0A0C0205.52944A36.01F8,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
From: Bockholdt Arne <a.bockholdt@precitec-optronik.de>
To: Len Brown <lenb@kernel.org>
CC: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] intel_idle: Fixed C6 state on Avoton/Rangeley processors
Thread-Topic: [PATCH] intel_idle: Fixed C6 state on Avoton/Rangeley
 processors
Thread-Index: AQHO6ncSxR7boqCh4kWVBvEi/xjtow==
Date: Tue, 26 Nov 2013 07:13:57 +0000
Message-ID: <1385450037.4588.10.camel@po-d-abo-ubu>
Accept-Language: en-US, de-DE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.168.201.50]
Content-Type: text/plain; charset="utf-8"
Content-ID: <C5E6A247A888974F95B597DC8CB35BEF@precitecgroup.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rAQ7OBhc009647

Corrected the MWAIT flag for C-State C6 on Intel Avoton/Rangeley processors.

Signed-off-by: Arne Bockholdt <linux-kernel@bockholdt.com>
---

diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index cbd4e9a..92d1206 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -329,7 +329,7 @@ static struct cpuidle_state atom_cstates[] __initdata = {
 	{
 		.enter = NULL }
 };
-static struct cpuidle_state avn_cstates[CPUIDLE_STATE_MAX] = {
+static struct cpuidle_state avn_cstates[] __initdata = {
 	{
 		.name = "C1-AVN",
 		.desc = "MWAIT 0x00",
@@ -340,7 +340,7 @@ static struct cpuidle_state avn_cstates[CPUIDLE_STATE_MAX] = {
 	{
 		.name = "C6-AVN",
 		.desc = "MWAIT 0x51",
-		.flags = MWAIT2flg(0x58) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
+		.flags = MWAIT2flg(0x51) | CPUIDLE_FLAG_TIME_VALID | CPUIDLE_FLAG_TLB_FLUSHED,
 		.exit_latency = 15,
 		.target_residency = 45,
 		.enter = &intel_idle },

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
