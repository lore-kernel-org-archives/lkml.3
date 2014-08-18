Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256AbaHRKcE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 06:32:04 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:26140 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbaHRKcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 06:32:00 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-31-53f1d61bf9d2
Message-id: <53F1D615.8070707@samsung.com>
Date: Mon, 18 Aug 2014 12:31:49 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Mark Brown <broonie@kernel.org>
Cc: Mike Turquette <mturquette@linaro.org>, devicetree@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-spi@vger.kernel.org,
        wsa@the-dreams.de, linux-arm-kernel@lists.infradead.org,
        pawel.moll@arm.com, mark.rutland@arm.com, galak@codeaurora.org,
        gregkh@linuxfoundation.org, kyungmin.park@samsung.com,
        m.szyprowski@samsung.com, t.figa@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC V8 1/1] clk: Support for clock parents and rates
 assigned from device tree
References: <1403105372-30403-1-git-send-email-s.nawrocki@samsung.com>
 <1403105372-30403-2-git-send-email-s.nawrocki@samsung.com>
 <53B59221.5080100@samsung.com> <20140725214231.5177.86866@quantum>
 <20140813203406.GU17528@sirena.org.uk>
In-reply-to: <20140813203406.GU17528@sirena.org.uk>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJLMWRmVeSWpSXmKPExsVy+t/xK7rS1z4GG9xfw2wx9eETNov5R86x
	WvS/Wchq0bx4PZvF2aY37BabHl9jtej4+4XR4vKuOWwWjR9vslusPXKX3WLp9YtMFk8nXGSz
	mDB9LYvF+hmvWSxWnpjF7MDvsWbeGkaPy329TB6bVnWyedy5tofNY//cNewem5fUe/RtWcXo
	cfLUExaPz5vkAjijuGxSUnMyy1KL9O0SuDLWdp9hLvgqXfHp+Vb2BsZmsS5GTg4JAROJCesu
	MkPYYhIX7q1n62Lk4hASWMoo8WBbByOE84lR4tyEAyxdjBwcvAJaEj1X80AaWARUJf5taQBr
	ZhMwlOg92scIYosKREgc6HvGCmLzCghK/Jh8jwXEFhFQlrj6fS8LyExmgSZmia2PJ7OBJIQF
	UiSur3nBCrHsI6PE/YdT2ECWcQoYS3Sc9QCpYRbQkdjfOo0NwpaX2LzmLfMERoFZSHbMQlI2
	C0nZAkbmVYyiqaXJBcVJ6bmGesWJucWleel6yfm5mxgh0fVlB+PiY1aHGAU4GJV4eB2OfgwW
	Yk0sK67MPcQowcGsJMKbfR4oxJuSWFmVWpQfX1Sak1p8iJGJg1OqgdHN/qvYlNgLnLMvqV8R
	O3Q57Mf35A7vh7oWR7c1PfYoLXJgOdxwemXL8x9CAl1Rbzp+PONY89jmqGiR3bGyiNzOr5vE
	nXqOvPaY6Sb14USqbmeu5Z3oP1bW+jqb/vHp6Zf2S8h7XbCff1nP8s6VdQ9NuNh2RklwTnqg
	+yyuLFKypYGjaBm7hhJLcUaioRZzUXEiABR6PLiMAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/08/14 22:34, Mark Brown wrote:
> On Fri, Jul 25, 2014 at 02:42:31PM -0700, Mike Turquette wrote:
>> Quoting Sylwester Nawrocki (2014-07-03 10:25:53)
> 
>>> I would appreciate a DT, SPI or the I2C maintainer opinions.
> 
>> Yes, Acks from SPI and I2C maintainers would be good. I might need to
>> drop those parts of this patch if they don't come through :-(
> 
> So, I just noticed this.  The reason I didn't see this earlier is that
> it was buried at the end of a large clock API patch rather than a split
> out patch for the SPI subsystem so it fell towards the bottom of
> my review queue.  There seems to be no dependency on adding the feature
> as part of one commit so it should really have been split out.
> 
> Please don't assume that people are going to look in detail at patches
> that aren't obviously for them - I know I end up ignoring a lot of what
> I get sent since I get CCed on a lot of random things for no apparent
> reason (or get tediously large numbers of resends of things that are
> tangentially related), I imagine others do the same.  If you're doing
> that please draw attention to it, splitting out per subsystem is the
> best way of doing that.

OK, will try to remember and improve things in future.

> This is particularly unfortunate since I am actually a bit confused as
> to why we need to open code this for every bus rather than doing it in
> the driver core, there doesn't seem to be anything at all bus specific
> going on here.  Why can't we just call this from the driver core?

I had it done in the driver core in first versions of this patch, but
then I learnt it is not something Greg would be fond of, so I went for
this method. In fact, clocks configuration is not something which
applies to each and every device, thus putting it in the bus code might
not be that bad after all.

> Having the feature work for some buses and not others is going to get
> old fast.
> 
> It's also not clear to me why we're passing false to of_clk_set_defaults()
> when we do call it - it's quite common for I2C and SPI devices to be
> clock providers and have clock trees.  As far as I can tell the
> reasoning is that what's actually going on here is that this is actually
> a mechanism to defer the initialisation to adding of the clock providers
> in which case contrary to the documentation for the function it's
> actually about device registration.  Is that right?

The flag is there to tell if clocks supplied by a particular device should
also be configured. The function is being called with the flag set right
after a clock provider registration in the clock core, this is where the
take care of things when an (I2C, SPI, etc.) device is a clock provider.
Obviously attempting to configure clocks which were not yet registered
before a device's driver probe() call would fail. The flag is there to
defer configuration of clocks after they are actually registered with
the clk core, not only parsable from the device tree.

Documentation of the function might be indeed a bit confusing :/
I'll consider changing the sentence:

"The @clk_supplier argument
 should be set to true if @node may be also a clock supplier of any clock
 listed in its 'assigned-clocks' or 'assigned-clock-parents' properties."

to

 "The @clk_supplier argument
  should be set to true if @node is or may be a clock supplier of any
  clock listed in its 'assigned-clocks' or 'assigned-clock-parents'
  properties and such clocks are also to be configured."

--
Regards,
Sylwester
