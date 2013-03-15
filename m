Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897Ab3COE7L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 00:59:11 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:55573 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824Ab3COE7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 00:59:09 -0400
From: "Philip, Avinash" <avinashphilip@ti.com>
To: "Nori, Sekhar" <nsekhar@ti.com>
CC: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "Manjunathappa, Prakash" <prakash.pm@ti.com>
Subject: RE: [PATCH 2/3] ARM: davinci: da850: Enable EHRPWM TBCLK from
 CFG_CHIP1
Thread-Topic: [PATCH 2/3] ARM: davinci: da850: Enable EHRPWM TBCLK from
 CFG_CHIP1
Thread-Index: AQHOIJ/oCqReOjFXuUa9aEooU+VxqZikyr4AgAFe+NA=
Date: Fri, 15 Mar 2013 04:57:54 +0000
Deferred-Delivery: Fri, 15 Mar 2013 04:57:00 +0000
Message-ID: <518397C60809E147AF5323E0420B992E3EA97355@DBDE01.ent.ti.com>
References: <1363257453-24747-1-git-send-email-avinashphilip@ti.com>
 <1363257453-24747-3-git-send-email-avinashphilip@ti.com>
 <5141CA40.9010005@ti.com>
In-Reply-To: <5141CA40.9010005@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r2F4xRF9002470

On Thu, Mar 14, 2013 at 18:31:52, Nori, Sekhar wrote:
> On 3/14/2013 4:07 PM, Philip Avinash wrote:
> > da850 platforms require TBCLK synchronization in CFG_CHIP1 register for
> > TBCLK enable in EHRPWM modules. Enabling of TBCLK is done only if EHRPWM
> > DT node status is set to "okay" DT blob.
> > Also adds macro definitions for DA8XX_EHRPWM_TBCLKSYNC and
> > DA8XX_CFGCHIP1_REG.
> 
> So there is actually a TBCLK in DA850 - it's just not modeled as a clock
> similar to the way it is done on AM335x? If yes, then instead of adding
> a dummy clock node and doing the TBCLK enable as part of init, why not
> model TBCLK in clock tree even on DA850?


TBCLK enabling should done from platform specific way. In DA850 it is done at
CFGCHIP1 register. Unfortunately Davinci clock frame work will support only
clock nodes inside PLLC and PSC modules. Handling of CFGCHP1 require
modifications in clock frame work.

Hence handling it as part of initialization.

Thanks
Avinash

> 
> Thanks,
> Sekhar
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
