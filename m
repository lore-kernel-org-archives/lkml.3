Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760966Ab3JPQWj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 12:22:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5981 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932603Ab3JPQWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 12:22:36 -0400
Date: Wed, 16 Oct 2013 12:22:06 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Hong zhi guo <honkiko@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hong Zhiguo <zhiguohong@tencent.com>
Subject: Re: [PATCH v2] blk-throttle: simplify logic by token bucket algorithm
Message-ID: <20131016162205.GF17611@redhat.com>
References: <1381574794-7639-1-git-send-email-zhiguohong@tencent.com>
 <1381741757-20888-1-git-send-email-zhiguohong@tencent.com>
 <20131015173252.GM31215@redhat.com>
 <CAA7+ByWjdYTi5uXT6apLYkON1RnrFEGjHU318OD1VMen2YHKOA@mail.gmail.com>
 <20131016141405.GE17611@redhat.com>
 <20131016155344.GA10012@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131016155344.GA10012@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 11:53:44AM -0400, Tejun Heo wrote:
> Hello,
> 
> On Wed, Oct 16, 2013 at 10:14:06AM -0400, Vivek Goyal wrote:
> > - First of all, if you think that a group is entitiled for tokens even
> >   when it is not doing IO, then why are you truncating the tokens after
> >   dispatch of a BIO.
> > 
> > - Second in general it does not seem right that a group is entitiled to
> >   tokens even when no IO is happening or group is not backlogged. That
> >   would mean a group will not do IO for 10 hours and then be entitiled
> >   to those tokens suddenly after 10 hours with a huge burst.
> > 
> > So I think you also agree that a group should not be entitiled to
> > tokens when group is not backlogged and that's why you seem to be
> > truncating extra tokens after dispatch of a BIO. If that's the case,
> > then even for first BIO, ideally a group should not be given tokens
> > for idle time.
> 
> Without going into details, having token reserve is an important part
> of token based implementation.  The large the reserve could be
> debatable but that's what provides "smoothing" of allocation.  e.g. if
> you trim bucket as soon as the queue becomes empty, a queue with
> sequential access pattern can easily get disadvantaged.  Another way
> to look at it is to consider as though the IO has been issued some
> time before than actual and waited for the token - it is the same to
> external observers.
> 
> So, while how large the reserve should be is definitely debatable,
> bucket scheduling *needs* idle reserve.

Hi Tejun,

Agreed. We need some kind of smoothing and allow burst up to a limit. I
am only questioning *unlimited* tokens for the first bio in a group which
has been idle for a long time.

Thanks
Vivek
