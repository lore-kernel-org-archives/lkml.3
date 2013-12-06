Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297Ab3LFIvt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 03:51:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59716 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756745Ab3LFIvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 03:51:45 -0500
Date: Fri, 6 Dec 2013 09:51:37 +0100
From: Mateusz Guzik <mguzik@redhat.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, Eryu Guan <eguan@redhat.com>,
        Jeff Moyer <jmoyer@redhat.com>, Kent Overstreet <kmo@daterainc.com>,
        linux-aio@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.10] aio: restore locking of ioctx list on removal
Message-ID: <20131206085136.GA24844@mguzik.redhat.com>
References: <1386238142-21792-1-git-send-email-mguzik@redhat.com>
 <20131206010347.GA25404@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131206010347.GA25404@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 05, 2013 at 05:03:47PM -0800, Greg KH wrote:
> On Thu, Dec 05, 2013 at 11:09:02AM +0100, Mateusz Guzik wrote:
> > Commit 36f5588905c10a8c4568a210d601fe8c3c27e0f0
> > "aio: refcounting cleanup" resulted in ioctx_lock not being held
> > during ctx removal, leaving the list susceptible to corruptions.
> > 
> > In mainline kernel the issue went away as a side effect of
> > db446a08c23d5475e6b08c87acca79ebb20f283c "aio: convert the ioctx list to
> > table lookup v3".
> > 
> > Fix the problem by restoring appropriate locking.
> 
> Why can't I just take db446a08c23d5475e6b08c87acca79ebb20f283c instead?
> Does it not work well enough, or is there other issues involved in it
> that would keep it out of stable?
> 
> Also, it seems like the performance increase of that patch would be good
> to have backported, right?
> 

Sorry, should have noted this in my original message:
db446a08c23d5475e6b08c87acca79ebb20f283c is not trivial and applying it
results in some conflicts, in addition to that the patch itself had bugs
which were fixed in:
da90382c2ec367aac88ff6aa76afb659ee0e4235
f30d704fe1244c44a984d3d1f47bc648bcc6c9f7
77d30b14d24e557f89c41980011d72428514d729
d9b2c8714aef102dea95544a8cd9372b21af463f

It may be that the most convienent way to deal with this backport would
be to just sync the file with mainline.

As such, I think backporting is too risky at this stage.

Additionally my understanding of Documentation/stable_kernel_rules.txt
was that somewhat simpler patches are preferred.

So in the end I decided to fix the problem just by adding locking.

Unfortunately at this time I can't volunteer to do the work if
backporting is preferred.

-- 
Mateusz Guzik
