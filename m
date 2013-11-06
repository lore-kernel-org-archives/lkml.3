Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172Ab3KFUt6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 15:49:58 -0500
Received: from dkim1.fusionio.com ([66.114.96.53]:41600 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755702Ab3KFUt4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 15:49:56 -0500
X-ASG-Debug-ID: 1383770995-0421b57ae590a70001-xx1T2L
X-Barracuda-Envelope-From: clmason@fusionio.com
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Mike Snitzer <snitzer@redhat.com>
From: Chris Mason <chris.mason@fusionio.com>
In-Reply-To: <20131106203639.GB2049@redhat.com>
CC: Kent Overstreet <kmo@daterainc.com>, <axboe@kernel.dk>,
        <linux-kernel@vger.kernel.org>, NeilBrown <neilb@suse.de>,
        Olof Johansson <olof@lixom.net>
References: <1383709721-22809-1-git-send-email-kmo@daterainc.com>
 <20131106161130.3802.97153@localhost.localdomain> <20131106200222.GA3842@kmo>
 <20131106202236.3802.2079@localhost.localdomain>
 <20131106203639.GB2049@redhat.com>
Message-ID: <20131106204952.3802.28112@localhost.localdomain>
User-Agent: alot/0.3.4
Subject: Re: block: Revert bio_clone() default behaviour
Date: Wed, 6 Nov 2013 15:49:52 -0500
X-ASG-Orig-Subj: Re: block: Revert bio_clone() default behaviour
X-Originating-IP: [10.101.1.160]
X-Barracuda-Connect: cas1.int.fusionio.com[10.101.1.40]
X-Barracuda-Start-Time: 1383770995
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.142112
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Mike Snitzer (2013-11-06 15:36:40)
> On Wed, Nov 06 2013 at  3:22pm -0500,
> Chris Mason <chris.mason@fusionio.com> wrote:
> 
> > Quoting Kent Overstreet (2013-11-06 15:02:22)
> > > On Wed, Nov 06, 2013 at 11:11:30AM -0500, Chris Mason wrote:
> > > > 
> > > > I think the concept of bio ownership is still much too weak, at least
> > > > for established users like MD and DM.  I don't know how to verify the
> > > > sharing of bi_io_vec without some kind of reference counting on the
> > > > iovec.
> > > 
> > > What's unclear about it? The rule is just - if you didn't allocate the biovec,
> > > don't modify it or use bio_for_each_segment_all() (probably I didn't quite state
> > > it clearly enough before though)
> > 
> > That part makes sense.  The new rule that scares me is that we can't
> > free the src of the clone until all the clones are freed.  If it works
> > with today's existing users it feels like it is more by accident than
> > design.  I'm not saying we can't do it, we just need some bigger
> > flashing warning lights.
> 
> But we probably don't want those warning lights to come with the cost of
> managing extra refcounts in the fast path -- so maybe a debug-only
> refcount?

I'd be happy with some code comments and a few extra SOBs.  In general
I'm happy with the new patches that add _fast and make us explicitly
choose the sharing.  Lots of little chances for bugs, but opt-in is a
much better starting point.

-chris
