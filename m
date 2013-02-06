Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077Ab3BFTpU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 14:45:20 -0500
Received: from science.horizon.com ([71.41.210.146]:11022 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755031Ab3BFTpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 14:45:15 -0500
Date: 6 Feb 2013 14:45:14 -0500
Message-ID: <20130206194514.16104.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, peter@hurleysoftware.com
Subject: Re: 3.8-rc regression with pps-ldisc due to 70ece7a731
Cc: jslaby@suse.cz, linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
In-Reply-To: <1360166020.3298.42.camel@thor.lan>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Tight coupling is what caused this to break in the first place -- I
> don't think tighter coupling is the right answer.

Agreed.  But given that n_tty already knows there are wrappers, it would
have been possible to find a cleaner way to access an "aux pointer" in
the tty structure, if that's what was desired.

> You are not supposed to receive ldisc->dcd_change() calls outside
> the open()/close() pair.

Yes, I figured that out.  I was wondering because I couldn't see any
way that the serial interrupt hander was blocked or masked, but
then I figured out that it's not, but instead the TTY_LDISC flag
is used.

At the time the open() method is called, the flag is cleared, which makes
tty_ldisc_ref() return NULL, which prevents calling the ldisc methods.

> In the patch series I sent, I changed the BUG_ON() to WARN_ON_ONCE().
> Please reply to that patch with the snipped kernel log output if it
> warns in your testing and we'll go from there.

I really doubt it will.  The entire code change and comment was
just caution on my part.

>> (Have I mentioned how ANNOYING it is when the kernel dumps more than
>> 50 lines of crash message to the console screen and then locks
>> the keyboard so I can't scroll back?)

> netconsole on 2nd machine (see Documentation/networking/netconsole.txt)

Oh, that survives interrupt crashes?  Thank you!
