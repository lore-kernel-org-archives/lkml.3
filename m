Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198AbaDEXYS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2014 19:24:18 -0400
Received: from imap.thunk.org ([74.207.234.97]:50522 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753565AbaDEXYL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2014 19:24:11 -0400
Date: Sat, 5 Apr 2014 19:23:42 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: John Stoffel <john@stoffel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>, Joerg Roedel <joro@8bytes.org>,
        Jiri Kosina <jkosina@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mateusz Guzik <mguzik@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Kay Sievers <kay@vrfy.org>
Subject: Re: [RFC PATCH] cmdline: Hide "debug" from /proc/cmdline
Message-ID: <20140405232342.GA6805@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	John Stoffel <john@stoffel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Joerg Roedel <joro@8bytes.org>, Jiri Kosina <jkosina@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mateusz Guzik <mguzik@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	"H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@kernel.org>, Mel Gorman <mgorman@suse.de>,
	Kay Sievers <kay@vrfy.org>
References: <CA+55aFw7NyryF3F3x05rLjt6rFwD5xUoZB06CV2mpwwRxcVHxg@mail.gmail.com>
 <alpine.LNX.2.00.1404030145490.32122@pobox.suse.cz>
 <CA+55aFzo85-sdC_eDVRWcCdsK2p1JxCjswYidq-QSi5RieGmBA@mail.gmail.com>
 <CA+55aFyphF8kd4OwWdar4p5M1=Sxc54sfk0RWFPpO6zrezZwJA@mail.gmail.com>
 <20140403104308.GP13491@8bytes.org>
 <20140403170541.GA19010@thunk.org>
 <533EF832.1030902@mit.edu>
 <CA+55aFxC_+zCD8BQ637WJLf2VXWjhJOQB7uUkVARneSKsQ2+Hg@mail.gmail.com>
 <21311.8533.138063.744673@quad.stoffel.home>
 <20140404231749.GA20437@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140404231749.GA20437@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2014 at 04:17:49PM -0700, Greg Kroah-Hartman wrote:
> > I think you mean "dmesg -T", and unfortunately it seems Debian 6.0.9
> > (or older) doesn ship a new enough linux-util since I've only got
> > 2.17.2-9 install.  
> 
> No, 'dmesg -H' is the right thing, you just need a modern version of
> util-linux :)

I've been poking the Debian folks.  Hopefully they'll be able to ship
a newer util-linux soon.  Unfortunately, the previous package
maintainer had something like a thousand local patches, and it's not
clear which patches got pushed upstream, which have been resolved some
other way, which are now moot, and which might result in an actual
regression if Debian were to go to the latest version of util-linux.

Most Debian packages are better maintained; hopefully this issue will
be resolved soon.  I believe the right way at this point is to declare
"patch bankruptcy", ala "inbox bankruptcy", and then fix up the bugs
as users report them.  And I think the new maintainer believes that
too; he just has to convince a few other people of that.

Anyway, that's largely out of scope for LKML, except that many us
kernel developers who use Debian have been rather handicapped by this.
(I keep a set of binaries of the latest util-linux when I need modern
functionality.)

     	     	    	       	   	 - Ted
