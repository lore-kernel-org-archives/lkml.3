Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700Ab3FKMHn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 08:07:43 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:64221 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125Ab3FKMHm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 08:07:42 -0400
MIME-Version: 1.0
In-Reply-To: <20130611100108.GC9216@laptop>
References: <1370266965-7901-1-git-send-email-lee.jones@linaro.org>
	<CAPDyKFrJumd79hHWJkGWvRKzhoaprPHu=U6HOHXzVL8WyNS6jw@mail.gmail.com>
	<20130611100108.GC9216@laptop>
Date: Tue, 11 Jun 2013 14:07:41 +0200
Message-ID: <CAPDyKFoopE9CSnZB3m0rv+YiEesqck_Jmws+Q7T=n9FrK-mYRQ@mail.gmail.com>
Subject: Re: [PATCH 00/21] ARM: ux500: Enable Clock look-up from Device Tree
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11 June 2013 12:01, Lee Jones <lee.jones@linaro.org> wrote:
>> > Nice and simple implementation using standard Clk APIs.
>> Hi Lee,
>>
>> I may be a bit tired, but I am having a bit hard to follow the steps
>> taken in this patch set. :-)
>>
>> I should of course tell you why:
>> 1. You start out by adding DT definitions in the DT files, should that
>> not be done as the final step, after the DT support has been added in
>> ux500 clk driver?
>
> No, let me tell you why. ;)
>
> a) The DT definitions will be going in via a separate tree, so it
> doesn't really matter where they are placed in _this_ patchset. and b)
> they will remain completely dormant until they are backed up with
> driver bindings, so there is no harm in putting them in first.

Okay, was not aware of that those were to be merged on it's own.

>
>> 2. Moreover, I think it would be enough to group the definitions
>> patches into one patch or at least significant fewer. Same feeling
>> about the patches were you remove the AUXDATA, this would simplify the
>> review for me.
>
> It's generally accepted that lots of lines of code split over a
> greater number of patches (so long as they are in consistent groups of
> functionality) are easier to review and thus have a greater chance of
> acceptance. It also makes things like reverting easier and bisecting
> more precise (rather than finding a big patch using bisect, then
> having to complete a manual mini-bisect to find the offending change.
>
> Arnd provides the maths for calculating the ease of upstreaming a
> patch, which he calls 'weight' (NB: this is from memory, it might be a
> little off):
>
> (patch_weight * patch_weight) * patch_count = delta_weight
>
> So if we had a 100 lines split over 2 patches, it would be:
>
> (50 * 50) * 2 = 5000
>
> Whereas if we split those lines over 4 patches we would see:
>
> (25 * 25) * 4 = 1000
>
> Thus, by this convention it would (generally) considered to be twice
> as difficult to upstream - at least that's the theory. There is a more
> extravagant formula for calculating how difficult it would be to
> upstream an entire tree of delta if a) all patches were contained on a
> single branch compared to b) if patches were split into topic branches.
>
> Something like:
>
> ((patch_weight * patch_weight) * patch_count)  *
>  (patch_weight * patch_weight) * patch_count)) *
>   branch_count = delta_weight
>
> So following on from the example above and placing 100 lines over 2
> patches on 1 branch you would get:
>
> (((25 * 25) * 4) * (25 * 25) * 4) * 1 = 6250000
>
> Whereas if you spread the patches over two branches you'd have:
>
> (((25 * 25) * 2) * (25 * 25) * 2) * 2 = 3125000
>
> Obviously the branch number comparison works better with the larger
> numbers you'd expect to find in a typical downstream BSP, but you get
> the idea.
>
> </tangent> ... whoops, sorry! :)

Hehe, I stopped reading long before this line. Go ahead, keep them as
is then! :-)

>
>> 3. The rest will be commented per patch.
>>
>> Kind regards
>> Ulf Hansson
>>
>> >
>> >  arch/arm/boot/dts/dbx5x0.dtsi    |   94 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>> >  arch/arm/boot/dts/snowball.dts   |    3 ++-
>> >  arch/arm/mach-ux500/cpu-db8500.c |   36 +--------------------------
>> >  drivers/clk/ux500/u8500_clk.c    |  154 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>> >  4 files changed, 249 insertions(+), 38 deletions(-)
>> >
>> >
>
> --
> Lee Jones
> Linaro ST-Ericsson Landing Team Lead
> Linaro.org │ Open source software for ARM SoCs
> Follow Linaro: Facebook | Twitter | Blog
