Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947Ab3CWRdr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 13:33:47 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:46820 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673Ab3CWRdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 13:33:46 -0400
Message-ID: <514DE776.3050502@gmail.com>
Date: Sat, 23 Mar 2013 18:33:42 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
CC: Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, linux-kernel@vger.kernel.org,
        Soeren Moch <smoch@web.de>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: Kirkwood: fix unused mvsdio gpio pins
References: <1364043420-17641-1-git-send-email-sebastian.hesselbarth@gmail.com> <20130323161744.5d13c570@skate> <514DC982.3010706@gmail.com> <20130323173052.10ecc4cb@skate>
In-Reply-To: <20130323173052.10ecc4cb@skate>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/2013 05:30 PM, Thomas Petazzoni wrote:
> Dear Sebastian Hesselbarth,
>
> On Sat, 23 Mar 2013 16:25:54 +0100, Sebastian Hesselbarth wrote:
>
>> I understand that you proposed patch fixes mvsdio grab mpp0 by accident.
>> But what if you have a kirkwood board where cd-gpio _is_ connected to mpp0?
>
> It didn't work with the existing mvsdio driver, so the purpose of my
> patch was merely to restore the old behavior, in order to avoid having
> to change all the instances of mvsdio_platform_data, knowing that those
> would anyway go away as we convert boards to the Device Tree.

Thomas,

I agree both approaches fix the same issue. I haven't seen your patch
earlier and was just proposing a patch for the same issue. You or Jason
are free to choose whatever patch you like.

>> Not that there is one I know of, but IMHO the only useful patch is to
>> set passed values to an invalid gpio number.
>
> To me, it remains a fragile way of doing things. Let's say tomorrow you
> add a new "int foo_gpio" field in mvsdio_platform_data. The whole
> purpose of C99 struct initializers is that you don't have to change all
> instances of the structure because all fields that are not initialized
> with .<field>  =<value>  are guaranteed to be zero. If you need to set
> foo_gpio to -1 everywhere when you add this field, it becomes quite
> annoying.

I understand that struct initialization with zero is done for a purpose.
But gpio = 0 is a valid gpio number and engineers will always count from
zero ;)

Given the fact that .gpio = 0 is valid, you would have to add some
.really_use_that_number_i_was_too_lazy_to_set = 1.. but mvsdio_plaform_data
won't stay long as you already pointed out, and I am happy with any fix
for the issue.

>>> That said, I have nothing against explicitly setting those GPIO values
>>> to an invalid value. Maybe -EINVAL would make more sense than just -1 ?
>>
>> Every invalid gpio number will be sufficient. But -EINVAL doesn't make
>> more sense than -1 does. Having no cd-gpio is not an "Invalid argument".
>
> It's just that I've seen -EINVAL being used on some other platforms, at
> least mach-at91/, but I agree it's not an invalid argument per se.

If you don't like -1, you can choose -ENOENT. But -1 has been used for ages
as "invalid" or "unused" so it was my first guess.

Sebastian
