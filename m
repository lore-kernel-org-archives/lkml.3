Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184Ab3LQMk1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 07:40:27 -0500
Received: from [207.46.163.236] ([207.46.163.236]:30680 "EHLO
	na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751390Ab3LQMk0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 07:40:26 -0500
From: "Anson.Huang@freescale.com" <Anson.Huang@freescale.com>
To: Mark Brown <broonie@kernel.org>
CC: "Anson.Huang@freescale.com" <Anson.Huang@freescale.com>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: anatop: add is_enabled interface
Thread-Topic: [PATCH] regulator: anatop: add is_enabled interface
Thread-Index: AQHO+pDIV/D3fG4A102vVTpa2+vRu5pXqSDwgACo+oCAAAKQRg==
Date: Tue, 17 Dec 2013 12:38:33 +0000
Message-ID: <A9C48E12-97A7-4A66-98EB-BA7BC23F27B3@freescale.com>
References: <1387228827-933-1-git-send-email-b20788@freescale.com>
 <20131216185753.GN3185@sirena.org.uk>
 <c9e35710598c4a66823e67fd4f81c0d7@BY2PR03MB315.namprd03.prod.outlook.com>,<20131217122923.GT3185@sirena.org.uk>
In-Reply-To: <20131217122923.GT3185@sirena.org.uk>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rBHCeXjq000768



Sent from Anson's iPhone

> ÔÚ 2013Äê12ÔÂ17ÈÕ£¬20:29£¬"Mark Brown" <broonie@kernel.org> Ğ´µÀ£º
> 
> On Tue, Dec 17, 2013 at 02:38:56AM +0000, Anson.Huang@freescale.com wrote:
> 
> Please fix the line length you're using to word wrap, it should be less
> than 80 columns to make your mails readable.
> 
>>>> +    if (!anatop_reg->control_reg)
>>>> +        return -ENOTSUPP;
> 
>>> In what situation would this happen and why would the operation be provided in
>>> those situations?
> 
>> [Anson] This condition check is to avoid the case that control_reg is not
>> Initialized correctly in the probe function.
> 
> Why would that happen without the probe function failing - it would be
> better to add the error checking there wouldn't it?

Okay, than what about other functions? there is such condition check there is other functions too, that is why I add it here. if you think it is no necessary, I will remove this check in my patch?

> 
>> 1. For cpufreq change, we need to scale VDDARM as well as VDDSOC/PU's voltage, each
>> setpoint has different VDDARM, VDDSOC/PU voltage;
>> 2. VDDARM and VDDSOC will be always on but VDDPU can be off in uboot due to the big leakage
>> it has(as high as ~43mA on i.MX6Q), as it is only for GPU/VPU module, and we will have
>> dynamic VDDPU power management available, so VDDPU LDO's status is changing according to GPU/VPU's
>> behavior;
>> 3. If VDDPU is off during cpufreq change, then there is no need to scaling VDDPU's voltage,
>> so we will check whether VDDPU is enabled before scaling it in cpufreq driver, this is done
>> in my other patch thread;
> 
> This sounds like you need to have some higher level synchronisation
> between whatever is managing this supply and your cpufreq driver - if
> you rely on reading back the current status from the hardware there will
> always be races between reading the state and the other thing doing the
> enable or disable.

yes, you are right. but I think we have handled that, all the operations of this LDO will via regulator interface, and regulator framework already has mutex lock. so there should be no such race in kernel as long as we all use regulator interface to access anatop LDO.ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
