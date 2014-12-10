Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790AbaLJNOf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 08:14:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36703 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751189AbaLJNOd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 08:14:33 -0500
Date: Wed, 10 Dec 2014 13:13:25 +0000
From: Joe Thornber <thornber@redhat.com>
To: Akira Hayakawa <ruby.wktk@gmail.com>
Cc: ejt@redhat.com, dm-devel@redhat.com, gregkh@linuxfoundation.org,
        snitzer@redhat.com, agk@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] [PATCH] staging: writeboost: Add dm-writeboost
Message-ID: <20141210131325.GD21108@debian>
Mail-Followup-To: Akira Hayakawa <ruby.wktk@gmail.com>, ejt@redhat.com,
	dm-devel@redhat.com, gregkh@linuxfoundation.org, snitzer@redhat.com,
	agk@redhat.com, linux-kernel@vger.kernel.org
References: <5484498E.4000202@gmail.com>
 <20141207200834.GA2322@kroah.com>
 <5484C0E9.3060707@gmail.com>
 <20141209151253.GA17660@debian>
 <20141210100033.GA21108@debian>
 <548827BD.3050803@gmail.com>
 <20141210123349.GC21108@debian>
 <548843A0.6040906@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <548843A0.6040906@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 09:59:12PM +0900, Akira Hayakawa wrote:
> Joe,
> 
> I appreciate your continuous work.
> 
> Is that read or write?
> The difference between Type 0 and 1 should only show up in write path.
> So is it write test?

Yes, writing across the whole device using 'dd'.

These are the tests:

  dmtest list --suite writeboost -n /wipe_device/

> And what is the unit of each result?

seconds.

> 
> > So maybe it's just volume of IO that's causing the problem?  What's
> > the difference between Type 0 and Type 1?  In the code I notice you
> > have 'rambuf' structures, are you caching IO in memory?
> "rambuf" is a temporary space that every write data comes in.
> 127*4KB data are once stored there and 4KB metadata section are added
> then it becomes a log and flushed to the cache device sequentially (512KB each).

So you copy the bio payload to a different block of ram and then
complete the bio?  Or does the rambuf refer to the bio payload
directly?

> By the way,
> I think more clearer discussion can be done if tests are done on physical machines
> to isolate things relevant to VM. I will also add these tests to dmts later and
> run on my machine.
> But, it will be much better if we have good server with RAID-ed backing store
> and the newest SSD (How would it be if it's PCI-e SSD)... 

I generally find it quicker to investigate problems on the machine
that are actually exhibiting the problem ;) Seriously though, you're
asking us to send this upstream; it needs to work on consumer level
hardware.

I've got a big machine with Fusion IO storage that I can run the same
tests on later.

- Joe
