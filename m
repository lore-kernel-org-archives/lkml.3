Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517AbaHVGIP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 02:08:15 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:41120 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbaHVGIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 02:08:14 -0400
X-Original-SENDERIP: 10.177.222.156
X-Original-MAILFROM: minchan@kernel.org
Date: Fri, 22 Aug 2014 15:08:51 +0900
From: Minchan Kim <minchan@kernel.org>
To: Chao Yu <chao2.yu@samsung.com>
Cc: "'Sergey Senozhatsky'" <sergey.senozhatsky@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, ngupta@vflare.org,
        "'Jerome Marchand'" <jmarchan@redhat.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>
Subject: Re: [PATCH] zram: add num_discards for discarded pages stat
Message-ID: <20140822060851.GH17372@bbox>
References: <001201cfb838$fb0ac4a0$f1204de0$@samsung.com>
 <20140815061138.GA940@swordfish>
 <002d01cfbb70$ea7410c0$bf5c3240$@samsung.com>
 <20140819112500.GA2484@swordfish>
 <20140820020924.GD32620@bbox>
 <006701cfbc4f$c9d2fe00$5d78fa00$@samsung.com>
 <20140821011854.GE17372@bbox>
 <001601cfbd1f$b9f068d0$2dd13a70$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <001601cfbd1f$b9f068d0$2dd13a70$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Chao,

On Thu, Aug 21, 2014 at 05:09:19PM +0800, Chao Yu wrote:
> Hi Minchan,
> 
> > -----Original Message-----
> > From: Minchan Kim [mailto:minchan@kernel.org]
> > Sent: Thursday, August 21, 2014 9:19 AM
> > To: Chao Yu
> > Cc: 'Sergey Senozhatsky'; linux-kernel@vger.kernel.org; linux-mm@kvack.org; ngupta@vflare.org;
> > 'Jerome Marchand'; 'Andrew Morton'
> > Subject: Re: [PATCH] zram: add num_discards for discarded pages stat
> > 
> > Hi Chao,
> > 
> > On Wed, Aug 20, 2014 at 04:20:48PM +0800, Chao Yu wrote:
> > > Hi Minchan,
> > >
> > > > -----Original Message-----
> > > > From: Minchan Kim [mailto:minchan@kernel.org]
> > > > Sent: Wednesday, August 20, 2014 10:09 AM
> > > > To: Sergey Senozhatsky
> > > > Cc: Chao Yu; linux-kernel@vger.kernel.org; linux-mm@kvack.org; ngupta@vflare.org; 'Jerome
> > > > Marchand'; 'Andrew Morton'
> > > > Subject: Re: [PATCH] zram: add num_discards for discarded pages stat
> > > >
> > > > Hi Sergey,
> > > >
> > > > On Tue, Aug 19, 2014 at 08:25:00PM +0900, Sergey Senozhatsky wrote:
> > > > > Hello,
> > > > >
> > > > > On (08/19/14 13:45), Chao Yu wrote:
> > > > > > > On (08/15/14 11:27), Chao Yu wrote:
> > > > > > > > Now we have supported handling discard request which is sended by filesystem,
> > > > > > > > but no interface could be used to show information of discard.
> > > > > > > > This patch adds num_discards to stat discarded pages, then export it to sysfs
> > > > > > > > for displaying.
> > > > > > > >
> > > > > > >
> > > > > > > a side question: we account discarded pages via slot free notify in
> > > > > > > notify_free and via req_discard in num_discards. how about accounting
> > > > > > > both of them in num_discards? because, after all, they account a number
> > > > > > > of discarded pages (zram_free_page()). or there any particular reason we
> > > > > > > want to distinguish.
> > > > > >
> > > > > > Yeah, I agree with you as I have no such reason unless there are our users'
> > > > > > explicitly requirement for showing notify_free/num_discards separately later.
> > > > > >
> > > > > > How do you think of sending another patch to merge these two counts?
> > > > > >
> > > > >
> > > > > Minchan, what do you think? let's account discarded pages in one place.
> > > >
> > > > First of all, I'd like to know why we need num_discards.
> > > > It should be in description and depends on it whether we should merge both
> > > > counts or separate.
> > >
> > > Oh, it's my mistaken.
> > >
> > > When commit 	9b9913d80b2896ecd9e0a1a8f167ccad66fac79c (Staging: zram: Update
> > > zram documentation) and commit e98419c23b1a189c932775f7833e94cb5230a16b (Staging:
> > > zram: Document sysfs entries) description related to 'discard' stat was designed
> > > and added to zram.txt and sysfs-block-zram, but without implementation of function
> > > for handling discard request, description in documents were removed in commit
> > > 8dd1d3247e6c00b50ef83934ea8b22a1590015de (zram: document failed_reads,
> > > failed_writes stats)
> > 
> > Thanks for letting me know the history.
> > 
> > >
> > > For now, we have already supported discard handling, so it's better to resume
> > > the stat of discard number, this discard stat supports user one more kind of runtime
> > > information of zram as other stats supported.
> > >
> > > How do you think?
> > 
> > I'm not strong against the idea but just "resume is better" and
> > "one more is problem as other stats supported" is not logical
> > to me.
> 
> OK, I assume maybe to match the principle for adopting and discarding
> those stats in original version of zram will do some help, actually I'm wrong.
> 
> > 
> > You should explain why we need such new stat so that user can take
> > what kinds of benefit from that. Otherwise, we couldn't know the stat
> > is best or not for the goal.
> 
> Alright, it's reasonable from this perspective.
> 
> > 
> > 
> > I might be paranoid about small stuff and I admit I'm not good for it,
> > too but pz, understand that adding the new feature requires a
> > good description which should include clear goal.
> 
> Well, I can understand and accept that.
> 
> > 
> > I hope I'm not discouraging. :)
> 
> Nope, please let me try again, :)
> 
> Since we have supported handling discard request in this commit
> f4659d8e620d08bd1a84a8aec5d2f5294a242764 (zram: support REQ_DISCARD), zram got
> one more chance to free unused memory whenever received discard request. But
> without stating for discard request, there is no method for user to know whether
> discard request has been handled by zram or how many blocks were discarded by
> zram when user wants to know the effect of discard.
> 
> In this patch, we add num_discards to stat discarded pages, and export it to
> sysfs for users.

Yeb, Thanks!

>-- 
Kind regards,
Minchan Kim
