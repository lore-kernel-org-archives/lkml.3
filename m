Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757088AbaGNUpd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 16:45:33 -0400
Received: from canardo.mork.no ([148.122.252.1]:53485 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755638AbaGNUpa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 16:45:30 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Hans de Goede <hdegoede@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [BISECTED 3.16-rc REGREGRESSION] backlight control stopped working
Organization: m
References: <87pph8kse7.fsf@nemi.mork.no> <53C3D7C3.7090505@redhat.com>
	<CA+55aFxYYKApOC+1TQkoxSzi-zTSB8OmkU=ypvNb_Gc2+K6Hmw@mail.gmail.com>
	<CA+55aFzHo4BEO8W0yza7g0YMgg-b=hPbk20-vpR3s==ydpmAOg@mail.gmail.com>
Date: Mon, 14 Jul 2014 22:45:07 +0200
In-Reply-To: <CA+55aFzHo4BEO8W0yza7g0YMgg-b=hPbk20-vpR3s==ydpmAOg@mail.gmail.com>
	(Linus Torvalds's message of "Mon, 14 Jul 2014 09:59:51 -0700")
Message-ID: <877g3fsm98.fsf@nemi.mork.no>
User-Agent: Gnus/5.130011 (Ma Gnus v0.11) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:
> On Mon, Jul 14, 2014 at 9:24 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> Bjørn, what's your setup? Is this perhaps solvable some other way?

Just to answer that: I don't use any particular desktop environment.  I
have acpid running to take care of the most basic power management
stuff.  My X session is simply WindowMaker (sic) running directly from
lightdm.  No session management or fancy policy daemons. So I don't have
any daemon which would react on the brightness key codes.

Now, it's not that I would mind adding a daemon to handle stuff like
brightness control. I reported this as a bug because I was a bit
surprised by the existing behaviour breaking like that, and I thought
that other users might be as surprised as me.  Some maybe even without
the ability to track down the change and the setting that would restore
the old behaviour.

> For example, I wonder if we could fix the "dual brightness change"
> problem automatically by making a new option for
> 'brightness_switch_enabled'.
>
> Currently, there are two cases:
>
>  - enabled: do the actual brightness change _and_ send the input
> report keycode for a brightness change
>
>  - disabled: just send the keycode, excpecting the desktop software to
> handle it.
>
> and maybe we could have a new case (and make *that* the default):
>
>  - delayed: send the keycode, and set up a delayed timer (say, one
> tenth of a second) to do the actual brightness change. And if a
> brightness change from user mode comes in during that delay, we cancel
> the kernel-induced pending change.

That sounds like a good solution to me FWIW.



Bjørn
