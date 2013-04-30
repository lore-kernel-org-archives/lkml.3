Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933980Ab3D3Xuz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 19:50:55 -0400
Received: from peace.netnation.com ([204.174.223.2]:47750 "EHLO
	peace.netnation.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933785Ab3D3Xux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 19:50:53 -0400
Date: Tue, 30 Apr 2013 16:50:53 -0700
From: Simon Kirby <sim@hostway.ca>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [ 02/42] TTY: do not update atime/mtime on read/write
Message-ID: <20130430235053.GF15961@hostway.ca>
References: <20130429184752.435249613@linuxfoundation.org>
 <20130429184752.700428715@linuxfoundation.org>
 <20130430001445.GA17260@hostway.ca>
 <20130430002117.GA4202@kroah.com>
 <20130430003639.GB17260@hostway.ca>
 <20130430013724.GA5358@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130430013724.GA5358@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29, 2013 at 06:37:24PM -0700, Greg Kroah-Hartman wrote:

> On Mon, Apr 29, 2013 at 05:36:40PM -0700, Simon Kirby wrote:
> > On Mon, Apr 29, 2013 at 05:21:17PM -0700, Greg Kroah-Hartman wrote:
> > 
> > > On Mon, Apr 29, 2013 at 05:14:45PM -0700, Simon Kirby wrote:
> > > > On Mon, Apr 29, 2013 at 12:01:44PM -0700, Greg Kroah-Hartman wrote:
> > > > 
> > > > > 3.8-stable review patch.  If anyone has any objections, please let me know.
> > > > 
> > > > I object. This breaks functionality I use every day (seeing who else is
> > > > working on stuff with "w").
> > > > 
> > > > Furthermore, the patch does not actually fix the hole referenced (see
> > > > ptmx-keystroke-latency.c on http://vladz.devzero.fr/013_ptmx-timing.php).
> > > > I can still reproduce the timing capture even with this patch applied
> > > > (in 3.9-rc8).
> > > 
> > > How?  There are no keystrokes being reported to other users, or did we
> > > miss something with this patch?
> > 
> > wget http://vladz.devzero.fr/svn/codes/PoC/ptmx-keystroke-latency.c
> > gcc -O ptmx-keystroke-latency ptmx-keystroke-latency.c
> > ./ptmx-keystroke-latency
> > 
> > Log in to another tty, as another user. See keystroke timing. 3.9-rc8.
> > 
> > Seems like it was missed. Meanwhile, idle times in "w" do not update.
> 
> Ah, it's using inotify on the /dev/ptmx device.  Jiri, your change
> really doesn't affect that at all :(
> 
> Simon, you mention a grsec change somewhere that addresses this issue.
> Any hints on where that would be?

Yes, see Jiri's comments in the original patch (b0de59b5733d):

http://vladz.devzero.fr/013_ptmx-timing.php

The grsec patch is linked from there:

http://grsecurity.net/~spender/sidechannel.diff

Simon-
