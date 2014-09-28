Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559AbaI1Czd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 22:55:33 -0400
Received: from mail-bn1bon0117.outbound.protection.outlook.com ([157.56.111.117]:5120
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753307AbaI1Cz3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 22:55:29 -0400
X-Greylist: delayed 157808 seconds by postgrey-1.27 at vger.kernel.org; Sat, 27 Sep 2014 22:55:29 EDT
From: "Dongsheng.Wang@freescale.com" <Dongsheng.Wang@freescale.com>
To: Kumar Gala <galak@codeaurora.org>
CC: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sandeep Nair <sandeep_n@ti.com>, Olof Johansson <olof@lixom.net>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        Greg KH <gregkh@linuxfoundation.org>, Paul Walmsley <paul@pwsan.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Shengchao Guo <Shawn.Guo@freescale.com>
Subject: RE: [PATCH 2/2] soc/fsl: add ftm alarm driver for ls1021a platform
Thread-Topic: [PATCH 2/2] soc/fsl: add ftm alarm driver for ls1021a platform
Thread-Index: AQHP2VYNvkJJ8ylx3kqEIVXM63T25JwTcs4AgAJhgoA=
Date: Sun, 28 Sep 2014 02:55:25 +0000
Message-ID: <1806aa9735f7479f950734bb469c1136@BN1PR03MB188.namprd03.prod.outlook.com>
References: <1411714121-32138-1-git-send-email-dongsheng.wang@freescale.com>
 <1411714121-32138-2-git-send-email-dongsheng.wang@freescale.com>
 <B448818B-E208-4451-8BA0-53D53E4BB7FC@codeaurora.org>
In-Reply-To: <B448818B-E208-4451-8BA0-53D53E4BB7FC@codeaurora.org>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.50]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB340;UriScan:;
x-forefront-prvs: 03484C0ABF
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(13464003)(24454002)(51704005)(377454003)(189002)(199003)(87936001)(77096002)(105586002)(19580395003)(106356001)(90102001)(20776003)(66066001)(99286002)(2656002)(76576001)(107046002)(21056001)(64706001)(33646002)(110136001)(76176999)(95666004)(74316001)(74662003)(54356999)(108616004)(74502003)(120916001)(81542003)(97736003)(79102003)(80022003)(81342003)(50986999)(77982003)(46102003)(99396003)(101416001)(19580405001)(4396001)(83322001)(85852003)(83072002)(85306004)(10300001)(92566001)(31966008)(76482002)(86362001)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR03MB340;H:BN1PR03MB188.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB291;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for your review. :)


> -----Original Message-----
> From: Kumar Gala [mailto:galak@codeaurora.org]
> Sent: Friday, September 26, 2014 10:04 PM
> To: Wang Dongsheng-B40534
> Cc: Santosh Shilimkar; Sandeep Nair; Olof Johansson; shawn.guo@linaro.org; Greg
> KH; Paul Walmsley; Arnd Bergmann; linux-kernel@vger.kernel.org; Guo Shawn-R65073
> Subject: Re: [PATCH 2/2] soc/fsl: add ftm alarm driver for ls1021a platform
> 
> 
> On Sep 26, 2014, at 1:48 AM, Dongsheng Wang <dongsheng.wang@freescale.com> wrote:
> 
> > From: Wang Dongsheng <dongsheng.wang@freescale.com>
> >
> > Only Ftm0 can be used when system going to deep sleep. So this driver
> > to support ftm0 as a wakeup source.
> >
> > Signed-off-by: Wang Dongsheng <dongsheng.wang@freescale.com>
> 
> How does this differ from drivers/clocksource/fsl_ftm_timer.c

Fsl_ftm_timer.c is only for system to provide a clock driver. FTM ip-block can be used
by other functions such as PWM. I think we should not put all of functions into a .c file.
So ftm0 alarm function as a specific block driver in SOC dir.

> 
> Why not extend that with the alarm functionality you need?
The framework of clocksource not provide sys interface to set alarm. And codes of ftm0-alarm
not touch on clocksource framework.

> 
> Also, where is the DT binding spec for this (if you plan on having a separate
> driver)?
Yes, now only a driver. My DT depend on LS1 device tree patches, now LS1 DT is upstreaming but not apply.
After LS1 DT apply, I will add ftm alarm device node.

Regards,
-Dongsheng
