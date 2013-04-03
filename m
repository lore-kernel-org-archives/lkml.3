Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760233Ab3DCMOX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 08:14:23 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:33541 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759154Ab3DCMOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 08:14:22 -0400
MIME-Version: 1.0
In-Reply-To: <1364451516.15039.11.camel@gitbox>
References: <1364447397-29005-1-git-send-email-swarren@wwwdotorg.org>
	<1364451516.15039.11.camel@gitbox>
Date: Wed, 3 Apr 2013 14:14:21 +0200
Message-ID: <CACRpkdbrhYJ8PrVpb9G0Zz8NPqD_NQ52peSEFU=1SmfPZGaPig@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: bcm2835: make use of of_property_read_u32_index()
From: Linus Walleij <linus.walleij@linaro.org>
To: Tony Prisk <linux@prisktech.co.nz>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        linux-rpi-kernel@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 28, 2013 at 7:18 AM, Tony Prisk <linux@prisktech.co.nz> wrote:
> On Wed, 2013-03-27 at 23:09 -0600, Stephen Warren wrote:
>> Use the new standard API of_property_read_u32_index() instead of open-
>> coding it.
>>
>> Signed-off-by: Stephen Warren <swarren@wwwdotorg.org>
>> ---
>> Note: This depends on the proposed patch "of: Add support for reading
>> a u32 from a multi-value property" by Tony Prisk.
>>
>> BTW, I realized why I didn't create that standard API, but wrote custom
>> prop_u32() instead; the code has already looked up the properties, and
>> validated their length, so prop_u32() can simply index into the property
>> data, whereas of_property_read_u32_index() needs to go search for the
>> property and re-validate it every time, so there's a bunch more overhead.
>> It also means duplicating the property name, although I could use a
>> define for that. I'm not entirely convinced that using this standard API
>> is a win in this case. LinusW, Tony, what do you think?
>> ---
>
> When I was writing the function I had a similar thought about the fact
> we need to work out the length first, which as you mentioned, requires
> all the prior work on the property anyway.
>
> I didn't bring it up, because I thought someone might say 'hey, you
> should add a function to get the count as well' :)
>
> In both the brcm and vt8500 use cases, we will have the issue of
> multiple lookups on the same property using 'generic' functions. Price
> we have to pay for generic code?

My take on this is that if you look in for example:
drivers/of/platform.c you find that for every node in the device
tree when it creates a platform device with a resource it will
for example call of_address_to_resource() twice. The same
for IRQs IIRC.

So basically this behaviour is inherent in all OF/DT code,
and no point trying to work around it.

I don't know if there is a way to fix the problem at the root,
like have the DT parser annotate nodes with the number of
resources of each type (like a decorated tree) so it can be
looked up quickly somehow. I'm not smart enough on DT for
such things...

Yours,
Linus Walleij
