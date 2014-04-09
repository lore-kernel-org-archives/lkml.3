Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934025AbaDIXI3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 19:08:29 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:52991 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933177AbaDIXI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 19:08:27 -0400
Message-ID: <1397084904.9519.62.camel@dabdike>
Subject: Re: hpsa driver bug crack kernel down!
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Baoquan He <bhe@redhat.com>, linux-kernel@vger.kernel.org,
        scameron@beardog.cce.hp.com, linux-scsi <linux-scsi@vger.kernel.org>
Date: Wed, 09 Apr 2014 16:08:24 -0700
In-Reply-To: <1397083799.2608.20.camel@buesod1.americas.hpqcorp.net>
References: <20140409023935.GE11839@dhcp-16-105.nay.redhat.com>
	 <1397083799.2608.20.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.10.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+linux-scsi]
On Wed, 2014-04-09 at 15:49 -0700, Davidlohr Bueso wrote:
> On Wed, 2014-04-09 at 10:39 +0800, Baoquan He wrote:
> > Hi,
> > 
> > The kernel is 3.14.0+ which is pulled just now. 
> 
> Cc'ing more people.
> 
> While the hpsa driver appears to be involved in some way, I'm sure if
> this is a related issue, but as of today's pull I'm getting another
> problem that causes my DL980 not to come up.
> 
> *Massive* amounts of:
> 
> DMAR:[fault reason 02] Present bit in context entry is clear
> dmar: DRHD: handling fault status reg 602
> dmar: DMAR:[DMA Read] Request device [02:00.0] fault addr 7f61e000
> 
> Then:
> 
> hpsa 0000:03:00.0: Controller lockup detected: 0xffff0000
> ...
> Workqueue: events hpsa_monitor_ctlr_worker [hpsa]
> ...
> 
> Screenshot of the actual LOCKUP: 
> http://stgolabs.net/hpsa-hard-lockup-3.14+.png
> 
> While I haven't bisected, things worked fine until at least until commit
> 39de65aa2c3e (April 2nd).
> 
> Any ideas?

Well, it's either a DMA remapping issue or a hpsa one.  Your assertion
that everything worked fine until 39de65aa2c3e would tend to vindicate
hpsa, because all the hpsa changes went in before that under

Merge: 3e75c6d b2bff6c
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue Apr 1 18:49:04 2014 -0700

    Merge tag 'scsi-misc' of
git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi

can you revalidate that this commit works OK just to make sure?

James


