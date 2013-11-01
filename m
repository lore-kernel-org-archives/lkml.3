Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199Ab3KARqr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 13:46:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35671 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752002Ab3KARqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 13:46:46 -0400
Date: Fri, 1 Nov 2013 13:46:15 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, Kent Overstreet <kmo@daterainc.com>,
        linux-kernel@vger.kernel.org
Subject: Re: stec skd block driver needs updating for immutable biovec
Message-ID: <20131101174615.GC23501@redhat.com>
References: <20131101135931.GA22903@redhat.com>
 <5273C2B8.5030608@kernel.dk>
 <20131101154338.GA23501@redhat.com>
 <20131101155027.GA5665@infradead.org>
 <5273D0B1.2030006@kernel.dk>
 <20131101162823.GB23501@redhat.com>
 <5273D80F.5070205@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5273D80F.5070205@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 01 2013 at 12:34pm -0400,
Jens Axboe <axboe@kernel.dk> wrote:

> On 11/01/2013 10:28 AM, Mike Snitzer wrote:
> > On Fri, Nov 01 2013 at 12:02pm -0400,
> > Jens Axboe <axboe@kernel.dk> wrote:
> > 
> >> On 11/01/2013 09:50 AM, Christoph Hellwig wrote:
> >>> On Fri, Nov 01, 2013 at 11:43:39AM -0400, Mike Snitzer wrote:
> >>>> All the bi_sector ones are low hanging fruit, but the conversion for
> >>>> skd_preop_sg_list_bio()'s bio_vec code is more involved.
> >>>>
> >>>> Kent, any chance you could crank through it?
> >>>>
> >>>> If not I can come back to trying to fix this later.. but I'm working
> >>>> through a test merge of linux-dm.git's 'for-next' with linux-block.git's
> >>>> 'for-next'.
> >>>
> >>> The right thing for 3.13 is to rip out the bio base code path, and
> >>> for 3.14 to convert it to blk-mq.
> >>
> >> It is. I will kill it.
> > 
> > I just cranked through it.. hope this helps (think I got everything but
> > may have missed something):
> 
> You lost out, I committed it 20 min ago :-0

Cool, it's OK, I was still able to get the fulfilling experience of
killing a bunch of code... made my day.
