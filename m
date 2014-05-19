Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447AbaESCf1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 22:35:27 -0400
Received: from mail-bn1blp0186.outbound.protection.outlook.com ([207.46.163.186]:36372
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751897AbaESCf0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 22:35:26 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
Subject: RE: [PATCHv2 1/2] clocksource: fix type confusion for
 clocksource_mmio_readX_Y
Thread-Topic: [PATCHv2 1/2] clocksource: fix type confusion for
 clocksource_mmio_readX_Y
Thread-Index: AQHPXp+EEHZ9UXv4rUWfmoNIjU+5FJtHV7sg
Date: Mon, 19 May 2014 02:35:21 +0000
Message-ID: <7dd1dc731dd24e15a170ef95aeee2a2e@BY2PR03MB505.namprd03.prod.outlook.com>
References: <1398219120-23029-1-git-send-email-Li.Xiubo@freescale.com>
In-Reply-To: <1398219120-23029-1-git-send-email-Li.Xiubo@freescale.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.49]
x-forefront-prvs: 021670B4D2
x-forefront-antispam-report: SFV:NSPM;SFS:(6009001)(428001)(377454003)(189002)(199002)(164054003)(51704005)(101416001)(575784001)(86362001)(81542001)(74316001)(50986999)(54356999)(77096999)(33646001)(19580395003)(76176999)(76576001)(4396001)(77982001)(99396002)(99286001)(2201001)(92566001)(21056001)(31966008)(74502001)(64706001)(83322001)(46102001)(79102001)(74662001)(76482001)(83072002)(2656002)(81342001)(20776003)(87936001)(66066001)(80022001)(19580405001)(85852003)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB508;H:BY2PR03MB505.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Li.Xiubo@freescale.com; 
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s4J2ZXrs032110

Hi,

I'd like to know the status about this patch series...
:£©

Thanks,
BRs
Xiubo



> -----Original Message-----
> From: Xiubo Li [mailto:Li.Xiubo@freescale.com]
> Sent: Wednesday, April 23, 2014 10:12 AM
> To: daniel.lezcano@linaro.org; tglx@linutronix.de; linux-
> kernel@vger.kernel.org
> Cc: Xiubo Li-B47053
> Subject: [PATCHv2 1/2] clocksource: fix type confusion for
> clocksource_mmio_readX_Y
> 
> The types' definations are:
>    o  cycle_t       -> u64
>    o  readl_relaxed -> u32
>    o  readw_relaxed -> u16
> 
> So let clocksource_mmio_readX_Ys return a cast to cycle_t, though
> this maybe look reduntant sometimes, it make sense and they will be
> more readable and less confusion...
> 
> This patch clarifies the functions type and fix it.
> 
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> ---
>  drivers/clocksource/mmio.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/clocksource/mmio.c b/drivers/clocksource/mmio.c
> index c0e2512..19a6b3f 100644
> --- a/drivers/clocksource/mmio.c
> +++ b/drivers/clocksource/mmio.c
> @@ -22,22 +22,22 @@ static inline struct clocksource_mmio
> *to_mmio_clksrc(struct clocksource *c)
> 
>  cycle_t clocksource_mmio_readl_up(struct clocksource *c)
>  {
> -	return readl_relaxed(to_mmio_clksrc(c)->reg);
> +	return (cycle_t)readl_relaxed(to_mmio_clksrc(c)->reg);
>  }
> 
>  cycle_t clocksource_mmio_readl_down(struct clocksource *c)
>  {
> -	return ~readl_relaxed(to_mmio_clksrc(c)->reg);
> +	return ~(cycle_t)readl_relaxed(to_mmio_clksrc(c)->reg);
>  }
> 
>  cycle_t clocksource_mmio_readw_up(struct clocksource *c)
>  {
> -	return readw_relaxed(to_mmio_clksrc(c)->reg);
> +	return (cycle_t)readw_relaxed(to_mmio_clksrc(c)->reg);
>  }
> 
>  cycle_t clocksource_mmio_readw_down(struct clocksource *c)
>  {
> -	return ~(unsigned)readw_relaxed(to_mmio_clksrc(c)->reg);
> +	return ~(cycle_t)readw_relaxed(to_mmio_clksrc(c)->reg);
>  }
> 
>  /**
> --
> 1.8.4

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
