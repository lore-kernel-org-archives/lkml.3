Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758146Ab3BZMRd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 07:17:33 -0500
Received: from vsp-authed02.binero.net ([195.74.38.226]:33087 "HELO
	vsp-authed-02-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753371Ab3BZMRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 07:17:32 -0500
Message-ID: <512CA7D9.3040004@gaisler.com>
Date: Tue, 26 Feb 2013 13:17:29 +0100
From: Andreas Larsson <andreas@gaisler.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, software@gaisler.com
Subject: Re: [PATCH 1/2] gpio: gpio-generic: Fix bug in big endian bit conversion
References: <1360060383-16880-1-git-send-email-andreas@gaisler.com> <1360060383-16880-2-git-send-email-andreas@gaisler.com> <20130209145855.D517E3E328E@localhost> <20130226075228.A963F3E0AEF@localhost> <512C9287.6000100@gaisler.com>
In-Reply-To: <512C9287.6000100@gaisler.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-02-26 11:46, Andreas Larsson wrote:
> On 2013-02-26 08:52, Grant Likely wrote:
>> On Sat, 09 Feb 2013 14:58:55 +0000, Grant Likely
>> <grant.likely@secretlab.ca> wrote:
>> We /could/ have a ioread32be/write32be mode in the driver, but I don't
>> think that is the right approach. It means we need yet another set of
>> accessors for register except using the 'be' variants. Blech. What I'd
>> actually like to do is add a bitmask field to the gpio_desc which can be
>> calculated ahead of time to whatever madness is required from the way
>> the device is wired. Then the access routines don't need to even care.
>> they just apply the bitmask to ioread/iowrite and it doesn't even need
>> to know what the bit number actually is. The new support for gpio_desc
>> in the core code makes this feasable.
>
> I am not sure I understand what you mean here or what new support for
> gpio_desc you are referring to (looking in gpio/next at
> git://git.secretlab.ca/git/linux-2.6).
>
> Do you mean to add something like an 'unsigned long bitmask[64]' bitmap
> array with one bitmap for each gpio line to struct gpio_desc and use
> this primarily by gpio-generic.c, populated in bgpio_init? Is gpio_desc
> now available outside of gpiolib.c in some repository/branch that I
> might be unaware of?

Ah, I realize that it is the "gpiolib: remove gpio_desc[] static array" 
patch series you refer to, not yet pushed to gpio/next at 
git://git.secretlab.ca/git/linux-2.6.

The question on how you intend the bitmap field to be 
defined/used/populated remains.

Cheers,
Andreas

