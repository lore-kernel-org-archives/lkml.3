Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932517AbaGOKyV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 06:54:21 -0400
Received: from mail-bn1blp0184.outbound.protection.outlook.com ([207.46.163.184]:38407
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758729AbaGOKyT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 06:54:19 -0400
Date: Tue, 15 Jul 2014 12:53:56 +0200
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>, Michal Simek <michal.simek@xilinx.com>
CC: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>,
        Andreas Olofsson <andreas@adapteva.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH 1/1] ARM: dts: zynq: Add Parallella device tree
References: <1404075022-28745-1-git-send-email-afaerber@suse.de>
	<1404075022-28745-2-git-send-email-afaerber@suse.de>
	<CAOesGMhKY1Lb+o8AbtFXS5c7SLg2uGt4-oosdro2FMj_+bB6Tw@mail.gmail.com>
	<61d660b7-17a9-4817-ba34-40a5c1674d28@BY2FFO11FD032.protection.gbl>
 <CAOesGMjMEiQkrCfYyc6y+s9kst74jAjTghbYvxUJ+9KvPGXj1Q@mail.gmail.com>
In-Reply-To: <CAOesGMjMEiQkrCfYyc6y+s9kst74jAjTghbYvxUJ+9KvPGXj1Q@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-RCIS-Action: ALLOW
Message-ID: <74ed2164-b1cf-4470-a853-e8f4c7804f41@BN1BFFO11FD008.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(199002)(189002)(377454003)(164054003)(51444003)(51704005)(479174003)(24454002)(44976005)(83506001)(31966008)(21056001)(74316001)(20776003)(64706001)(65956001)(87936001)(6806004)(19580395003)(19580405001)(83322001)(70736001)(80022001)(74502001)(74662001)(47776003)(65806001)(23676002)(33646002)(83072002)(81542001)(77982001)(81342001)(85852003)(46102001)(79102001)(4396001)(76482001)(107046002)(104016003)(106466001)(1496007)(85306003)(95666004)(93886003)(102836001)(50986999)(86362001)(76176999)(92566001)(99396002)(54356999)(92726001)(31696002)(65826006)(2004002)(107986001);DIR:OUT;SFP:;SCL:1;SRVR:BN1BFFO11HUB013;H:xir-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-62-221-5-235.ipspace.xilinx.com;A:1;MX:1;LANG:en;
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 027367F73D
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2014 08:12 PM, Olof Johansson wrote:
> On Tue, Jul 8, 2014 at 4:18 AM, Michal Simek <michal.simek@xilinx.com> wrote:
>> On 06/30/2014 07:15 AM, Olof Johansson wrote:
>>> Hi,
>>>
>>> On Sun, Jun 29, 2014 at 1:50 PM, Andreas Färber <afaerber@suse.de> wrote:
>>>> This allows to boot the Adapteva Parallella board to serial console.
>>>>
>>>> Cc: Andreas Olofsson <andreas@adapteva.com>
>>>> Signed-off-by: Andreas Färber <afaerber@suse.de>
>>>
>>> Nice and clean DTS, just a couple of comments below.
>>>
>>>> diff --git a/arch/arm/boot/dts/zynq-parallella.dts b/arch/arm/boot/dts/zynq-parallella.dts
>>>> new file mode 100644
>>>> index 0000000..98df66c
>>>> --- /dev/null
>>>> +++ b/arch/arm/boot/dts/zynq-parallella.dts
>>>> @@ -0,0 +1,63 @@
>>>> +/*
>>>> + * Copyright (c) 2014 SUSE LINUX Products GmbH
>>>> + *
>>>> + * Derived from zynq-zed.dts:
>>>> + *
>>>> + *  Copyright (C) 2011 Xilinx
>>>> + *  Copyright (C) 2012 National Instruments Corp.
>>>> + *  Copyright (C) 2013 Xilinx
>>>> + *
>>>> + * This software is licensed under the terms of the GNU General Public
>>>> + * License version 2, as published by the Free Software Foundation, and
>>>> + * may be copied, distributed, and modified under those terms.
>>>> + *
>>>> + * This program is distributed in the hope that it will be useful,
>>>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>>>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>>>> + * GNU General Public License for more details.
>>>> + */
>>>> +/dts-v1/;
>>>> +/include/ "zynq-7000.dtsi"
>>>> +
>>>> +/ {
>>>> +       model = "Parallella Board";
> 
> You might want to have this say "Adapteva Parallella Board" instead
> (just noticed).
> 
>>>> +       compatible = "xlnx,zynq-7000";
>>>
>>> This should have a more specific compatible as the first one. Probably
>>> something like:
>>>    compatible = "adapteva,parallella", "xlnx,zynq-7000";
>>
>> We were using these compatible properties but later there is no reason
>> to create them because they will be unused.
>> It is easy to add it when you need it which is not this case.
> 
> No, please add it from day one, otherwise everybody needs to update
> their device tree, some will miss doing it, etc, etc. It's a simple
> and trivial thing to do, and no reason to leave it o ut.

It is trivial. None will just probably use it and upgrading DTS is simple
but I don't really care.


>>>> +
>>>> +       memory {
>>>> +               device_type = "memory";
>>>> +               reg = <0 0x20000000>;
>>>
>>> Does the bootloader update this entry, or is it truly static? If it's
>>> updated then it's become recent habit to leave the memory size empty
>>> in the static file.
>>
>> Depends on your bootloader. I think it is good to have it here.
>> Also this file can be used by u-boot for example and u-boot can be configured
>> from it that's why I think that make sense to keep this here.
> 
> Ok. It's become commonplace to leave memory empty for the machines
> where it's guaranteed that the bootloader will have updated it, to
> avoid having stale or incorrect values in the static tree. I'm not
> going to be strict about it, but it's something to consider.

I personally don't like this bootloader feature and IRC it is disabled
for xilinx u-boot too.

Thanks,
Michal



