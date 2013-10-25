Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646Ab3JYNnz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 09:43:55 -0400
Received: from mail-qe0-f53.google.com ([209.85.128.53]:39518 "EHLO
	mail-qe0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478Ab3JYNnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 09:43:53 -0400
MIME-Version: 1.0
X-Originating-IP: [77.221.165.98]
In-Reply-To: <20131025133512.GA1551@ulmo.nvidia.com>
References: <1382632289-18523-1-git-send-email-treding@nvidia.com>
	<5269FB5E.6010901@roeck-us.net>
	<20131025083525.GF19622@ulmo.nvidia.com>
	<CAOesGMg+Xi3+MZrPbRiMGFe2cQFjN9qaif9u5gW_tDzK62EB7w@mail.gmail.com>
	<20131025133512.GA1551@ulmo.nvidia.com>
Date: Fri, 25 Oct 2013 06:43:53 -0700
Message-ID: <CAOesGMh=VLEuFgZuwrJnPsbxnr1Y528CVUdq313Ey5SVUb-jsw@mail.gmail.com>
Subject: Re: linux-next: Tree for Oct 24
From: Olof Johansson <olof@lixom.net>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Guenter Roeck <linux@roeck-us.net>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 25, 2013 at 6:35 AM, Thierry Reding
<thierry.reding@gmail.com> wrote:
> On Fri, Oct 25, 2013 at 06:16:02AM -0700, Olof Johansson wrote:
>> On Fri, Oct 25, 2013 at 1:35 AM, Thierry Reding
>> <thierry.reding@gmail.com> wrote:
>> > On Thu, Oct 24, 2013 at 10:02:22PM -0700, Guenter Roeck wrote:
>> >> On 10/24/2013 09:31 AM, Thierry Reding wrote:
>> >> >Hi all,
>> >> >
>> >> >I've uploaded today's linux-next tree to the master branch of the
>> >> >repository below:
>> >> >
>> >> >         git://gitorious.org/thierryreding/linux-next.git
>> >> >
>> >> >A next-20131024 tag is also provided for convenience.
>> >> >
>> >> >Quite a few new conflicts. Some of them non-trivial. I've fixed another
>> >> >set of build failures, so 32-bit and 64-bit allmodconfigs build fine on
>> >> >x86. ARM and x86 default configurations also build fine. PowerPC is in
>> >> >pretty bad shape, mostly due to some OF header rework going on.
>> >> >
>> >>
>> >> Hmm ... I see
>> >>
>> >> Building arm:defconfig ... failed
>> >> --------------
>> >> Error log:
>> >> drivers/built-in.o: In function `mmc_gpio_request_cd':
>> >> clkdev.c:(.text+0x74cf8): undefined reference to `devm_gpio_request_one'
>> >> make: *** [vmlinux] Error 1
>> >>
>> >> Otherwise pretty much the same as yesterday, with a build log of
>> >>       total: 110 pass: 88 skipped: 4 fail: 18
>> >>
>> >> This is with "v3.12-rc5-7941-g765f88c".
>> >
>> > Yeah, I saw the devm_gpio_request_one() errors too. They happened for 3
>> > boards on ARM I think. Must have forgotten to update the summary email.
>> > I'll see if I can come up with a patch to fix the GPIO related build
>> > failures, or at least report it to LinusW or Alexandre.
>>
>> Hmm.
>>
>> Please don't apply fixes like these directly to your tree, keep the
>> broken parts (or drop the tree that introduced it). It makes the
>> process of getting the fixes in where they really have to go much more
>> error prone, since there's no way to track whether they have landed in
>> the right place yet or not.
>
> I've found that fixing one build error often subsequent build failures,
> which would go unnoticed if I dropped the trees or let the breakage
> unfixed.

Yeah, that's what happened with the GPIO subsystem on this release --
there are two build errors but your fix resolves one of them such at
the other one is exposed. It makes it confusing to bisect down to root
cause. I'd almost rather have your tree just being broken, but patches
submitted and sent in to the maintainer in question if you want to get
it fixed ASAP.

In particular, the gpio fix in the tree right now has no description, etc.


-Olof
