Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756473Ab3KXCr6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 21:47:58 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:50161 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755991Ab3KXCrz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 21:47:55 -0500
X-AuditID: cbfee68e-b7f7e6d00000477d-ee-529168d9e29d
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Message-id: <1385261217.26319.84.camel@kjgkr>
Subject: Re: [f2fs-dev] [PATCH] f2fs: merge read IOs at ra_nat_pages()
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Changman Lee <cm224.lee@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Date: Sun, 24 Nov 2013 11:46:57 +0900
In-reply-to: <1385091679.16054.5.camel@lcm>
References: <1385026550-21055-1-git-send-email-jaegeuk.kim@samsung.com>
 <1385091679.16054.5.camel@lcm>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAIsWRmVeSWpSXmKPExsVy+t8zI92bGRODDA5u0ra4tq+RyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlbHuTAtTwWzBiuOX
	j7I2MO7g7WLk5JAQMJH4tLSHHcIWk7hwbz1bFyMXh5DAMkaJz0vPscEUPfg0gQnEFhKYzijx
	+Ks4iM0rICjxY/I9FhCbWUBdYtK8RcwQtohE/9nHbBC2tsSyha+ZIXpfMUosu1EG0asrcedh
	H9hiYQE3iU17/wLN4eBgA6rfvN8AolxR4u3+u6wgYREBDYmPsy0hJmZKzHk9mRXEZhFQlZj3
	axY7SAknUOf0jdUQnRkSr77cBzuYX0BU4vDC7cwQjyhJ7G7vZAf5UEJgF7vEyylrGCHmCEh8
	m3wI7AIJAVmJTQeg6iUlDq64wTKBUXIWkn9nIfl3FpJ/ZyH5dwEjyypG0dSC5ILipPQiI73i
	xNzi0rx0veT83E2MkNjs28F484D1IcZkoPUTmaVEk/OBsZ1XEm9obGZkYWpiamxkbmlGmrCS
	OO+ih0lBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhiXsFT6J56XnMSUpmXay5Jad+XLAiu1
	/Q49v9tNL868de5AZJJrq7f8ro/lVhvCFrnNnlYQ3tllcPmkWu+3k50mjtP5J0RPmXct4oL4
	vr2rzlzXDlW5b8JwLH5WomLmgglV2b7vL+ybkHTqeabU/H/vpx57c7j5eH5s7dfXn/S419xY
	/OnMvjXCSizFGYmGWsxFxYkAoJuHZeMCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMKsWRmVeSWpSXmKPExsVy+t9jQd2bGRODDC52qltc29fIZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI5qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneO
	NzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqmpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3
	JAiux8gADSSsY8xY/mgvS0GjYMWRHTvZGhjn8XYxcnJICJhIPPg0gQnCFpO4cG89G4gtJDCd
	UeLxV3EQm1dAUOLH5HssXYwcHMwC8hJHLmWDhJkF1CUmzVvEDFH+ilFi2Y0yiHJdiTsP+9hB
	bGEBN4lNe/+CtbIJaEts3m8AUa4o8Xb/XVaQsIiAhsTH2ZYQEzMl5ryezApiswioSsz7NYsd
	pIQTqHP6xmqIzgyJV1/ug93LLyAqcXjhdmaI25Ukdrd3sk9gFJqF5ORZCCfPQnLyAkbmVYyi
	qQXJBcVJ6blGesWJucWleel6yfm5mxjBUfxMegfjqgaLQ4wCHIxKPLyNjhODhFgTy4orcw8x
	SnAwK4nwdsUDhXhTEiurUovy44tKc1KLDzEmA909kVlKNDkfmGDySuINjU3MjCyNzCyMTMzN
	SRNWEuc92GodKCSQnliSmp2aWpBaBLOFiYNTqoExYmtVxbaNlzreaDPJGLdtjW2pPdNRFPL+
	0SX+td77a7iW863XqGnfLPB5lef/kvPW9z6r23oLnX/lLBnEyBwufa7I0C14m8m1J2bmSWz1
	u0s1Zvb/uCfsdFz0M0d2cPCq1PD7Li/XvpimdDxr65rsJ38Ma277S6dNnrLij+DGBb9cEvSr
	sh4osRRnJBpqMRcVJwIAelLRKCYDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2013-11-22 (금), 12:41 +0900, Changman Lee:
> How about doing mark_page_accessed(page) in ra_nat_pages like
> ra_sit_pages to prevent readahead pages are reclaimed by VM?

Agreed.
I'll modify and merge this.
Thanks,

> 
> On 목, 2013-11-21 at 18:35 +0900, Jaegeuk Kim wrote:
> > This patch changes the policy of submitting read bios at ra_nat_pages.
> > 
> > Previously, f2fs submits small read bios with block plugging.
> > But, with this patch, f2fs itself merges read bios first and then submits a
> > large bio, which can reduce the bio handling overheads.
> > 
> > Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> > ---
> >  fs/f2fs/node.c | 8 ++------
> >  1 file changed, 2 insertions(+), 6 deletions(-)
> > 
> > diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> > index b843a5b..c06871f 100644
> > --- a/fs/f2fs/node.c
> > +++ b/fs/f2fs/node.c
> > @@ -89,13 +89,10 @@ static void ra_nat_pages(struct f2fs_sb_info *sbi, int nid)
> >  {
> >  	struct address_space *mapping = sbi->meta_inode->i_mapping;
> >  	struct f2fs_nm_info *nm_i = NM_I(sbi);
> > -	struct blk_plug plug;
> >  	struct page *page;
> >  	pgoff_t index;
> >  	int i;
> >  
> > -	blk_start_plug(&plug);
> > -
> >  	for (i = 0; i < FREE_NID_PAGES; i++, nid += NAT_ENTRY_PER_BLOCK) {
> >  		if (nid >= nm_i->max_nid)
> >  			nid = 0;
> > @@ -108,12 +105,11 @@ static void ra_nat_pages(struct f2fs_sb_info *sbi, int nid)
> 
> mark_page_accessed(page);
> 
> >  			f2fs_put_page(page, 1);
> >  			continue;
> >  		}
> > -		if (f2fs_readpage(sbi, page, index, READ))
> > -			continue;
> > +		submit_read_page(sbi, page, index, READ_SYNC);
> >  
> 
> mark_page_accessed(page);
> 
> >  		f2fs_put_page(page, 0);
> >  	}
> > -	blk_finish_plug(&plug);
> > +	f2fs_submit_read_bio(sbi, READ_SYNC);
> >  }
> >  
> >  static struct nat_entry *__lookup_nat_cache(struct f2fs_nm_info *nm_i, nid_t n)
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Jaegeuk Kim
Samsung

