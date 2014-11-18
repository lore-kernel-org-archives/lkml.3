Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213AbaKRHLz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 02:11:55 -0500
Received: from mail-bn1bon0134.outbound.protection.outlook.com ([157.56.111.134]:39558
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751417AbaKRHLy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 02:11:54 -0500
From: Yao Yuan <yao.yuan@freescale.com>
To: Wolfram Sang <wsa@the-dreams.de>
CC: "marex@denx.de" <marex@denx.de>,
        "LW@KARO-electronics.de" <LW@KARO-electronics.de>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "fugang.duan@freescale.com" <fugang.duan@freescale.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Subject: RE: [PATCH v10 3/3] i2c: imx: add DMA support for freescale i2c
 driver
Thread-Topic: [PATCH v10 3/3] i2c: imx: add DMA support for freescale i2c
 driver
Thread-Index: AQHQAlNQ5KR/vASdyU+tHvRH3gUhMJxlIrmAgADNQTA=
Date: Tue, 18 Nov 2014 06:56:27 +0000
Message-ID: <BL2PR03MB33898E57AC61B7D45685DCB83880@BL2PR03MB338.namprd03.prod.outlook.com>
References: <1416220836-7666-1-git-send-email-yao.yuan@freescale.com>
 <1416220836-7666-4-git-send-email-yao.yuan@freescale.com>
 <20141117182413.GC12644@katana>
In-Reply-To: <20141117182413.GC12644@katana>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.50]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB370;UriScan:;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB370;
x-forefront-prvs: 039975700A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(199003)(13464003)(164054003)(189002)(24454002)(51704005)(377454003)(76576001)(106356001)(20776003)(74316001)(50986999)(110136001)(54356999)(105586002)(31966008)(95666004)(99286002)(64706001)(106116001)(54606007)(107046002)(76176999)(66066001)(46102003)(92566001)(4396001)(92726001)(62966003)(77156002)(122556002)(120916001)(99396003)(54206007)(19580405001)(101416001)(19580395003)(21056001)(86362001)(40100003)(2656002)(97736003)(33656002)(87936001);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR03MB370;H:BL2PR03MB338.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB482;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram,

Thank you for having found the bug, I indeed missed initializing it('orig_jiffies'). 
I will do more detailed review and send the v11 soon.

Best Regards,
Yuan Yao

> -----Original Message-----
> From: Wolfram Sang [mailto:wsa@the-dreams.de]
> Sent: Tuesday, November 18, 2014 2:24 AM
> To: Yuan Yao-B46683
> Cc: marex@denx.de; LW@KARO-electronics.de; mark.rutland@arm.com; Duan
> Fugang-B38611; shawn.guo@linaro.org; linux-kernel@vger.kernel.org; linux-
> arm-kernel@lists.infradead.org; linux-i2c@vger.kernel.org
> Subject: Re: [PATCH v10 3/3] i2c: imx: add DMA support for freescale i2c
> driver
> 
> On Mon, Nov 17, 2014 at 06:40:36PM +0800, Yuan Yao wrote:
> > Add dma support for i2c. This function depend on DMA driver.
> > You can turn on it by write both the dmas and dma-name properties in
> dts node.
> > DMA is optional, even DMA request unsuccessfully, i2c can also work
> well.
> >
> > Signed-off-by: Yuan Yao <yao.yuan@freescale.com>
> 
> gcc found a bug:
> 
> drivers/i2c/busses/i2c-imx.c:703:7: warning: 'orig_jiffies' may be used
> uninitialized in this function [-Wuninitialized]
> drivers/i2c/busses/i2c-imx.c:672:16: note: 'orig_jiffies' was declared
> here
> 
> > +	result = wait_for_completion_interruptible_timeout(
> > +				&i2c_imx->dma->cmd_complete,
> > +				msecs_to_jiffies(DMA_TIMEOUT));
> 
> And are you sure you want to use
> wait_for_completion_interruptible_timeout() instead of
> wait_for_completion_timeout() here? Unless you confirm you tested it a
> lot with signals, I really cannot recommend the *_interruptible_* version.
> 
> Other than that, good. I liked the logfile of what you tested very much!
> 
> Thanks,
> 
>    Wolfram

