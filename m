Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935459Ab3DISnP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 14:43:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41406 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761380Ab3DISnO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 14:43:14 -0400
Date: Tue, 9 Apr 2013 14:42:48 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Mike Snitzer <snitzer@redhat.com>, Milan Broz <gmazyland@gmail.com>,
        dm-devel@redhat.com, Andi Kleen <andi@firstfloor.org>,
        dm-crypt@saout.de, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Christian Schmidt <schmidt@digadd.de>
Subject: Re: dm-crypt parallelization patches
Message-ID: <20130409184248.GO6320@redhat.com>
References: <20130326202837.GA5599@redhat.com>
 <20130328185327.GF14088@htj.dyndns.org>
 <20130328193343.GA15969@redhat.com>
 <20130328194443.GG14088@htj.dyndns.org>
 <20130328203808.GC15969@redhat.com>
 <20130328204522.GA25501@mtj.dyndns.org>
 <Pine.LNX.4.64.1304091242350.10025@file.rdu.redhat.com>
 <20130409175753.GA6186@mtj.dyndns.org>
 <Pine.LNX.4.64.1304091402150.10025@file.rdu.redhat.com>
 <20130409181031.GC6186@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130409181031.GC6186@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 09, 2013 at 11:10:31AM -0700, Tejun Heo wrote:
> Hey,
> 
> On Tue, Apr 09, 2013 at 02:08:06PM -0400, Mikulas Patocka wrote:
> > > Hmmm? Why not just keep the issuing order along with plugging
> > > boundaries?
> > 
> > What do you mean?
> > 
> > I used to have a patch that keeps order of requests as they were 
> > introduced, but sorting the requests according to sector number is a bit 
> > simpler.
> 
> You're still destroying the context information.  Please just keep the
> issuing order along with plugging boundaries.

I guess plugging boundary is more important than issuing order as 
block layer should take care of mering the bio and put in right
order (attempt_plug_merge()).

But to make use of plugging boundary, one would probably still need
submission using single thread.

And if one is using single thread for submission, one will still get
good performance (even if you are not using bio_associate_current()), as
by default all bio will go to submitting thread's context.

Thanks
Vivek
