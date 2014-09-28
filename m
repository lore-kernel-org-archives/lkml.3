Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703AbaI1CdH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 22:33:07 -0400
Received: from [207.46.100.125] ([207.46.100.125]:61856 "EHLO
	na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753536AbaI1CdF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 22:33:05 -0400
X-Greylist: delayed 864 seconds by postgrey-1.27 at vger.kernel.org; Sat, 27 Sep 2014 22:33:05 EDT
From: Yuantian Tang <Yuantian.Tang@freescale.com>
To: Mike Turquette <mturquette@linaro.org>,
        Scott Wood <scottwood@freescale.com>
CC: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Jingchang Lu <jingchang.lu@freescale.com>
Subject: RE: [PATCHv4] clk: ppc-corenet: rename to ppc-qoriq and add
 CLK_OF_DECLARE support
Thread-Topic: [PATCHv4] clk: ppc-corenet: rename to ppc-qoriq and add
 CLK_OF_DECLARE support
Thread-Index: AQHP1wZitlVyPqyKzkCzCdgy6a+s/ZwRnYeAgACtOwCAAC5pAIAAAJ8AgAGbdgCAAbx24A==
Date: Sun, 28 Sep 2014 02:18:38 +0000
Message-ID: <d637914864824bda8d0dd62639e9097b@DM2PR03MB574.namprd03.prod.outlook.com>
References: <1411454806-8214-1-git-send-email-jingchang.lu@freescale.com>
 <d4a375f40b544cf1ae78ac82dc20569c@BL2PR03MB467.namprd03.prod.outlook.com>
 <1411675680.13320.201.camel@snotra.buserror.net>
 <20140925225406.19023.25065@quantum>
 <1411685780.13320.209.camel@snotra.buserror.net>
 <20140926232900.19023.35854@quantum>
In-Reply-To: <20140926232900.19023.35854@quantum>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [192.88.158.211]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR03MB479;
x-forefront-prvs: 03484C0ABF
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(51704005)(199003)(377424004)(189002)(164054003)(24454002)(13464003)(377454003)(107046002)(33646002)(15975445006)(87936001)(101416001)(2656002)(76576001)(19580395003)(54356999)(50986999)(76176999)(83322001)(83072002)(4396001)(85852003)(20776003)(64706001)(31966008)(21056001)(66066001)(92566001)(86362001)(74316001)(79102003)(74502003)(74662003)(81342003)(81542003)(46102003)(77982003)(95666004)(80022003)(99286002)(85306004)(93886004)(97736003)(120916001)(108616004)(76482002)(10300001)(99396003)(19580405001)(105586002)(106356001)(90102001)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR03MB479;H:DM2PR03MB574.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8S2XCXI007463

> -----Original Message-----
> From: Linuxppc-dev
> [mailto:linuxppc-dev-bounces+b29983=freescale.com@lists.ozlabs.org] On
> Behalf Of Mike Turquette
> Sent: Saturday, September 27, 2014 7:29 AM
> To: Wood Scott-B07421
> Cc: linuxppc-dev@lists.ozlabs.org; linux-kernel@vger.kernel.org;
> linux-arm-kernel@lists.infradead.org; Lu Jingchang-B35083
> Subject: Re: [PATCHv4] clk: ppc-corenet: rename to ppc-qoriq and add
> CLK_OF_DECLARE support
> 
> Quoting Scott Wood (2014-09-25 15:56:20)
> > On Thu, 2014-09-25 at 15:54 -0700, Mike Turquette wrote:
> > > Quoting Scott Wood (2014-09-25 13:08:00)
> > > > Well, like I said, I'd rather see the CLK_OF_DECLARE stuff be made
> > > > to work on PPC rather than have the driver carry around two
> > > > binding methods.
> > >
> > > I guess that is an existing problem, and not related directly to
> > > this patch? This patch is essentially just renames (though the
> > > V1.0/V2.0 stuff seems weird).
> >
> > This patch is adding CLK_OF_DECLARE.
> 
> I'm fine taking this patch but your comments are still unresolved. What do you
> think needs to be done to fix the problems that you see?
> 
CLK_OF_DECLARE is totally worked on PPC. I will do it in a separate patch.
Regarding V1.0 and V2.0, it is not wired just same for now. But we are not sure if it is same for v3.0 in the future.

Besides updating drivers/cpufreq/Kconfig.powerpc, there is one more thing I am not comfortable with:
This patch uses " fixed-clock" as sysclk's compatible string, while on PPC we treated it as " fsl,qoriq-sysclk-[1-2].0".
That's inconsistent on both ARM and PPC platforms, neither did on bindings.

Thanks,
Yuantian

> Regards,
> Mike
> 
> >
> > -Scott
> >
> >
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
