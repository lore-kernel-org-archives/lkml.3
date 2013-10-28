Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756475Ab3J1KfS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 06:35:18 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:12555 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756456Ab3J1KfP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 06:35:15 -0400
X-AuditID: cbfee68e-b7f416d0000020d6-c8-526e3de1d060
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Message-id: <1382956476.992.94.camel@kjgkr>
Subject: Re: [f2fs-dev] [PATCH] f2fs: change the method of calculating the
 number summary blocks
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: fanofcode.li@samsung.com
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-f2fs-devel@lists.sourceforge.net" 
	<linux-f2fs-devel@lists.sourceforge.net>
Date: Mon, 28 Oct 2013 19:34:36 +0900
In-reply-to: <21040538.71861382950468176.JavaMail.weblogic@epv6ml09>
References: <21040538.71861382950468176.JavaMail.weblogic@epv6ml09>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t8zY92HtnlBBqub1C0+b21kt7i0yN1i
	z96TLBaXd81hc2Dx2L3gM5NH35ZVjB6fN8kFMEdx2aSk5mSWpRbp2yVwZbS23GYqmCZcMeva
	GdYGxu38XYycHBICJhIvv51kgrDFJC7cW8/WxcjFISSwjFFi36ObjDBFG47NYIZITGeUmPL/
	JFiCV0BQ4sfkeywgNrOAusSkeYuYIWwRiWtvX7JC2NoSyxa+hmp+xSjRdP88O0SztsSa51vA
	VgsLJEl8+z4XqIGDgw0ovnm/AUhYSEBR4u3+u2BzRARkJOZ1T2IEmcMscJtR4s2rg2AJFgFV
	if0HDoHN4RRwkdg/+QsTRLOzxM4F/9hAbH4BUYnDC7czQ3yjJLG7vZMdZJCEwCl2id7r+1kg
	BglIfJt8iAXkCAkBWYlNB6DqJSUOrrjBMoFRchaSn2ch+XkWkp9nIfl5ASPLKkbR1ILkguKk
	9CIjveLE3OLSvHS95PzcTYyQKO3bwXjzgPUhxmSg9ROZpUST84FRnlcSb2hsZmRhamJqbGRu
	aUaasJI476KHSUFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGHtFOmwlBLZLqRi8k3n46+qp
	U5/S/IS/vr652WyJR2CDVvoa0TlJ6lXSukoMV2t7zW77XlvV9Tt3yp6je1+qBnmeZmx8+M3o
	s9ai9mcxCyTagt4eOGphIBS5bhWDldBu1j060c57Fgh2vPZZP2lPXNTc54LPuK7t+2Sl4XOD
	0/Hiq86PLzYFTVRiKc5INNRiLipOBACB8unr6AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBKsWRmVeSWpSXmKPExsVy+t9jQd2HtnlBBv0nlCw+b21kt7i0yN1i
	z96TLBaXd81hc2Dx2L3gM5NH35ZVjB6fN8kFMEc1MNpkpCampBYppOYl56dk5qXbKnkHxzvH
	m5oZGOoaWlqYKynkJeam2iq5+AToumXmAG1TUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesb
	EgTXY2SABhLWMWZ8b5jAXPBNqOLchm2MDYzT+bsYOTkkBEwkNhybwQxhi0lcuLeerYuRi0NI
	YDqjxJT/JxlBErwCghI/Jt9j6WLk4GAWkJc4cikbJMwsoC4xad4iZoj6V4wSTffPs0PUa0us
	eb6FCcQWFkiS+PZ9LitILxtQfPN+A5CwkICixNv9d1lBbBEBGYl53ZMYQeYwC9xmlHjz6iBY
	gkVAVWL/gUNgczgFXCT2T/7CBNHsLLFzwT82EJtfQFTi8MLtUA8oSexu72SfwCg0C8nZsxDO
	noXk7AWMzKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxguP5mdQOxpUNFocYBTgYlXh4N6zN
	DRJiTSwrrsw9xCjBwawkwntcPy9IiDclsbIqtSg/vqg0J7X4EGMy0OETmaVEk/OBqSavJN7Q
	2MTMyNLIzMLIxNycNGElcd4DrdaBQgLpiSWp2ampBalFMFuYODilGhi9rz7R2KjpUKjlJHQr
	fX7MzUxB5fMmDW120Wox952yr158c/7buS6Fo+wcFlU/12+qfCH4V72A0SP+EG+V1eXP/6f+
	mpt6N2Zz3Pqvs/ZaCzmbd8057bZqHVel94TbYjYBnN+PTs+a7/bk/FxOueVFiwXjtp12aJl0
	7cfjol/G7pZ71I4KFJ5UYinOSDTUYi4qTgQAxhrMvCsDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2013-10-28 (월), 08:54 +0000, Fan Li:
> "There is a HTML error in the previous email, so I send this one.If you already received this before, please ignore it.Sorry for the inconvenience"
> 
> This patch change the method of calculating the number of summary blocks in function  npages_for_summary_flush.
> npages_for_summary_flush uses (SUMMARY_SIZE + 1) as the size of a f2fs_summary while the actual size is just SUMMARY_SIZE.
> As a result, occasionally the return value of npages_for_summary_flush will be bigger than the actual number by one, and the checkpoint won't be written contiguously  into disk.
> Besides, struct f2fs_summary can't be split to two pages, so it could take more space than the sum of its size, the current version seems not to take it into account.
> 

Again. Please write a description not to exceed 80 columns.

> Signed-off-by: Fan Li <fanofcode.li@samsung.com>
> ---
>  fs/f2fs/segment.c |   14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c index 487af61..ba2930f 100644
> --- a/fs/f2fs/segment.c
> +++ b/fs/f2fs/segment.c
> @@ -279,9 +279,8 @@ static void __add_sum_entry(struct f2fs_sb_info *sbi, int type,
>   */
>  int npages_for_summary_flush(struct f2fs_sb_info *sbi)  {
> -	int total_size_bytes = 0;
>  	int valid_sum_count = 0;
> -	int i, sum_space;
> +	int i, sum_in_page;
>  
>  	for (i = CURSEG_HOT_DATA; i <= CURSEG_COLD_DATA; i++) {
>  		if (sbi->ckpt->alloc_type[i] == SSR)
> @@ -290,13 +289,12 @@ int npages_for_summary_flush(struct f2fs_sb_info *sbi)
>  			valid_sum_count += curseg_blkoff(sbi, i);
>  	}
>  
> -	total_size_bytes = valid_sum_count * (SUMMARY_SIZE + 1)
> -			+ sizeof(struct nat_journal) + 2
> -			+ sizeof(struct sit_journal) + 2;
> -	sum_space = PAGE_CACHE_SIZE - SUM_FOOTER_SIZE;
> -	if (total_size_bytes < sum_space)
> +	sum_in_page = (PAGE_CACHE_SIZE - 2*SUM_JOURNAL_SIZE - SUM_FOOTER_SIZE)/

	sum_in_page = (PAGE_CACHE_SIZE - 2 * SUM_JOURNAL_SIZE -
SUM_FOOTER_SIZE) / SUMMARY_SIZE;

Coding style.

> +			SUMMARY_SIZE;
> +	if (valid_sum_count <= sum_in_page)
>  		return 1;
> -	else if (total_size_bytes < 2 * sum_space)
> +	else if (valid_sum_count-sum_in_page <=
> +			(PAGE_CACHE_SIZE-SUM_FOOTER_SIZE)/SUMMARY_SIZE)

ditto.

>  		return 2;
>  	return 3;
>  }
> --
> 1.7.9.5

-- 
Jaegeuk Kim
Samsung

