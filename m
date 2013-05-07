Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758067Ab3EGSgn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 14:36:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3325 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751602Ab3EGSgl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 14:36:41 -0400
Date: Tue, 7 May 2013 14:00:09 -0400
From: Dave Jones <davej@redhat.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: 3.9+ tty lockdep trace.
Message-ID: <20130507180009.GA16771@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Peter Hurley <peter@hurleysoftware.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Jiri Slaby <jslaby@suse.cz>
References: <20130501154723.GB11841@redhat.com>
 <20130506180020.GB1309@redhat.com>
 <20130506184059.GA22897@kroah.com>
 <51890C31.3000203@hurleysoftware.com>
 <20130507150423.GA13062@redhat.com>
 <51893B68.1010907@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51893B68.1010907@hurleysoftware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 07, 2013 at 01:35:36PM -0400, Peter Hurley wrote:
 > On 05/07/2013 11:04 AM, Dave Jones wrote:
 > > On Tue, May 07, 2013 at 10:14:09AM -0400, Peter Hurley wrote:
 > >
 > >   > >> Just hit this again, by switching tty's during bootup.
 > >   > >> The previous time was switching from X to console iirc, so that seems to be
 > >   > >> the key to triggering this.
 > >   > >
 > >   > > Sorry for not getting back to this sooner, merge window fun...
 > >   > >
 > >   > > Anyway, Peter, could this be something that your ldisc patches are
 > >   > > triggering?
 > >   >
 > >   > Yes, although early analysis also suggests the lockdep splat is possible
 > >   > regardless, just much less likely.
 > >   >
 > >   > I looked at this over the weekend, but I wasn't able to determine (in
 > >   > the limited time I had available) if the splat was valid; ie., if the
 > >   > cpu states could actually be concurrent and result in deadlock.
 > >   >
 > >   > I need to study the VT_DISALLOCATE ioctl in more detail which I plan
 > >   > to do this week.
 > >
 > > I don't know if it proves/disproves anything, but shortly before the dump
 > > gets printed, everything is kind of locked up. I can switch tty's, but
 > > the gettys on them are dead to the world until after the dump.
 > >
 > > ISTR a pause for a while when I hit this switching from X too.
 > 
 > It would help to know the steps to reproduce. For example, you mention
 > unresponsive gettys but the VT_DISALLOCATE ioctl doesn't work (and isn't
 > designed to) on open ttys.

Hmm, dunno. I booted up, and tried to log in on tty1 (no X on that box), and after
I entered my password everything just hung for a while. I flipped to tty2
to try and log in as root, but after changing tty, I just got a blinking cursor.
10 seconds or so later, lockdep spew.

	Dave

