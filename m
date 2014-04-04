Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894AbaDDXP3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 19:15:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44724 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821AbaDDXPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 19:15:25 -0400
Date: Fri, 4 Apr 2014 16:17:49 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: John Stoffel <john@stoffel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>, "Theodore Ts'o" <tytso@mit.edu>,
        Joerg Roedel <joro@8bytes.org>, Jiri Kosina <jkosina@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mateusz Guzik <mguzik@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Kay Sievers <kay@vrfy.org>
Subject: Re: [RFC PATCH] cmdline: Hide "debug" from /proc/cmdline
Message-ID: <20140404231749.GA20437@kroah.com>
References: <20140402162839.d3c00e9845e89d0f092c2ce3@linux-foundation.org>
 <CA+55aFw7NyryF3F3x05rLjt6rFwD5xUoZB06CV2mpwwRxcVHxg@mail.gmail.com>
 <alpine.LNX.2.00.1404030145490.32122@pobox.suse.cz>
 <CA+55aFzo85-sdC_eDVRWcCdsK2p1JxCjswYidq-QSi5RieGmBA@mail.gmail.com>
 <CA+55aFyphF8kd4OwWdar4p5M1=Sxc54sfk0RWFPpO6zrezZwJA@mail.gmail.com>
 <20140403104308.GP13491@8bytes.org>
 <20140403170541.GA19010@thunk.org>
 <533EF832.1030902@mit.edu>
 <CA+55aFxC_+zCD8BQ637WJLf2VXWjhJOQB7uUkVARneSKsQ2+Hg@mail.gmail.com>
 <21311.8533.138063.744673@quad.stoffel.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21311.8533.138063.744673@quad.stoffel.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2014 at 05:17:09PM -0400, John Stoffel wrote:
> >>>>> "Linus" == Linus Torvalds <torvalds@linux-foundation.org> writes:
> 
> Linus> On Fri, Apr 4, 2014 at 11:21 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> >> 
> >> The other thing I've used /dev/kmsg for is to shove a "I'm starting
> >> something now" message in.  This is only really necessary because the
> >> current kernel log timestamps are unusable crap.  (We could fix that,
> >> hint hint.)
> 
> Linus> I'd actually love to fix that, but I disagree with the "we could fix
> Linus> it". There are tons of people who know how to parse them (admittedly
> Linus> often only to ignore them), so changing the format is not likely to
> Linus> work.
> 
> Linus> The good news is that "dmesg -H" does help if you're
> Linus> human. While at the same time being an example of that very
> Linus> "there are tools that know about the current horrid format"
> Linus> issue.. D'oh.
> 
> I think you mean "dmesg -T", and unfortunately it seems Debian 6.0.9
> (or older) doesn ship a new enough linux-util since I've only got
> 2.17.2-9 install.  

No, 'dmesg -H' is the right thing, you just need a modern version of
util-linux :)

> And RHEL/Centos 5.6 and 6.5 don't seem to ship that by default either,
> they have got util-linux-2.13-0.56.el5 and
> util-linux-ng-2.17.2-12.14.el6.x86_64 respectively.  Blech!  It's in
> Linux Mint 16 at least, haven't checked older versions.

util-linux is on version 2.24.1 at the moment:
	https://www.kernel.org/pub/linux/utils/util-linux/v2.24/
2.17.2 was from back in 2012, I think it's time to switch to a modern
distro...

thanks,

greg k-h
