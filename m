Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347Ab3ILNY6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 09:24:58 -0400
Received: from tartarus.angband.pl ([89.206.35.136]:38912 "EHLO
	tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025Ab3ILNY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 09:24:56 -0400
Date: Thu, 12 Sep 2013 15:24:54 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vt: properly ignore xterm-256 colour codes
Message-ID: <20130912132454.GA22329@angband.pl>
References: <E1VImxG-0002w1-UA@tartarus.angband.pl>
 <CANq1E4Tv0Vb9KzWK0oa3P+-V66LqF312HZrwq_JLmHhH-v2k=Q@mail.gmail.com>
 <20130909164623.GA12525@angband.pl>
 <CANq1E4QG9ab8DpicdLt_gk95WSO5GbgF_sSrTjf--_Mt3++HtA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANq1E4QG9ab8DpicdLt_gk95WSO5GbgF_sSrTjf--_Mt3++HtA@mail.gmail.com>
X-Junkbait: adolf@angband.pl, zareba@angband.pl
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: kilobyte@tartarus.angband.pl
X-SA-Exim-Scanned: No (on tartarus.angband.pl); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 02:37:26PM +0200, David Herrmann wrote: 
> On Mon, Sep 9, 2013 at 6:46 PM, Adam Borowski <kilobyte@angband.pl> wrote:
> > On Mon, Sep 09, 2013 at 05:53:19PM +0200, David Herrmann wrote:
> > [...]
> >> Btw., you should put Greg Kroah-Hartman and Andrew Morton on CC. Both
> >> are the most likely to pick this up.
> >
> > Thanks for the suggestion.  I've sent the patch two days ago to Jiri Slaby
> > (listed as a maintainer besides Greg) together with a newbie question, but
> > he's apparently busy.
> 
> Jiri Slaby maintains the TTY subsystem (together with Greg). This does
> not include the VT layer, though. drivers/tty/vt/ and
> drivers/video/console/ are unmaintained. You need to get the attention
> of any maintainer who is willing to take it through their tree (hint:
> most maintainers don't dare touching the VT layer. Greg and Andrew
> were brave enough in the past.).
> 
> I'm willing to review your patches

Thanks.  So I shouldn't bother anyone else for now to get My First Kernel
Patch(tm) into 3.12 (or, if it's too late, into something included in 3.13),
right?

> > I've got more changes for the vt, but there's no hurry, I wanted to test
> > the waters with a single minor one in 3.12 first.

> drivers/tty/vt/ and drivers/video/console/ are unmaintained.

> [...] but history taught me touching the VT layer is a waste of time.

Could you tell me why?  The console is an important tool when something
fails.  Of course, fancy schmancy stuff like combining characters, etc,
could be better done in that legendary userspace alternate console layer,
but the built-in VT must remain at least functional.  And getting corrupted
text is not nice; the VT has fallen woefully behind what works on any other
modern terminal.

Back by ~2000, I'd say it worked better than rxvt, xterm, or, Cthulhu help
us, Solaris' terminal.  It just needs some maintenance.

I had a bunch of other improvements planned; if you say that's a waste of
time perhaps I should scale that back.  But I'd still want to at least
make sure programs that don't use terminfo (terminfo is a bad joke) won't
spew ANSI codes to the screen; at least more popular ones like "set window
title", etc.

You might know of other clean-up and fixes that need to be done here,
though.


-- 
ᛊᚨᚾᛁᛏᚣ᛫ᛁᛊ᛫ᚠᛟᚱ᛫ᚦᛖ᛫ᚹᛖᚨᚲ
