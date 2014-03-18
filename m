Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362AbaCRA75 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 20:59:57 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:9769 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbaCRA7z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 20:59:55 -0400
X-AuditID: cbfee61a-b7fb26d00000724f-36-53279a8a44c5
From: Chao Yu <chao2.yu@samsung.com>
To: jaegeuk.kim@samsung.com
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <000301cf41c5$10f247b0$32d6d710$@samsung.com>
 <1395102807.3870.156.camel@kjgkr>
In-reply-to: <1395102807.3870.156.camel@kjgkr>
Subject: RE: [f2fs-dev] [PATCH] f2fs: fix incorrect parsing with option string
Date: Tue, 18 Mar 2014 08:59:08 +0800
Message-id: <000001cf4245$5f848250$1e8d86f0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQHkftPyJOYmOMW8xMk/fS1Cv2qhuAIB2wK5mqt9ScA=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGLMWRmVeSWpSXmKPExsVy+t9jAd2uWerBBifPc1pc3/WXyeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzFZZOSmpNZllqkb5fAlXH950vGgs/cFSue
	72VqYFzO2cXIySEhYCLxqHU1C4QtJnHh3nq2LkYuDiGBRYwSbY27GSGcH4wSkzbtYgapYhNQ
	kVje8Z8JxBYRkJaY9WkeWDezQKbEvaYZYDVCArESi95BTOUU0JOY+HM1G4gtLOAncWrqcbBe
	FgFVifYVa8BsXgFLiQtb/rFC2IISPybfg5qpLjFp3iJmCFtb4sm7C6wQlypI7Dj7mhHiBiuJ
	UyeesULUiEtsPHKLZQKj0Cwko2YhGTULyahZSFoWMLKsYhRNLUguKE5KzzXUK07MLS7NS9dL
	zs/dxAgO/WdSOxhXNlgcYhTgYFTi4X3Bph4sxJpYVlyZe4hRgoNZSYR36WSgEG9KYmVValF+
	fFFpTmrxIUZpDhYlcd4DrdaBQgLpiSWp2ampBalFMFkmDk6pBkbZdQL772r+e732zTPb1YFX
	T9wJan75Tb+22d/6xqFmzg29zmsSo4/EBgU9lfOacpvR906OAutqkX85+lkFBVx2OQfWNHRJ
	9fFd6ldxkp9zo2OCvf6XRddqIr7qRZ2Zs8pg/az0sxpStv3hHA4F4nM7Lu25Ft60smfmOu0H
	az62PeJ1qc2ZOU+JpTgj0VCLuag4EQBhT8a3eQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk.kim@samsung.com]
> Sent: Tuesday, March 18, 2014 8:33 AM
> To: Chao Yu
> Cc: linux-f2fs-devel@lists.sourceforge.net; linux-fsdevel@vger.kernel.org;
> linux-kernel@vger.kernel.org
> Subject: Re: [f2fs-dev] [PATCH] f2fs: fix incorrect parsing with option string
> 
> Hi,
> 
> 2014-03-17 (월), 17:40 +0800, Chao Yu:
> > Previously 'background_gc={on***,off***}' is being parsed as correct option,
> > with this patch we cloud fix the trivial bug in mount process.
> >
> > Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> > ---
> >  fs/f2fs/super.c |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
> > index 057a3ef..6597290 100644
> > --- a/fs/f2fs/super.c
> > +++ b/fs/f2fs/super.c
> > @@ -258,9 +258,9 @@ static int parse_options(struct super_block *sb, char *options)
> >
> >  			if (!name)
> >  				return -ENOMEM;
> > -			if (!strncmp(name, "on", 2))
> > +			if (!strncmp(name, "on", strlen(name)))
> 
> What about 'background_gc=o'?
> Need to check strlen(name) == 2...

Oh, you're right. I will fix it and send v2 patch.
Thanks for your review. :)

> Thanks,
> 
> >  				set_opt(sbi, BG_GC);
> > -			else if (!strncmp(name, "off", 3))
> > +			else if (!strncmp(name, "off", strlen(name)))
> >  				clear_opt(sbi, BG_GC);
> >  			else {
> >  				kfree(name);
> 
> --
> Jaegeuk Kim
> Samsung

