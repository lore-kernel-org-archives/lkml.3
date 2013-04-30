Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758927Ab3D3AVW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 20:21:22 -0400
Received: from mail-da0-f43.google.com ([209.85.210.43]:60016 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758347Ab3D3AVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 20:21:20 -0400
Date: Mon, 29 Apr 2013 17:21:17 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Simon Kirby <sim@hostway.ca>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [ 02/42] TTY: do not update atime/mtime on read/write
Message-ID: <20130430002117.GA4202@kroah.com>
References: <20130429184752.435249613@linuxfoundation.org>
 <20130429184752.700428715@linuxfoundation.org>
 <20130430001445.GA17260@hostway.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130430001445.GA17260@hostway.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29, 2013 at 05:14:45PM -0700, Simon Kirby wrote:
> On Mon, Apr 29, 2013 at 12:01:44PM -0700, Greg Kroah-Hartman wrote:
> 
> > 3.8-stable review patch.  If anyone has any objections, please let me know.
> 
> I object. This breaks functionality I use every day (seeing who else is
> working on stuff with "w").
> 
> Furthermore, the patch does not actually fix the hole referenced (see
> ptmx-keystroke-latency.c on http://vladz.devzero.fr/013_ptmx-timing.php).
> I can still reproduce the timing capture even with this patch applied
> (in 3.9-rc8).

How?  There are no keystrokes being reported to other users, or did we
miss something with this patch?

> The grsec patch instead introdues another test within the inotify code
> (is_sidechannel_device()-related bits) -- untested by me, but probably
> more relevant.
> 
> Even 37b7f3c76595e23257f61bd80b223de8658617ee, the "regression fix",
> which Linus merged in for the 3.9 release, is still a regression for me.

And I applied that one as well.

> 60 seconds means somebody is asleep in my environment, and so is still
> the kind of thing that just pisses me off. I'd rather revert this whole
> thing.

Users taking a break for longer than a minute upset you?  What are you
really trying to keep track of here?

> I'd stand maybe 1 seconds as maximum granularity. You could do that with
> less code and no test.

Patch to show this?

thanks,

greg k-h
