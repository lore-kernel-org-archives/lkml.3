Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932398AbaGUNGe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 09:06:34 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39046 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754690AbaGUNGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 09:06:31 -0400
Date: Mon, 21 Jul 2014 15:06:29 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Joerg Roedel <joro@8bytes.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6 v2] PM / Hibernate: Memory bitmap scalability
 improvements
Message-ID: <20140721130629.GA15122@amd.pavel.ucw.cz>
References: <1405938422-21900-1-git-send-email-joro@8bytes.org>
 <20140721120053.GA14069@amd.pavel.ucw.cz>
 <20140721123613.GL30979@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140721123613.GL30979@8bytes.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > The last patch adds touching the soft lockup watchdog in
> > > rtree_next_node. This is necessary because the worst case
> > > performance (all bits set in the forbidden_pages_map and
> > > free_pages_map) is the same as with the old implementation
> > > and may still cause soft lockups. Patch 6 avoids this.
> > 
> > Ok, so what about simpler patch? Just touch the watchdog?
> 
> That would just cover the problem that the bitmap data structure and the
> algorithm in swsusp_free do not scale well on bigmem machines.

And is it a problem? Hibernation of 12TB machine will take 6 hours if
you back your swap with SSDs.

Does not scale == burns additional 60 seconds of CPU time. I think we
can live with that...

...because noone sane will hibernate 12TB machine.

> > Additional 70 seconds will be lost in noise if you write 12TB of RAM
> > to (even quite fast) disk.
> 
> Sure, but you would still get the soft lockup warnings when swsusp_free
> runs in the end.

Yes, that's why I propose to apply just patch 6 -- to avoid soft
lockup warnings.

Best regards,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
