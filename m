Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529AbaDRD4P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 23:56:15 -0400
Received: from mail-bl2lp0212.outbound.protection.outlook.com ([207.46.163.212]:9762
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751259AbaDRD4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 23:56:08 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        Jingchang Lu <jingchang.lu@freescale.com>,
        "Jason.Jin@freescale.com" <Jason.Jin@freescale.com>,
        "Dongsheng.Wang@freescale.com" <Dongsheng.Wang@freescale.com>
CC: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC][PATCH 3/3] clocksource: Add Freescale FlexTimer Module
 (FTM) timer support
Thread-Topic: [RFC][PATCH 3/3] clocksource: Add Freescale FlexTimer Module
 (FTM) timer support
Thread-Index: AQHPWSBc9k7OgjbNkEijY/VC8/wPu5sV3s2AgADiQ/A=
Date: Fri, 18 Apr 2014 03:55:46 +0000
Message-ID: <aa8f83c882144105b4c2c230dc6f517b@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1397614787-8300-1-git-send-email-Li.Xiubo@freescale.com>
 <1397614787-8300-4-git-send-email-Li.Xiubo@freescale.com>
 <534FE3C1.4060509@linaro.org>
In-Reply-To: <534FE3C1.4060509@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 018577E36E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(51704005)(199002)(189002)(92566001)(86362001)(83072002)(2201001)(83322001)(76482001)(81342001)(81542001)(85852003)(80976001)(20776003)(79102001)(33646001)(66066001)(80022001)(74316001)(4396001)(76176999)(50986999)(77096999)(46102001)(74662001)(31966008)(87936001)(54356999)(2656002)(76576001)(99286001)(99396002)(74502001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB377;H:BY2PR03MB505.namprd03.prod.outlook.com;FPR:7C96D836.81B11E2B.7BF10DC7.64AC2150.200F2;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s3I3v235017649

> > +	freq = clk_get_rate(ftm_clk);
> > +
> > +	calc_closest_cound_cyc(freq);
> > +
> > +	BUG_ON(ftm_clocksource_init(freq));
> > +
> > +	BUG_ON(ftm_clockevent_init(freq, irq));
> > +}
> > +CLOCKSOURCE_OF_DECLARE(vf610, "fsl,vf610-ftm-timer", ftm_timer_init);
> 
> 
> I am not a big fan of those BUG_ON every line. Could you please replace
> it by dev_err().
> 

While, for the FlexTimer driver, there hasn't any device creation and
registering, so I'll use pr_err() instead of dev_err()...

Thanks

BRs
Xiubo
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
