Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935094Ab3DISKi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 14:10:38 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:65449 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934469Ab3DISKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 14:10:36 -0400
Date: Tue, 9 Apr 2013 11:10:31 -0700
From: Tejun Heo <tj@kernel.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Vivek Goyal <vgoyal@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, Milan Broz <gmazyland@gmail.com>,
        dm-devel@redhat.com, Andi Kleen <andi@firstfloor.org>,
        dm-crypt@saout.de, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Christian Schmidt <schmidt@digadd.de>
Subject: Re: dm-crypt parallelization patches
Message-ID: <20130409181031.GC6186@mtj.dyndns.org>
References: <5151FF82.6090405@gmail.com>
 <20130326202837.GA5599@redhat.com>
 <20130328185327.GF14088@htj.dyndns.org>
 <20130328193343.GA15969@redhat.com>
 <20130328194443.GG14088@htj.dyndns.org>
 <20130328203808.GC15969@redhat.com>
 <20130328204522.GA25501@mtj.dyndns.org>
 <Pine.LNX.4.64.1304091242350.10025@file.rdu.redhat.com>
 <20130409175753.GA6186@mtj.dyndns.org>
 <Pine.LNX.4.64.1304091402150.10025@file.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1304091402150.10025@file.rdu.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Tue, Apr 09, 2013 at 02:08:06PM -0400, Mikulas Patocka wrote:
> > Hmmm? Why not just keep the issuing order along with plugging
> > boundaries?
> 
> What do you mean?
> 
> I used to have a patch that keeps order of requests as they were 
> introduced, but sorting the requests according to sector number is a bit 
> simpler.

You're still destroying the context information.  Please just keep the
issuing order along with plugging boundaries.

> > As I wrote before, please use bio_associate_current().  Currently,
> > dm-crypt is completely messing up all the context information that cfq
> > depends on to schedule IOs.  Of course, it doesn't perform well.
> 
> bio_associate_current() is only valid on a system with cgroups and there 
> are no cgroups on the kernel where I tested it. It is an empty function:
> 
> static inline int bio_associate_current(struct bio *bio) { return -ENOENT; }

Yeah, because blkcg was the only user.  Please feel free to drop the
ifdefs.  It covers both iocontext and cgroup association.

Thanks.

-- 
tejun
