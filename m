Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750902AbaJPEnc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 00:43:32 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35264 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750733AbaJPEnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 00:43:31 -0400
Message-ID: <543F4CF0.8080404@free-electrons.com>
Date: Thu, 16 Oct 2014 06:43:28 +0200
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>
CC: dwmw2@infradead.org, computersforpeace@gmail.com, jg1.han@samsung.com,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mtd: orion_nand: fix error code path in probe
References: <1413296198-29486-1-git-send-email-michael.opdenacker@free-electrons.com> <20141014213503.GD5331@lunn.ch> <20141015213953.GB23155@arch.hh.imgtec.org>
In-Reply-To: <20141015213953.GB23155@arch.hh.imgtec.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew, Ezequiel,

Many thanks for your review!

On 10/15/2014 11:39 PM, Ezequiel Garcia wrote:
> On 14 Oct 11:35 PM, Andrew Lunn wrote:
>
>> Hi Michael
>>
>> It is quite a common pattern to use:
>>
>>         res = platform_get_resource(dev, IORESOURCE_MEM, 0);
>>         c->membase = devm_ioremap_resource(&dev->dev, res);
>>         if (IS_ERR(c->membase))
>> 	   return PTR_ERR(c->membase)
>>
>> which is more compact.

I like it, thanks for the suggestion!

>>
> Be careful with this. devm_ioremap and devm_ioremap_resource are not
> the same thing, as the former requests the region as well.
>
> It can break things if the region is shared across several drivers.
> I don't think this is the case, so in fact adding the request is correct,
> but it's a more intrusive change than just "code cleanup".

Right. If I understand correctly, requesting the region should always be
done anyway, so this should be a welcome change.

What Andrew suggests also changes the return value: -ENOMEM instead of
-EIO, though it should be more standard. This could have side effects too!

I'll post a V2 right away.

Thanks again!

Cheers,

Michael.

-- 
Michael Opdenacker, CEO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
+33 484 258 098

