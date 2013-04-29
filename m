Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760381Ab3D2TPV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 15:15:21 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:33593 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760366Ab3D2TPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 15:15:18 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwU-bXZ7wn2dOcLNfPMcjDv3Jvqx_LTt7B+-tj4WcP8Mg@mail.gmail.com>
References: <20130429162115.GA6893@kroah.com>
	<CA+55aFz7bESS-T2_5vndVEzbk7ocmfEanBO+sviTSNekOLKRcg@mail.gmail.com>
	<20130429183851.GA8106@kroah.com>
	<CA+55aFwU-bXZ7wn2dOcLNfPMcjDv3Jvqx_LTt7B+-tj4WcP8Mg@mail.gmail.com>
Date: Mon, 29 Apr 2013 12:15:17 -0700
X-Google-Sender-Auth: yn68fozofuhLgZVy9ZXdKpdX6oI
Message-ID: <CA+55aFzLtBwsvVrnT2DrUOU+eYrQ5eiKeamRb4Y5+-TVgbuM5Q@mail.gmail.com>
Subject: Re: [GIT PATCH] char/misc patches for 3.10-rc1
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: David Brown <davidb@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nicolas Pitre <nico@fluxnic.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29, 2013 at 11:55 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Mon, Apr 29, 2013 at 11:38 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
>>
>> It's a "bus" type, that has individual drivers connecting to it.
>
> No it isn't, and no it doesn't.

Ok, searching more, I find this discussion on lkml:

Dima Zavin reasonably wrote

 "SSBI is a Qualcomm proprietary protocol that will only ever have one
ssbi "host" driver in it. The slave is always the PMIC .."

arguing that it should stay in arch/arm/mach-msm/ where it got
developed by the Android guys.

The "explanations" for why it should be in drivers/ is this mindless drivel:

On Tue, Feb 22 2011, Daniel Walker wrote:
> On Tue, 2011-02-22 at 12:47 -0800, Dima Zavin wrote:
>
>> What is the problem leaving it under arch/arm/mach-msm?
>
> Because it's a driver.

Seriously. That's the *ONLY* explanation given.

WTF? That's a singularly *bad* reason for moving things to "drivers".
If it's specific to some particular machine board, it should damn well
stay as specific as possible, instead of being moved to "drivers/"
"just because".

This seems to be nothing but a continuation of the same old ARM story:
people were embarrassed by the fact that ARM looked bad in the
diffstats, so they for many moons now have actively tried to spread
out the arm-specific manure in other places. Not because it makes
sense anywhere else, but because it makes ARM look less proprietary,
and less filled with ad-hoc hacks.

I object. If it's a single-platform driver, it shouldn't be in
"drivers". It should be under the one single platform that supports
it. Seriously.

Then, *if* it ever becomes anything more than that, go right ahead and
make it more generic. But don't move it to drivers "just because it's
a driver".

And you seem to have fallen for the lipstick-on-a-pig explanation,
hook line and sinker.

And I'm calling the ARM people out on this idiocy. Arnd and Nico -
stop encouraging this kind of crap. Move things to drivers only once
there is actual reason for it. If it's some proprierary single-SoC
thing, it can damn well stay away from other people. And it definitely
shouldn't mess up autocomplete in some core location.

                   Linus
