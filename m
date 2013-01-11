Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174Ab3AKQFb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 11:05:31 -0500
Received: from mail.kernel.org ([198.145.19.201]:52870 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755055Ab3AKQFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 11:05:25 -0500
Date: Fri, 11 Jan 2013 08:05:14 -0800
From: Greg KH <greg@kroah.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Brian King <brking@linux.vnet.ibm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wen Xiong <wenxiong@linux.vnet.ibm.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the scsi tree
Message-ID: <20130111160514.GA10823@kroah.com>
References: <20130111120323.cdc06081d0fb1c498c9f1779@canb.auug.org.au>
 <1357889656.3065.2.camel@dabdike.int.hansenpartnership.com>
 <50F02F4E.4070804@linux.vnet.ibm.com>
 <1357918637.3065.22.camel@dabdike.int.hansenpartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357918637.3065.22.camel@dabdike.int.hansenpartnership.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2013 at 03:37:17PM +0000, James Bottomley wrote:
> On Fri, 2013-01-11 at 09:27 -0600, Brian King wrote:
> > It looks like this was a due to the fact that the new patches
> > added __devinit tags in the same merge window the __devinit tag
> > itself was getting removed.
> 
> Not exactly.  The patch which makes them nops went into 3.8.  Now
> there's a patch queued in, Gregs tree I presume, to remove them all and
> the #defines which causes the compile failure.
> 
> > As to the sparse warnings, this patch fixed the ones that
> > were actual bugs in the new code, although we could have
> > made that more clear in the patch description.
> > 
> > http://marc.info/?l=linux-scsi&m=135716576204083&w=2
> 
> Ah, thanks ... I've been on holiday for a while, so I did miss that.
> 
> > There is one outstanding issue I am aware of which was an
> > array bounds compiler warning which looks to be a misdetection
> > by the compiler. Wendy and I discussed adding a BUG_ON
> > to stop the compiler from complaining.
> > 
> > Wendy - lets queue these two changes up ASAP. They should both
> > be very simple changes.
> 
> If it's a simple gcc bug, just ignore it.
> 
> I do need you to redo the patches to remove the __dev annotations,
> though.  We can't risk introducing a bisect killing compile breakage if
> Greg's tree merges before mine in the next merge window.

This change should be pushed to Linus in time for 3.8-final, so there
should not be any bisect issues.

thanks,

greg k-h
