Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471Ab3LQNKR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 08:10:17 -0500
Received: from mail-by2lp0235.outbound.protection.outlook.com ([207.46.163.235]:46747
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752921Ab3LQNKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 08:10:15 -0500
From: "Anson.Huang@freescale.com" <Anson.Huang@freescale.com>
To: Mark Brown <broonie@kernel.org>
CC: "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: anatop: add is_enabled interface
Thread-Topic: [PATCH] regulator: anatop: add is_enabled interface
Thread-Index: AQHO+pDIV/D3fG4A102vVTpa2+vRu5pXqSDwgACo+oCAAAKQRoAABgaAgAAC0rQ=
Date: Tue, 17 Dec 2013 13:10:12 +0000
Message-ID: <242D3451-6B96-4A0E-88E0-44C4DCCD96FA@freescale.com>
References: <1387228827-933-1-git-send-email-b20788@freescale.com>
 <20131216185753.GN3185@sirena.org.uk>
 <c9e35710598c4a66823e67fd4f81c0d7@BY2PR03MB315.namprd03.prod.outlook.com>
 <20131217122923.GT3185@sirena.org.uk>
 <A9C48E12-97A7-4A66-98EB-BA7BC23F27B3@freescale.com>,<20131217130007.GZ3185@sirena.org.uk>
In-Reply-To: <20131217130007.GZ3185@sirena.org.uk>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [180.156.204.133]
x-forefront-prvs: 006339698F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(189002)(199002)(24454002)(45074003)(51704005)(76786001)(85852003)(87266001)(33656001)(36756003)(76796001)(83072002)(63696002)(85306002)(53806001)(90146001)(31966008)(51856001)(54356001)(76482001)(56816005)(65816001)(83716003)(80022001)(46102001)(47446002)(19580395003)(74662001)(83322001)(74502001)(19580405001)(66066001)(81816001)(77982001)(59766001)(81686001)(74366001)(69226001)(56776001)(54316002)(82746002)(79102001)(87936001)(2656002)(74876001)(74706001)(80976001)(47736001)(49866001)(81342001)(4396001)(81542001)(47976001)(50986001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB315;H:BY2PR03MB315.namprd03.prod.outlook.com;CLIP:180.156.204.133;FPR:;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rBHDANRR001102



Sent from Anson's iPhone

> ÔÚ 2013Äê12ÔÂ17ÈÕ£¬21:00£¬"Mark Brown" <broonie@kernel.org> Ğ´µÀ£º
> 
> On Tue, Dec 17, 2013 at 12:38:33PM +0000, Anson.Huang@freescale.com wrote:
> 
>>> better to add the error checking there wouldn't it?
> 
>> Okay, than what about other functions? there is such condition check
>> there is other functions too, that is why I add it here. if you think
>> it is no necessary, I will remove this check in my patch?
> 
> It shouldn't be in the other functions either.

got it, I will remove it later.


> 
>>> This sounds like you need to have some higher level synchronisation
>>> between whatever is managing this supply and your cpufreq driver - if
>>> you rely on reading back the current status from the hardware there will
>>> always be races between reading the state and the other thing doing the
>>> enable or disable.
> 
>> yes, you are right. but I think we have handled that, all the
>> operations of this LDO will via regulator interface, and regulator
>> framework already has mutex lock. so there should be no such race in
>> kernel as long as we all use regulator interface to access anatop LDO.
> 
> No, that's not going to work.  Consider this sequence:
> 
>    cpufreq        other driver
>            disable()
>    is_enabled()
>            enable()
> 
> The locking the regulator core does won't help you here, nothing stops
> the state of the regulator changing after it's read.  Your cpufreq
> driver should just change the voltage and not worry if the regulator is
> enabled, the voltage change won't have any effect while the regulator is
> off and presumably if it does get enabled then it needs to be enabled at
> whatever voltage cpufreq set anyway.
> 
> In any case I'd be much happier with this patch if it implemented the
> enable and disable operations as well.

understand now. then maybe I should remove the PU check in cpufreq, although setting PU LDO if it is off before would bring unnessary power leak. I will add all these changes together with the dynamic PU LDO management feature, thanks for your time!ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
