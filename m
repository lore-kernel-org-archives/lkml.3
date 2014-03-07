Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721AbaCGQDM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 11:03:12 -0500
Received: from mail-qa0-f41.google.com ([209.85.216.41]:50049 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567AbaCGQDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 11:03:10 -0500
MIME-Version: 1.0
X-Originating-IP: [218.164.134.110]
In-Reply-To: <5319E4E9.5010207@ti.com>
References: <1394111433.21007.2.camel@phoenix>
	<5319E4E9.5010207@ti.com>
Date: Fri, 7 Mar 2014 23:57:03 +0800
Message-ID: <CAFRkauACGODncvyPs0nNC+pkr4f55Xrhgn1hmAJbKHB+GoaVWA@mail.gmail.com>
Subject: Re: [PATCH RFT] regulator: pbias: Convert to use regmap helper functions
From: Axel Lin <axel.lin@ingics.com>
To: Balaji T K <balajitk@ti.com>
Cc: Chris Ball <chris@printf.net>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Florian Vaussard <florian.vaussard@epfl.ch>, Stefan Roese <sr@denx.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-03-07 23:25 GMT+08:00 Balaji T K <balajitk@ti.com>:
> On Thursday 06 March 2014 06:40 PM, Axel Lin wrote:
>>
>> This patch converts this driver to use the regmap helper functions
>> provided by
>> regulator core.
>>
>> This fixes a few issues in current implementation:
>>
>> 1) In original code, the set voltage does not check max_uV,
>>     which means if request max_uV < 1800000, it will still set the voltage
>>     to 1800000.
>>
>
> Hi Axel,
>
> May be I am not getting your logic here, why would max_uV be less than
> min_uV

I think this is an unlikely case here.
>
> The intention was to set vmode to 0 for any voltage request lesser than
> 1.8V.

This statement sounds wrong to me.
For example, If the request voltage range is 1.0V ~ 1.5V.
We should return error rather than set the voltage to 1.8V (which may
damage the device).

> With regmap conversion, set voltage of 0V will become invalid. However
> since pbias is not set to 0V anywhere, I think it shouldn't be an issue.
ok.

> Will test and confirm.

Thanks,
Axel
