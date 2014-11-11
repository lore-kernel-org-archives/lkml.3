Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487AbaKKWob (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 17:44:31 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:61586 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbaKKWo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 17:44:29 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-4b-5462914b595e
Date: Wed, 12 Nov 2014 07:43:12 +0900
From: Changman Lee <cm224.lee@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [f2fs-dev] [PATCH 1/5] f2fs: disable roll-forward when active_logs
 = 2
Message-id: <20141111224312.GA16657@lcm>
References: <1415518569-20626-1-git-send-email-jaegeuk@kernel.org>
 <20141110095437.GE14659@lcm>
 <20141110150759.GB25172@jaegeuk-mac02.hsd1.ca.comcast.net>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
In-reply-to: <20141110150759.GB25172@jaegeuk-mac02.hsd1.ca.comcast.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupikeLIzCtJLcpLzFFi42I5/e+Zvq73xKQQg8414hZP1s9itri0yN1i
	z96TLBaXd81hc2Dx2LSqk81j94LPTB6fN8kFMEdx2aSk5mSWpRbp2yVwZcx+3MFcMF204u2L
	FSwNjJsFuhg5OSQETCTufFnACmGLSVy4t56ti5GLQ0hgGaPE4ptd7DBFNzb8Y4ZITGeUePrs
	HTuE85NRYkPvBkaQKhYBVYmr638zg9hsAloS7afXsoDYIgIqEocWXQabxCyQKTGh/wWYLSwQ
	KnHo8Q+wXl4BDYnDBxYxgdhCAvMYJe4eDYeIC0r8mHyPBaJXS2L9zuNMELa0xKO/M8DmcAq4
	S7yc0Qo2RxRo15ST28BekBBYxC7x/PwUZojjBCS+TT4ENIgDKCErsekAM8RnkhIHV9xgmcAo
	NgvJullI1s1Csm4BI/MqRtHUguSC4qT0IhO94sTc4tK8dL3k/NxNjJAomrCD8d4B60OMAhyM
	Sjy8Gv6JIUKsiWXFlbmHGE2BrpjILCWanA+M1bySeENjMyMLUxNTYyNzSzMlcd7XUj+DhQTS
	E0tSs1NTC1KL4otKc1KLDzEycXBKNTBK7VNf+OXPRC3VdVevhc58cuKUyqpjdhYRl5sLsoTl
	tY6EnXCq4DvG9eyUVNr9ndV7jzxV56j79GoGt912vYU11XFq/6O8xVjN0x2kZ0x35mhuN3qi
	mTpnwfbn262Xbe2Kt+O48d5aSc36v+LDS6nuthyxXnP0VE9qXOGfLTeRZ8Li4veesiVKLMUZ
	iYZazEXFiQDBL6wMnQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsVy+t9jQV3viUkhBpO2Cls8WT+L2eLSIneL
	PXtPslhc3jWHzYHFY9OqTjaP3Qs+M3l83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5gx+3EHc8F00Yq3L1awNDBuFuhi5OSQEDCRuLHhHzOELSZx4d56ti5GLg4h
	gemMEk+fvWOHcH4ySmzo3cAIUsUioCpxdf1vsA42AS2J9tNrWUBsEQEViUOLLrOD2MwCmRIT
	+l+A2cICoRKHHv8A6+UV0JA4fGARE4gtJDCPUeLu0XCIuKDEj8n3WCB6tSTW7zzOBGFLSzz6
	OwNsDqeAu8TLGa1gc0SBdk05uY1tAqPALCTts5C0z0LSvoCReRWjaGpBckFxUnquoV5xYm5x
	aV66XnJ+7iZGcIw+k9rBuLLB4hCjAAejEg+vpn9iiBBrYllxZe4hRgkOZiURXoawpBAh3pTE
	yqrUovz4otKc1OJDjKbA0JjILCWanA9MH3kl8YbGJmZGlkZmFkYm5uZK4rwHWq0DhQTSE0tS
	s1NTC1KLYPqYODilGhjZKwrcRD8uvquRtNWvbaverYWVC3/7V/w0L0ksXd4uU6+XwMa5vaP6
	8qWAjAPNZX9TM/KTap13rVDTcOKZEXCQYblX2nWdzx9mxP+e2eXiYPFgfZHFWqa+7R+eLPbU
	9u4vn3/z5xpFqbCWlzxJcQvSzWPK/p199VVzr8a+XMneZoX3li5H2ZVYijMSDbWYi4oTARie
	VVDnAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 07:07:59AM -0800, Jaegeuk Kim wrote:
> Hi Changman,
> 
> On Mon, Nov 10, 2014 at 06:54:37PM +0900, Changman Lee wrote:
> > On Sat, Nov 08, 2014 at 11:36:05PM -0800, Jaegeuk Kim wrote:
> > > The roll-forward mechanism should be activated when the number of active
> > > logs is not 2.
> > > 
> > > Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> > > ---
> > >  fs/f2fs/file.c    | 2 ++
> > >  fs/f2fs/segment.c | 4 ++--
> > >  2 files changed, 4 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
> > > index 46311e7..54722a0 100644
> > > --- a/fs/f2fs/file.c
> > > +++ b/fs/f2fs/file.c
> > > @@ -132,6 +132,8 @@ static inline bool need_do_checkpoint(struct inode *inode)
> > >  		need_cp = true;
> > >  	else if (test_opt(sbi, FASTBOOT))
> > >  		need_cp = true;
> > > +	else if (sbi->active_logs == 2)
> > > +		need_cp = true;
> > >  
> > >  	return need_cp;
> > >  }
> > > diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
> > > index 2fb3d7f..16721b5d 100644
> > > --- a/fs/f2fs/segment.c
> > > +++ b/fs/f2fs/segment.c
> > > @@ -1090,8 +1090,8 @@ static int __get_segment_type_4(struct page *page, enum page_type p_type)
> > >  		else
> > >  			return CURSEG_COLD_DATA;
> > >  	} else {
> > > -		if (IS_DNODE(page) && !is_cold_node(page))
> > > -			return CURSEG_HOT_NODE;
> > > +		if (IS_DNODE(page) && is_cold_node(page))
> > > +			return CURSEG_WARM_NODE;
> > 
> > Hi Jaegeuk,
> > 
> > We should take hot/cold seperation into account as well.
> > In case of dir inode, it will be mixed with COLD_NODE.
> > If it's trade-off, let's notice it kindly as comments.
> 
> NAK.
> This patch tries to fix a bug, which is not a trade-off.
> We should write files' direct node blocks in CURSEG_WARM_NODE for recovery.
> 
> Thanks,

Okay, a word of 'trade-off' is wrong. We must be able to do recovery.
However, we break a rule of hot/cold separation we want. So I thought we
should notice its negative effect.
Anyway, how about putting WARM and HOT together instead HOT and COLD?
We can distinguish enough if they are direct node and have fsync_mark at
recovery time although HOT/WARM are mixed.
Let me know if there is my misundertanding.

Thanks,

> 
> > 
> > Regards,
> > Changman
> > 
> > >  		else
> > >  			return CURSEG_COLD_NODE;
> > >  	}
> > > -- 
> > > 2.1.1
> > > 
> > > 
> > > ------------------------------------------------------------------------------
> > > _______________________________________________
> > > Linux-f2fs-devel mailing list
> > > Linux-f2fs-devel@lists.sourceforge.net
> > > https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel
