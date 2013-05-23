Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004Ab3EWIKW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 04:10:22 -0400
Received: from 7of9.schinagl.nl ([88.159.158.68]:35660 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751372Ab3EWIKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 04:10:18 -0400
Message-ID: <519DCEE9.6070208@schinagl.nl>
Date: Thu, 23 May 2013 10:10:17 +0200
From: Oliver Schinagl <oliver+list@schinagl.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130322 Thunderbird/17.0.4
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Arnd Bergmann <arnd@ardb.de>, Greg KH <gregkh@linuxfoundation.org>,
        Oliver Schinagl <oliver@schinagl.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/2] Initial support for Allwinner's Security ID fuses
References: <1368797744-13737-1-git-send-email-oliver+list@schinagl.nl> <1368797744-13737-2-git-send-email-oliver+list@schinagl.nl> <CACRpkdaWADjy1YZXTcRaXU+ZsS6_pG0hojQdnz=qeTgyVY7_Ww@mail.gmail.com>
In-Reply-To: <CACRpkdaWADjy1YZXTcRaXU+ZsS6_pG0hojQdnz=qeTgyVY7_Ww@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/13 09:56, Linus Walleij wrote:
> On Fri, May 17, 2013 at 3:35 PM, Oliver Schinagl
> <oliver+list@schinagl.nl> wrote:
>
> (...)
>> While initially these fuses are used to somewhat determin the chipID, these
>> appear to be writeable by the user and thus can be used for other purpouses.
>> For example storing a 128 bit root key, a unique serial number, which could
>> then even be used as a MAC address.
> (...)
> Then follows some code to read out the keys from sysfs I guess..
>> +static int __init sid_probe(struct platform_device *pdev)
>
> It's really simple to actually make the kernel use this to seed the
> entropy pool.
>
> #include <linux/random.h>
> add_device_randomness(u8 *, num);
>
> If you know after probe that you can read out a number of bytes
> of device-unique data, I think you should add those bytes to the
> entropy pool like this.
While that is a great idea, we can't guarantee device uniqueness. We've 
already seen some chips that where 'forgotten' to program and default 
set to all 0. I guess that doesn't have to be a bad thing.

Then, i'm not sure if the driver is the best for this to be loaded? 
Maxime, what do you think? Personally I would feel more in having this 
in the mach-sunxi/core.c bit, but then again, this is currently a module 
and wouldn't be useful to have there. Maxime is far more knowledgeable 
to answer that.

It should probably be noted, that the sunxi series have a hardware 
crypto engine, with hardware random seed generator, one for a later project.
>
> Yours,
> Linus Walleij
>

