Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193Ab3KFUhq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 15:37:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53698 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755472Ab3KFUhp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 15:37:45 -0500
Date: Wed, 6 Nov 2013 15:36:40 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Chris Mason <chris.mason@fusionio.com>
Cc: Kent Overstreet <kmo@daterainc.com>, axboe@kernel.dk,
        linux-kernel@vger.kernel.org, NeilBrown <neilb@suse.de>,
        Olof Johansson <olof@lixom.net>
Subject: Re: block: Revert bio_clone() default behaviour
Message-ID: <20131106203639.GB2049@redhat.com>
References: <1383709721-22809-1-git-send-email-kmo@daterainc.com>
 <20131106161130.3802.97153@localhost.localdomain>
 <20131106200222.GA3842@kmo>
 <20131106202236.3802.2079@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131106202236.3802.2079@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 06 2013 at  3:22pm -0500,
Chris Mason <chris.mason@fusionio.com> wrote:

> Quoting Kent Overstreet (2013-11-06 15:02:22)
> > On Wed, Nov 06, 2013 at 11:11:30AM -0500, Chris Mason wrote:
> > > 
> > > I think the concept of bio ownership is still much too weak, at least
> > > for established users like MD and DM.  I don't know how to verify the
> > > sharing of bi_io_vec without some kind of reference counting on the
> > > iovec.
> > 
> > What's unclear about it? The rule is just - if you didn't allocate the biovec,
> > don't modify it or use bio_for_each_segment_all() (probably I didn't quite state
> > it clearly enough before though)
> 
> That part makes sense.  The new rule that scares me is that we can't
> free the src of the clone until all the clones are freed.  If it works
> with today's existing users it feels like it is more by accident than
> design.  I'm not saying we can't do it, we just need some bigger
> flashing warning lights.

But we probably don't want those warning lights to come with the cost of
managing extra refcounts in the fast path -- so maybe a debug-only
refcount?

Mike
