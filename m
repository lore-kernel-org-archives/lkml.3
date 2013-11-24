Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318Ab3KXAWk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 19:22:40 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46104 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755972Ab3KXAWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 19:22:38 -0500
Date: Sun, 24 Nov 2013 01:22:36 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Ric Wheeler <ricwheeler@gmail.com>
Cc: Howard Chu <hyc@symas.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Chinmay V S <cvs268@gmail.com>,
        Stefan Priebe - Profihost AG <s.priebe@profihost.ag>,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
        matthew@wil.cx
Subject: Re: Why is O_DSYNC on linux so slow / what's wrong with my SSD?
Message-ID: <20131124002236.GA10600@amd.pavel.ucw.cz>
References: <528CA73B.9070604@profihost.ag>
 <20131120125446.GA6284@infradead.org>
 <CAK-9PRAManphkxT3ub0DfW8hx=xbq+ZeqUB0E0CEnFTfF7AQuw@mail.gmail.com>
 <528CC36A.7080003@profihost.ag>
 <CAK-9PRDyGhXPef-Vbt83Os-oowFZ2HzSZVY9PH3rSdnTwNmf2w@mail.gmail.com>
 <20131120153703.GA23160@thunk.org>
 <528CDD19.5060002@symas.com>
 <20131123203600.GA791@amd.pavel.ucw.cz>
 <529133CC.4070904@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <529133CC.4070904@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2013-11-23 18:01:32, Ric Wheeler wrote:
> On 11/23/2013 03:36 PM, Pavel Machek wrote:
> >On Wed 2013-11-20 08:02:33, Howard Chu wrote:
> >>Theodore Ts'o wrote:
> >>>Historically, Intel has been really good about avoiding this, but
> >>>since they've moved to using 3rd party flash controllers, I now advise
> >>>everyone who plans to use any flash storage, regardless of the
> >>>manufacturer, to do their own explicit power fail testing (hitting the
> >>>reset button is not good enough, you need to kick the power plug out
> >>>of the wall, or better yet, use a network controlled power switch you
> >>>so you can repeat the power fail test dozens or hundreds of times for
> >>>your qualification run) before being using flash storage in a mission
> >>>critical situation where you care about data integrity after a power
> >>>fail event.
> >>Speaking of which, what would you use to automate this sort of test?
> >>I'm thinking an SSD connected by eSATA, with an external power
> >>supply, and the host running inside a VM. Drop power to the drive at
> >>the same time as doing a kill -9 on the VM, then you can resume the
> >>VM pretty quickly instead of waiting for a full reboot sequence.
> >I was just pulling power on sata drive.
> >
> >It uncovered "interesting" stuff. I plugged power back, and kernel
> >re-estabilished communication with that drive, but any settings with
> >hdparm were forgotten. I'd say there's some room for improvement
> >there...
> 
> Hi Pavel,
> 
> When you drop power, your drive normally loses temporary settings
> (like a change to write cache, etc).
> 
> Depending on the class of the device, there are ways to make that
> permanent (look at hdparm or sdparm for details).
> 
> This is a feature of the drive and its firmware, not something we
> reset in the device each time it re-appears.

Yes, and I'm arguing that is a bug (as in, < 0.01% people are using
hdparm correctly).

So you used hparm to disable write cache so that ext3 can be safely
used on your hdd. Now you have glitch on power. Then, system continues
to operate in dangerous mode until reboot.

I guess it would be safer not to reattach drives after power
fail... (also I wonder what this does to data integrity. Drive lost
content of its writeback cache, but kernel continues... Journal will
not prevent data corruption in this case).

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
