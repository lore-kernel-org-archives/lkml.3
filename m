Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760434Ab3LIKt3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 05:49:29 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34699 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006Ab3LIKt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 05:49:27 -0500
Date: Mon, 9 Dec 2013 10:49:22 +0000
From: Luis Henriques <luis.henriques@canonical.com>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Mateusz Guzik <mguzik@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eryu Guan <eguan@redhat.com>,
        Jeff Moyer <jmoyer@redhat.com>, Kent Overstreet <kmo@daterainc.com>,
        linux-aio@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.10] aio: restore locking of ioctx list on removal
Message-ID: <20131209104922.GC4278@hercules>
References: <1386238142-21792-1-git-send-email-mguzik@redhat.com>
 <20131206010347.GA25404@kroah.com>
 <20131206085136.GA24844@mguzik.redhat.com>
 <20131206145343.GC13581@kvack.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131206145343.GC13581@kvack.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 06, 2013 at 09:53:43AM -0500, Benjamin LaHaise wrote:
> Hi Greg, Mateusz,
> 
> On Fri, Dec 06, 2013 at 09:51:37AM +0100, Mateusz Guzik wrote:
> > On Thu, Dec 05, 2013 at 05:03:47PM -0800, Greg KH wrote:
> > > On Thu, Dec 05, 2013 at 11:09:02AM +0100, Mateusz Guzik wrote:
> > > > Commit 36f5588905c10a8c4568a210d601fe8c3c27e0f0
> > > > "aio: refcounting cleanup" resulted in ioctx_lock not being held
> > > > during ctx removal, leaving the list susceptible to corruptions.
> > > > 
> > > > In mainline kernel the issue went away as a side effect of
> > > > db446a08c23d5475e6b08c87acca79ebb20f283c "aio: convert the ioctx list to
> > > > table lookup v3".
> > > > 
> > > > Fix the problem by restoring appropriate locking.
> > > 
> > > Why can't I just take db446a08c23d5475e6b08c87acca79ebb20f283c instead?
> > > Does it not work well enough, or is there other issues involved in it
> > > that would keep it out of stable?
> > > 
> > > Also, it seems like the performance increase of that patch would be good
> > > to have backported, right?
> > > 
> > 
> > Sorry, should have noted this in my original message:
> > db446a08c23d5475e6b08c87acca79ebb20f283c is not trivial and applying it
> > results in some conflicts, in addition to that the patch itself had bugs
> > which were fixed in:
> > da90382c2ec367aac88ff6aa76afb659ee0e4235
> > f30d704fe1244c44a984d3d1f47bc648bcc6c9f7
> > 77d30b14d24e557f89c41980011d72428514d729
> > d9b2c8714aef102dea95544a8cd9372b21af463f
> > 
> > It may be that the most convienent way to deal with this backport would
> > be to just sync the file with mainline.
> > 
> > As such, I think backporting is too risky at this stage.
> 
> Mateusz's analysis is correct.  Backporting db446a08c23d5475e6b08c87acca79ebb20f283c
> would essentially mean redoing the entire patch and would end up being a  
> bunch more untested code.  Please take Mateusz's patch which fixes the bug 
> within a narrow scope.  It is applicable to 3.10 and 3.11.  For 3.12 the 
> issue is fixed by other changes.  Feel free to add my Acked-by.
> 
>                 -ben

Thank you, I'm queuing it for the 3.11 kernel as well.

Cheers,
--
Luis


>
> 
> > Additionally my understanding of Documentation/stable_kernel_rules.txt
> > was that somewhat simpler patches are preferred.
> > 
> > So in the end I decided to fix the problem just by adding locking.
> > 
> > Unfortunately at this time I can't volunteer to do the work if
> > backporting is preferred.
> > 
> > -- 
> > Mateusz Guzik
> > 
> > --
> > To unsubscribe, send a message with 'unsubscribe linux-aio' in
> > the body to majordomo@kvack.org.  For more info on Linux AIO,
> > see: http://www.kvack.org/aio/
> > Don't email: <a href=mailto:"aart@kvack.org">aart@kvack.org</a>
> 
> -- 
> "Thought is the essence of where you are now."
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
