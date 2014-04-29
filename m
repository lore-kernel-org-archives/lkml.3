Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757934AbaD2PlE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 11:41:04 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:59867 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbaD2PlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 11:41:02 -0400
MIME-Version: 1.0
In-Reply-To: <20140429151433.GD26756@n2100.arm.linux.org.uk>
References: <1398644860-22973-1-git-send-email-mporter@linaro.org>
 <20140428142950.GB30292@saruman.home> <20140428143709.GC7719@beef>
 <20140428145223.GL26756@n2100.arm.linux.org.uk> <CAGsJ_4x1+eePRDMP0-0WeTG6ZJdzmMkN_9USbKt8joY8AKsDdw@mail.gmail.com>
 <20140429151433.GD26756@n2100.arm.linux.org.uk>
From: Barry Song <baohua@kernel.org>
Date: Tue, 29 Apr 2014 23:40:33 +0800
X-Google-Sender-Auth: GSfTgfJMiQNKhCAk5hKtDlsobuQ
Message-ID: <CAGsJ_4yg2Dcwyj5cLc2DuYVOcWwmpkPzK_=BUZLqRLDyErBL=Q@mail.gmail.com>
Subject: Re: [PATCH] ARM: l2c: prima2: only call l2x0_of_init() on matching nodes
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Kevin Hilman <khilman@linaro.org>, Felipe Balbi <balbi@ti.com>,
        Matt Porter <mporter@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-04-29 23:14 GMT+08:00 Russell King - ARM Linux <linux@arm.linux.org.uk>:
> On Tue, Apr 29, 2014 at 11:05:06PM +0800, Barry Song wrote:
>> 2014-04-28 22:52 GMT+08:00 Russell King - ARM Linux <linux@arm.linux.org.uk>:
>> > On Mon, Apr 28, 2014 at 10:37:09AM -0400, Matt Porter wrote:
>> >> The "fix" is tested against bcm281xx and bcm21664 as that is what the
>> >> l2c cleanup breaks in -next. As mentioned, I don't have the sirfsoc h/w
>> >> so this first attempt at a fix also breaks their platform. It can be
>> >> addressed by adding those platform specific compatibles back to the dts,
>> >> of course.
>> >>
>> >> I'd much prefer that the sirfsoc folks fix this...it's going to break
>> >> other platforms in a multi v7 build.
>> >
>> > Well, it's about time we got rid of this from platform specific code
>> > anyway, taking it away from platform maintainers to mess around with.
>> > So that's what I'm doing.
>> >
>> > It's worth noting that if you build a single zImage with exynos also
>> > enabled, then you also end up with an unconditional call from that
>> > code to l2x0_of_init() with it's own magic numbers - and that applies
>> > before my changes.
>> >
>> > So let's fix this properly and yank this crap from platform maintainers
>> > fingers.
>>
>> i mentioned dropping specific dts compatible prop will break non-csr
>> platforms in the mail thread "ARM: prima2: remove L2 cache size
>> override" and i said i was going to send v2. you said you need it
>> before rc6. now it has been sent, but i am sorry it is not against
>> next-20140424.
>
> FFS.  IT HASN'T BEEN SENT.  All that I did was drop it into linux-next
> so that more people would get off their fat backsides and test this
> fscking patch set - something which hasn't happened because no one
> pays attention to emails sent to mailing lists.

so your point is people don't pay attention to your mails? or you are
ignored? i think that is 100% not real. i think your opinions and
mails are always respected as you are the chief arm linux expert.

>
> I also told you that this was what I was going to do.  But... is it
> really on to hold up such a large patch set which impacts virtually
> everyone because _you_ don't have time to sort out your small special
> requirements - no it is not, that's just fscking selfish.
>
> Anyway, I've had it with dealing with platform maintainers, I've yanked
> this patch set, and I'm no longer planning to do anything with it -
> platform maintainers have destroyed my will to get any of this series
> into the kernel.

no, i am trying to follow your suggestion to make patch set merged and
l2 codes cleaned.
i have been trying to follow your will until now, and from the beginning.

>
> So, the L2 cache code is going to remain in its current state, and it's
> going to rot because it's _FAR_ too much effort dealing with slow people
> like yourselves, or people who want the series split up, or people who
> whinge that there aren't any acks there (WELL GET OFF YOUR FAT BACKSIDES
> AND SEND ME SOME IF YOU CARE ABOUT THIS - no, don't, I'm no longer pushing
> this series.)

people might be "selfish", but people might have some reasons to
response slowly, like holiday or family issue.
how about taking it easy? it doesn't prove you are not respected by
platform maintainers.

>
> This is the last time I'm going to ever try cleaning up any core ARM code.
> Core ARM maintanence is impossible in this environment with arm-soc split
> from core ARM stuff, because core ARM stuff /always/ impacts on SoC
> specific code.  You can't get away from that.
>
> My position in this community has been made impossible and obsolete by
> Linaro.  I'm at the point of walking away from this crap.

just fix the relationship and communication, that is good enough. you
have done things so well, there is no reason to give up.

>
> --
> FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
> improving, and getting towards what was expected from it.

-barry
