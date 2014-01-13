Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751567AbaAMMOI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 07:14:08 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:34030 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbaAMMOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 07:14:05 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-65-52d3d889b475
Message-id: <52D3D880.2090300@samsung.com>
Date: Mon, 13 Jan 2014 13:13:52 +0100
From: Tomasz Figa <t.figa@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.1.1
MIME-version: 1.0
To: Mark Brown <broonie@kernel.org>, Tomasz Figa <tomasz.figa@gmail.com>
Cc: linux-pm@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Pavel Machek <pavel@ucw.cz>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH RFC 06/10] ARM: s3c64xx: pm: Add device tree based power
 domain instantiation
References: <1389469372-17199-1-git-send-email-tomasz.figa@gmail.com>
 <1389469372-17199-7-git-send-email-tomasz.figa@gmail.com>
 <20140112192910.GW29039@sirena.org.uk> <52D2EE32.5060709@gmail.com>
 <20140113110935.GB29039@sirena.org.uk>
In-reply-to: <20140113110935.GB29039@sirena.org.uk>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFIsWRmVeSWpSXmKPExsVy+t/xq7qdNy4HGdyZJWqxccZ6VoupD5+w
	Wcw/co7Vov/NQlaL5sXr2SzOvVrJaNG74Cqbxawpe5ksNj2+xmpxedccNovPvUcYLWac38dk
	cfsyr8XS6xeZLO6eOspmMWH6WhaLM6cvsVq07j3CbvHqYBuLxapdfxgdRDzWzFvD6NHS3MPm
	cbmvl8lj56y77B4rl39h81i85yWTx6ZVnWwe++euYffYvKTeY8vVdhaPvi2rGD1WrP7O7vF5
	k5zHxrmhAXxRXDYpqTmZZalF+nYJXBnb3t5jKejiqpjevpqlgbGZo4uRk0NCwETi0ZEtjBC2
	mMSFe+vZuhi5OIQEljJKLDnRAOV8ZpT413afCaSKV0BL4u7WfSwgNouAqsS/Z11gcTYBNYnP
	DY/YQGxRgQiJv/PWM0LUC0r8mHwPqJ6DQ0TAQ2LNbm2QmcwC61klLlw5A1YjLJAs8XrGJnaI
	ZR8YJa6ueguW4BQwlvg7az3YAmYBa4mVk7YxQtjyEpvXvGWewCgwC8mOWUjKZiEpW8DIvIpR
	NLU0uaA4KT3XSK84Mbe4NC9dLzk/dxMjJH6/7mBceszqEKMAB6MSD+8OoctBQqyJZcWVuYcY
	JTiYlUR4VY8DhXhTEiurUovy44tKc1KLDzEycXBKNTBWmB3hm7fl3Z1uBu4LjG4bUuKVC2+d
	7olyCZxuxOkUPsdrr/f6VWFrdoos2d552VTqTfb3/Mc9gWe0zqpuOyHUUr58u3yWZG5Vts75
	p0tdOBjfPFjnzR9i+CL9TPDXoy6MD0stnxd3lMXOeXJoi1TOWa+km3uyUhY675x+ky3TxHv+
	w1u8H3YosRRnJBpqMRcVJwIAyfH5ur0CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.01.2014 12:09, Mark Brown wrote:
> On Sun, Jan 12, 2014 at 08:34:10PM +0100, Tomasz Figa wrote:
>> On 12.01.2014 20:29, Mark Brown wrote:
>>> On Sat, Jan 11, 2014 at 08:42:48PM +0100, Tomasz Figa wrote:
>
>>>> This patch adds support for registering power domains of S3C64xx SoCs
>>>> and binding devices to them using device tree.
>
>>>> +#ifdef CONFIG_OF
>>>> +static struct of_device_id s3c64xx_pd_matches[] = {
>>>> +	{ .compatible = "samsung,s3c6400-clock", },
>>>> +	{ .compatible = "samsung,s3c6410-clock", },
>>>> +	{ },
>>>>   };
>
>>> Looks like a rebasing issue?  Otherwise this looks nice.
>
>> Hmm, what's the problem here? Maybe I'm just blind, but I fail to
>> see anything wrong (except that the array should be const...).
>
>> Thanks for reviewing this.
>
> I wasn't expecting to see references to clocks come up in power domain
> code.
>

Power domain control registers are part of the system controller block, 
which uses the "samsung,s3c64*-clock" compatible string. I know this is 
a bit unfortunate, but all registers of this IP block are mapped at the 
same page and some clock registers are at the other end of this area 
than others, so there is even no good way to split them into separate 
mappings.

Best regards,
Tomasz
