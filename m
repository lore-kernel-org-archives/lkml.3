Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248Ab3IMK6j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 06:58:39 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:35070 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513Ab3IMK6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 06:58:37 -0400
MIME-Version: 1.0
In-Reply-To: <20130912132454.GA22329@angband.pl>
References: <E1VImxG-0002w1-UA@tartarus.angband.pl>
	<CANq1E4Tv0Vb9KzWK0oa3P+-V66LqF312HZrwq_JLmHhH-v2k=Q@mail.gmail.com>
	<20130909164623.GA12525@angband.pl>
	<CANq1E4QG9ab8DpicdLt_gk95WSO5GbgF_sSrTjf--_Mt3++HtA@mail.gmail.com>
	<20130912132454.GA22329@angband.pl>
Date: Fri, 13 Sep 2013 12:58:36 +0200
Message-ID: <CANq1E4TFkTjy2rSuHxeAkw87y2nrhQAQDOfiYi7ZtunnMKDKoA@mail.gmail.com>
Subject: Re: [PATCH] vt: properly ignore xterm-256 colour codes
From: David Herrmann <dh.herrmann@gmail.com>
To: Adam Borowski <kilobyte@angband.pl>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Thu, Sep 12, 2013 at 3:24 PM, Adam Borowski <kilobyte@angband.pl> wrote:
> On Thu, Sep 12, 2013 at 02:37:26PM +0200, David Herrmann wrote:
>> On Mon, Sep 9, 2013 at 6:46 PM, Adam Borowski <kilobyte@angband.pl> wrote:
>> > On Mon, Sep 09, 2013 at 05:53:19PM +0200, David Herrmann wrote:
>> > [...]
>> >> Btw., you should put Greg Kroah-Hartman and Andrew Morton on CC. Both
>> >> are the most likely to pick this up.
>> >
>> > Thanks for the suggestion.  I've sent the patch two days ago to Jiri Slaby
>> > (listed as a maintainer besides Greg) together with a newbie question, but
>> > he's apparently busy.
>>
>> Jiri Slaby maintains the TTY subsystem (together with Greg). This does
>> not include the VT layer, though. drivers/tty/vt/ and
>> drivers/video/console/ are unmaintained. You need to get the attention
>> of any maintainer who is willing to take it through their tree (hint:
>> most maintainers don't dare touching the VT layer. Greg and Andrew
>> were brave enough in the past.).
>>
>> I'm willing to review your patches
>
> Thanks.  So I shouldn't bother anyone else for now to get My First Kernel
> Patch(tm) into 3.12 (or, if it's too late, into something included in 3.13),
> right?

Too late for 3.12. We want such stuff in linux-next before it is
merged. So yeah, 3.13 should be your aim.

>> > I've got more changes for the vt, but there's no hurry, I wanted to test
>> > the waters with a single minor one in 3.12 first.
>
>> drivers/tty/vt/ and drivers/video/console/ are unmaintained.
>
>> [...] but history taught me touching the VT layer is a waste of time.
>
> Could you tell me why?

Because few people care (did anyone but me respond to this?).
Furthermore, most people just want it to "not break", they often don't
care for improvements.

> The console is an important tool when something
> fails.

That's true for any recovery tool.

> Of course, fancy schmancy stuff like combining characters, etc,
> could be better done in that legendary userspace alternate console layer,
> but the built-in VT must remain at least functional. And getting corrupted
> text is not nice; the VT has fallen woefully behind what works on any other
> modern terminal.
>
> Back by ~2000, I'd say it worked better than rxvt, xterm, or, Cthulhu help
> us, Solaris' terminal.  It just needs some maintenance.

Yes, the linux-console used to be something people were proud of. But
there ought to be a reason why it has fallen behind. You might wanna
figure that out before spending time fixing the symptom.

> I had a bunch of other improvements planned; if you say that's a waste of
> time perhaps I should scale that back.  But I'd still want to at least
> make sure programs that don't use terminfo (terminfo is a bad joke) won't
> spew ANSI codes to the screen; at least more popular ones like "set window
> title", etc.
>
> You might know of other clean-up and fixes that need to be done here,
> though.

I'm not saying that I dislike the effort. Please go ahead. But you
might want to have a look at "git log drivers/tty/vt/vt.c". There
hasn't been any serious VT changes since 2010. Neither for
drivers/char/vt.c which it was back then. I think this effort is
better spent on user-space consoles, but I might be biased.

Regards
David
