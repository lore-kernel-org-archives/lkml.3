Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285Ab3EWIUP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 04:20:15 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:36443 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757124Ab3EWIUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 04:20:10 -0400
MIME-Version: 1.0
In-Reply-To: <519DCEE9.6070208@schinagl.nl>
References: <1368797744-13737-1-git-send-email-oliver+list@schinagl.nl>
	<1368797744-13737-2-git-send-email-oliver+list@schinagl.nl>
	<CACRpkdaWADjy1YZXTcRaXU+ZsS6_pG0hojQdnz=qeTgyVY7_Ww@mail.gmail.com>
	<519DCEE9.6070208@schinagl.nl>
Date: Thu, 23 May 2013 10:20:09 +0200
Message-ID: <CACRpkdZveQsVpw7_FnecGNZX4nVwWMtVwme7JEcy1R7uvdEe8A@mail.gmail.com>
Subject: Re: [PATCH 1/2] Initial support for Allwinner's Security ID fuses
From: Linus Walleij <linus.walleij@linaro.org>
To: Oliver Schinagl <oliver+list@schinagl.nl>, "Theodore Ts'o" <tytso@mit.edu>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Arnd Bergmann <arnd@ardb.de>, Greg KH <gregkh@linuxfoundation.org>,
        Oliver Schinagl <oliver@schinagl.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 23, 2013 at 10:10 AM, Oliver Schinagl
<oliver+list@schinagl.nl> wrote:
> On 05/23/13 09:56, Linus Walleij wrote:
>>
>> On Fri, May 17, 2013 at 3:35 PM, Oliver Schinagl
>> <oliver+list@schinagl.nl> wrote:
>>
>> (...)
>>>
>>> While initially these fuses are used to somewhat determin the chipID,
>>> these
>>> appear to be writeable by the user and thus can be used for other
>>> purpouses.
>>> For example storing a 128 bit root key, a unique serial number, which
>>> could
>>> then even be used as a MAC address.
>>
>> (...)
>> Then follows some code to read out the keys from sysfs I guess..
>>>
>>> +static int __init sid_probe(struct platform_device *pdev)
>>
>>
>> It's really simple to actually make the kernel use this to seed the
>> entropy pool.
>>
>> #include <linux/random.h>
>> add_device_randomness(u8 *, num);
>>
>> If you know after probe that you can read out a number of bytes
>> of device-unique data, I think you should add those bytes to the
>> entropy pool like this.
>
> While that is a great idea, we can't guarantee device uniqueness. We've
> already seen some chips that where 'forgotten' to program and default set to
> all 0. I guess that doesn't have to be a bad thing.

Ted can confirm but AFAIK that is not a problem. This device-unique
numer is just one of the things mixed into the pool, if it's on some
devices just an array of zeroes it does not make things worse, but
in the cases when there is some uniqueness in it make things better.

> It should probably be noted, that the sunxi series have a hardware crypto
> engine, with hardware random seed generator, one for a later project.

That will anyway be augmented with the contents of the entropy
pool rather than returned to random clients right off if I know the
recent changes to random code right.

Yours,
Linus Walleij
