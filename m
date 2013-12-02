Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877Ab3LBEc7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 23:32:59 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:26769 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614Ab3LBEc5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 23:32:57 -0500
X-AuditID: cbfee61b-b7f166d000007a34-07-529c0d77742d
From: Chao Yu <chao2.yu@samsung.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        =?UTF-8?B?J+iwreWnnSc=?= <shu.tan@samsung.com>
References: <003301ceec0d$77ddaef0$67990cd0$@samsung.com>
 <1385720057.2417.46.camel@kjgkr>
In-reply-to: <1385720057.2417.46.camel@kjgkr>
Subject: RE: [f2fs-dev] [PATCH 2/5] f2fs: add unlikely macro for compiler
 optimization
Date: Mon, 02 Dec 2013 12:32:04 +0800
Message-id: <000001ceef17$9205e830$b611b890$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQF6NZfVVhO4jyG4qg/35udRl9YqKALWXoDumtMPSyA=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJLMWRmVeSWpSXmKPExsVy+t9jQd1y3jlBBqfWqllc3/WXyeLSIneL
	PXtPslhc3jWHzaJ14XlmB1aP3Qs+M3n0bVnF6PF5k1wAcxSXTUpqTmZZapG+XQJXxrknNQWz
	eSrev9nH2MB4nLOLkYNDQsBE4majSRcjJ5ApJnHh3nq2LkYuDiGB6YwSj1u3MEM4Pxglume3
	soFUsQmoSCzv+M8EYosISEvM+jSPBcRmFpjNKLF5tiOILSQQI3Hj7D9mEJtTQFfi+duF7CC2
	sECExP6lG8F6WQRUJS6ungrWyytgKdH8eQWULSjxY/I9qJnqEpPmLWKGsLUlnry7wApxqYLE
	jrOvGSFusJK4fPsAVI24xMYjt1gmMArNQjJqFpJRs5CMmoWkZQEjyypG0dSC5ILipPRcI73i
	xNzi0rx0veT83E2M4Ah4Jr2DcVWDxSFGAQ5GJR7eCydmBwmxJpYVV+YeYpTgYFYS4WX5CxTi
	TUmsrEotyo8vKs1JLT7EKM3BoiTOe7DVOlBIID2xJDU7NbUgtQgmy8TBKdXAyOMg2T5Fef4V
	59h9liaK7fP2NccwOdzIuXY8VT9m/vI9B4KFN21v3T9h44xYf8VdgnmzrHnZau3XxXKU6KUe
	NFG/KNO/YuKvph+Ve5IuaeiqzN2zTKzov+M35SDzB/NWTzMU3v/zp9q73n+hR3xnSIl1XM2q
	jt7HOLN1qq7LkX8hvy7+5rl9VomlOCPRUIu5qDgRAPdSX+J8AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kim,

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk.kim@samsung.com]
> Sent: Friday, November 29, 2013 6:14 PM
> To: Chao Yu
> Cc: linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; linux-f2fs-devel@lists.sourceforge.net; 谭姝
> Subject: Re: [f2fs-dev] [PATCH 2/5] f2fs: add unlikely macro for compiler optimization
> 
> Hi,
> 
> Could you make a patch to add *unlikely* as many as possible across the
> whole source files at once?
> It is wasteful to add it with a bunch of patches at multiple times.

Alright, I will work on this.

> 
> And please write descriptions for all the patches even if nothing is
> special.
> In this case, why should we set *unlikely* for checking this condition?

Got it.

Regards,
Yu

> 
> Thanks,
> 
> 2013-11-28 (목), 15:42 +0800, Chao Yu:
> > Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> > ---
> >  fs/f2fs/node.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> > index 0fe9a97..954155b 100644
> > --- a/fs/f2fs/node.c
> > +++ b/fs/f2fs/node.c
> > @@ -1160,7 +1160,7 @@ int wait_on_node_pages_writeback(struct f2fs_sb_info *sbi, nid_t ino)
> >  			struct page *page = pvec.pages[i];
> >
> >  			/* until radix tree lookup accepts end_index */
> > -			if (page->index > end)
> > +			if (unlikely(page->index > end))
> >  				continue;
> >
> >  			if (ino && ino_of_node(page) == ino) {
> 
> --
> Jaegeuk Kim
> Samsung

