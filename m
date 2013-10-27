Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317Ab3J0JUZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 05:20:25 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:57415 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331Ab3J0JUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 05:20:24 -0400
X-Originating-IP: 77.221.165.98
Date: Sun, 27 Oct 2013 09:20:20 +0000
From: Josh Triplett <josh@joshtriplett.org>
To: Thomas Rast <tr@thomasrast.ch>
Cc: Michael Haggerty <mhagger@alum.mit.edu>, git@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>, Greg KH <greg@kroah.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        ksummit-attendees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] commit: Add -f, --fixes <commit> option to add Fixes:
 line
Message-ID: <20131027092019.GB13149@leaf>
References: <20131024122255.GI9378@mwanda>
 <20131024122512.GB9534@mwanda>
 <20131026181709.GB10488@kroah.com>
 <20131027013402.GA7146@leaf>
 <526CA7D4.1070904@alum.mit.edu>
 <20131027071407.GA11683@leaf>
 <874n83m8xv.fsf@linux-k42r.v.cablecom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874n83m8xv.fsf@linux-k42r.v.cablecom.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 27, 2013 at 09:09:32AM +0100, Thomas Rast wrote:
> Josh Triplett <josh@joshtriplett.org> writes:
> 
> > On Sun, Oct 27, 2013 at 06:42:44AM +0100, Michael Haggerty wrote:
> >> But I don't think that this feature should be given the "-f" short
> >> option, as (a) -f often means "force"; (b) it will increase the
> >> confusion with --fixup; (c) it just doesn't strike me as being likely to
> >> be such a frequently-used option (though if this changes over time the
> >> "-f" option could always be granted to it later).
> >
> > (a) -n often means --dry-run, but for commit it means --no-verify.
> > Different commands have different options, and commit doesn't have a
> > --force to abbreviate as -f.
> >
> > (b) If anything, I think the existence of a short option will make the
> > distinction more obvious, since -f and --fixup are much less similar
> > than --fixes and --fixup.  Most users will never type --fixes, making
> > confusion unlikely.
> >
> > (c) Short option letters tend to be first-come first-serve unless
> > there's a strong reason to do otherwise.  Why reserve 'f' for some
> > hypothetical future option that doesn't exist yet?
> 
> No, lately the direction in Git has been to avoid giving options a
> one-letter shorthand until they have proven so useful that people using
> it in the wild start to suggest that it should have one.
> 
> See e.g.
> 
>   http://article.gmane.org/gmane.comp.version-control.git/233998
>   http://article.gmane.org/gmane.comp.version-control.git/168748

Fair enough; easy enough to drop -f if that's the consensus.  However...

> A much better argument would be if it was already clear from the specs
> laid out for Fixes that n% of the kernel commits will end up having this
> footer, and thus kernel hackers will spend x amount of time spelling out
> --fixes and/or confusing it with --fixup to much headache.

...good suggestion:

~/src/linux$ git log --grep='stable@' --oneline --since='1 year ago' | wc -l
2769
~/src/linux$ git log --grep='stable@' --oneline --since='1 year ago' --pretty=format:%an | sort -u | wc -l
839

Several thousand commits per year by hundreds of unique people seems
like enough to justify a short option.

- Josh Triplett
