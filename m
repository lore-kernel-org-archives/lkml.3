Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751831Ab3LXKLY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 05:11:24 -0500
Received: from mail-bn1blp0188.outbound.protection.outlook.com ([207.46.163.188]:24234
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751528Ab3LXKLW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 05:11:22 -0500
From: "Anson.Huang@freescale.com" <Anson.Huang@freescale.com>
To: Shawn Guo <shawn.guo@linaro.org>
CC: "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] ARM: imx: improve the comment of CCM lpm SW workaround
Thread-Topic: [PATCH] ARM: imx: improve the comment of CCM lpm SW workaround
Thread-Index: AQHPAG3v62N2uVWN40+LvdWX3E6W6ppi/zSAgAAgjlA=
Date: Tue, 24 Dec 2013 10:11:18 +0000
Message-ID: <68bb5c5c3b57414ca5893a26eeda4bb5@BY2PR03MB315.namprd03.prod.outlook.com>
References: <1387908047-1848-1-git-send-email-b20788@freescale.com>
 <20131224081329.GF3872@S2101-09.ap.freescale.net>
In-Reply-To: <20131224081329.GF3872@S2101-09.ap.freescale.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.50]
x-forefront-prvs: 0070A8666B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(199002)(189002)(377454003)(51704005)(24454002)(51914003)(13464003)(85306002)(81542001)(63696002)(77982001)(59766001)(74502001)(47446002)(79102001)(76576001)(76796001)(76786001)(81342001)(85852003)(53806001)(51856001)(76482001)(87266001)(54356001)(87936001)(69226001)(2656002)(46102001)(83072002)(74366001)(74316001)(50986001)(47976001)(4396001)(47736001)(49866001)(56776001)(54316002)(83322001)(19580405001)(19580395003)(66066001)(81816001)(81686001)(56816005)(80976001)(74662001)(33646001)(74706001)(31966008)(90146001)(65816001)(80022001)(74876001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB314;H:BY2PR03MB315.namprd03.prod.outlook.com;CLIP:123.151.195.50;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rBOABlMP030769

Hi, Shawn
	Thanks for the detail review, I think it is better to have such info in comments if we already have such hardware errata created, I will sent out V2 soon.

Best Regards.
Anson huang é»„å‹‡æ‰
Â 
Freescale Semiconductor Shanghai
ä¸Šæµ·æµ¦ä¸œæ–°åŒºäº®æ™¯è·¯192å·Aåº§2æ¥¼
201203
Tel:021-28937058


>-----Original Message-----
>From: Shawn Guo [mailto:shawn.guo@linaro.org]
>Sent: Tuesday, December 24, 2013 4:14 PM
>To: Huang Yongcai-B20788
>Cc: kernel@pengutronix.de; linux-arm-kernel@lists.infradead.org; linux-
>kernel@vger.kernel.org
>Subject: Re: [PATCH] ARM: imx: improve the comment of CCM lpm SW workaround
>
>On Tue, Dec 24, 2013 at 01:00:47PM -0500, Anson Huang wrote:
>> Improve the comment of SW workaround for CCM lpm issue using hardware
>> errata description to avoid confusion.
>>
>> TKT194736:
>
>This is not the errata number that will be seen by people publicly.
>That's why I did not give it in the original commit d48866f (ARM: imx:
>ensure dsm_request signal is not asserted when setting LPM).  But if you check
>the log of that commit, you will find we already have the information you're
>adding here.
>
>The good thing is we have that errata publicly available now as below.
>
>ERR007265 CCM: When improper low-power sequence is used, the SoC enters low
>power mode before the ARM core executes WFI
>
>http://cache.freescale.com/files/32bit/doc/errata/IMX6DQCE.pdf?fpsp=1
>
>So if you want to make it clear, you should quote the errata info that is
>publicly available to people.
>
>Shawn
>
>> Chip will enter low power mode before ARM A9 CPU executes WFI when
>> improper low power sequence is used.
>>
>> SW workaround:
>> 1) SW will trigger irq #32(IOMUX) to be always pending manually by
>> setting IOMUX_GPR1_GINT bit,
>> 2) SW should then Unmask it in GPC before setting CCM LPM
>> 3) SW should Mask it right after CCM LPM is set (set bit0-1 of
>> CCM_CLPCR)
>>
>> Signed-off-by: Anson Huang <b20788@freescale.com>
>> ---
>>  arch/arm/mach-imx/pm-imx6q.c |   13 +++++++++----
>>  1 file changed, 9 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/arm/mach-imx/pm-imx6q.c
>> b/arch/arm/mach-imx/pm-imx6q.c index aecd9f8..8da4732 100644
>> --- a/arch/arm/mach-imx/pm-imx6q.c
>> +++ b/arch/arm/mach-imx/pm-imx6q.c
>> @@ -156,10 +156,13 @@ int imx6q_set_lpm(enum mxc_cpu_pwr_mode mode)
>>  	}
>>
>>  	/*
>> -	 * Unmask the always pending IOMUXC interrupt #32 as wakeup source to
>> -	 * deassert dsm_request signal, so that we can ensure dsm_request
>> -	 * is not asserted when we're going to write CLPCR register to set LPM.
>> -	 * After setting up LPM bits, we need to mask this wakeup source.
>> +	 * TKT194736:
>> +	 * Chip will enter low power mode before ARM A9 CPU executes WFI when
>improper low power sequence is used.
>> +	 *
>> +	 * SW workaround:
>> +	 * 1) SW will trigger irq #32(IOMUXC) to be always pending manually by
>setting IOMUX_GPR1_GINT bit,
>> +	 * 2) SW should then Unmask it in GPC before setting CCM LPM
>> +	 * 3) SW should Mask it right after CCM LPM is set (set bit0-1 of
>> +CCM_CLPCR)
>>  	 */
>>  	iomuxc_irq_desc = irq_to_desc(32);
>>  	imx_gpc_irq_unmask(&iomuxc_irq_desc->irq_data);
>> @@ -219,6 +222,8 @@ void __init imx6q_pm_init(void)
>>  	WARN_ON(!ccm_base);
>>
>>  	/*
>> +	 * This is for SW workaround step #1 of TKT194736, see comments
>> +	 * in imx6q_set_lpm for details of this errata.
>>  	 * Force IOMUXC irq pending, so that the interrupt to GPC can be
>>  	 * used to deassert dsm_request signal when the signal gets
>>  	 * asserted unexpectedly.
>> --
>> 1.7.9.5
>>
>>

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
