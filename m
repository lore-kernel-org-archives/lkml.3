Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336Ab3J2IIP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 04:08:15 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:16107 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719Ab3J2IIK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 04:08:10 -0400
X-AuditID: cbfee61b-b7fd56d000001fc6-3a-526f6ce88772
From: "shifei10.ge" <shifei10.ge@samsung.com>
To: jaegeuk.kim@samsung.com
Cc: "'??'" <shu.tan@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
References: <27929860.72301382948116848.JavaMail.weblogic@epml07>
 <1382955704.992.91.camel@kjgkr>
 <000101ced479$26555160$72fff420$%ge@samsung.com>
 <1383032597.14041.12.camel@kjgkr>
In-reply-to: <1383032597.14041.12.camel@kjgkr>
Subject: RE: [f2fs-dev] [PATCH] f2fs:fix truncate_partial_nodes bug
Date: Tue, 29 Oct 2013 16:07:15 +0800
Message-id: <000b01ced47d$fe7034d0$fb509e70$%ge@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7Uep52/tNz8AVSTKadZJOUrqjHbgAAalpg
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJLMWRmVeSWpSXmKPExsVy+t9jAd0XOflBBm27bSyu7/rLZHFpkbvF
	nr0nWSwu75rDZtG68DyzA6vH7gWfmTz6tqxi9Pi8SS6AOYrLJiU1J7MstUjfLoErY0NfH3PB
	HO6KBb8vsjcwXuPoYuTkkBAwkfj0qIEdwhaTuHBvPVsXIxeHkMAiRokrq88yQji/GSWmT70O
	VsUmoCux/shnJhBbREBaYtaneSwgRcwCrYwSM9edgmrfxShx5/4fsA5OAT2Jn5OvgNnCAs4S
	O3bPYQGxWQRUJS63b2MEsXkFbCS+Pj7BBGELSvyYfA+ohgNoqrrElCm5IGFmAW2JJ+8usIKE
	JYDCj/7qgpgiAkYSmz6lQVSIS0x68JB9AqPQLCRzZiHMmYVkziwkHQsYWVYxiqYWJBcUJ6Xn
	GukVJ+YWl+al6yXn525iBEfAM+kdjKsaLA4xCnAwKvHwWrDlBwmxJpYVV+YeYpTgYFYS4d0R
	DBTiTUmsrEotyo8vKs1JLT7EKM3BoiTOe7DVOlBIID2xJDU7NbUgtQgmy8TBKdXAaFEbf+er
	lrDN3iDn/7ZeJZVTsh5XBTv/m5itu+A499951vouOfJOme695jU5LwSEMg+8mH389V1WNwuR
	oz2WSq3B98T6sua0+vpard4R4Szxa/WuzLm5ZqfX3jl485lWj7qxe/S3XQv+75hdsuf+secC
	O9+VJ0pXyU9r4eS+/jVygn1I5qepSizFGYmGWsxFxYkAPt7he3wCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk.kim@samsung.com]
> Sent: Tuesday, October 29, 2013 3:43 PM
> To: shifei10.ge
> Cc: '??'; linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; linux-
> f2fs-devel@lists.sourceforge.net
> Subject: RE: [f2fs-dev] [PATCH] f2fs:fix truncate_partial_nodes bug
> 
> Hi,
> 
> 2013-10-29 (화), 15:32 +0800, shifei10.ge:
> > Hi,I think we don't need to put the invalid page that get_node_page returned.
> > So I add " idx = i--" based on your version.Following is the patch:
> >
> > ---
> >  fs/f2fs/node.c |   13 +++++++------
> >  1 file changed, 7 insertions(+), 6 deletions(-)
> >
> > diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c index 304d5ce..fd5f721
> > 100644
> > --- a/fs/f2fs/node.c
> > +++ b/fs/f2fs/node.c
> > @@ -631,19 +631,19 @@ static int truncate_partial_nodes(struct dnode_of_data
> *dn,
> >  		return 0;
> >
> >  	/* get indirect nodes in the path */
> > -	for (i = 0; i < depth - 1; i++) {
> > +	for (i = 0; i < idx + 1; i++) {
> >  		/* refernece count'll be increased */
> >  		pages[i] = get_node_page(sbi, nid[i]);
> >  		if (IS_ERR(pages[i])) {
> > -			depth = i + 1;
> >  			err = PTR_ERR(pages[i]);
> > +			idx = i--;
> 
> You meant (idx = i - 1)?
> If so, idx = i--; is wrong.

Yes，here should be : idx = --i;

> 
> --
> Jaegeuk Kim
> Samsung

