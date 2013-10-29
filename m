Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609Ab3J2Hn6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 03:43:58 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:20109 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040Ab3J2Hn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 03:43:56 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee690-b7f3d6d000001c4a-e9-526f673b8ff6
Content-transfer-encoding: 8BIT
Message-id: <1383032597.14041.12.camel@kjgkr>
Subject: RE: [f2fs-dev] [PATCH] f2fs:fix truncate_partial_nodes bug
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: "shifei10.ge" <shifei10.ge@samsung.com>
Cc: "'??'" <shu.tan@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Date: Tue, 29 Oct 2013 16:43:17 +0900
In-reply-to: <000101ced479$26555160$72fff420$%ge@samsung.com>
References: <27929860.72301382948116848.JavaMail.weblogic@epml07>
 <1382955704.992.91.camel@kjgkr>
 <000101ced479$26555160$72fff420$%ge@samsung.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLIsWRmVeSWpSXmKPExsVy+t8zY13r9Pwgg22dvBaXFrlb7Nl7ksXi
	8q45bBYPDj5jtmhdeJ7ZgdVj94LPTB59W1YxenzeJBfAHMVlk5Kak1mWWqRvl8CVsXwZV8EG
	9opNf/uZGxiPsHYxcnJICJhInL3wkgXCFpO4cG89G4gtJLCMUeLO1jyYmofXzzN3MXIBxacz
	Spx4/4oJJMErICjxY/I9oGYODmYBeYkjl7JBwswC6hKT5i2Cqn/FKHHjxHl2kBpeAV2JM3t5
	QWqEBZwlduyeA9bKJqAtsXm/AcRaRYm3+++CnSYCFL5/7hgLyBhmgVZGiZnrToHdxiKgKvHq
	yAqwIk4BW4lTF96xQzRPY5TY+DIdxOYXEJU4vHA7M8T9ShK72zvZQQZJCJxjl/iy8jUjxCAB
	iW+TD4EdISEgK7HpAFS9pMTBFTdYJjBKzELy5SyEL2ch+XIBI/MqRtHUguSC4qT0IhO94sTc
	4tK8dL3k/NxNjJCom7CD8d4B60OMyUAbJzJLiSbnA6M2ryTe0NjMyMLUxNTYyNzSjDRhJXFe
	tUdJQUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYp8/R5b3Qfef+SpftgbrbdtRLSPVuOfk1
	onmia80cE1XFE64i4jomDY8ePlb0cJ0m167/YHLvq/i4NDdX7cQTx8xbZKe2BZzXDTSKr3nl
	3r9u3u0N929mfLNfFHhHsD7xn3gD38HPRpNPfDlbYCBYsXOyvxjPjyv2XDf2si6+oxZQbsr1
	J3yZEktxRqKhFnNRcSIAyDMHSdACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNKsWRmVeSWpSXmKPExsVy+t9jQV3r9Pwgg54ZnBaXFrlb7Nl7ksXi
	8q45bBYPDj5jtmhdeJ7ZgdVj94LPTB59W1YxenzeJBfAHNXAaJORmpiSWqSQmpecn5KZl26r
	5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtFJJoSwxpxQoFJBYXKykb4dpQmiIm64F
	TGOErm9IEFyPkQEaSFjHmLF8GVfBBvaKTX/7mRsYj7B2MXJySAiYSDy8fp4ZwhaTuHBvPVsX
	IxeHkMB0RokT718xgSR4BQQlfky+x9LFyMHBLCAvceRSNkiYWUBdYtK8RcwQ9a8YJW6cOM8O
	UsMroCtxZi8vSI2wgLPEjt1zwFrZBLQlNu83AAkLCShKvN1/F+wEEaDw/XPHWEDGMAu0MkrM
	XHeKDSTBIqAq8erICrAiTgFbiVMX3rFDNE9jlNj4Mh3E5hcQlTi8cDvU/UoSu9s72ScwCs1C
	cvUshKtnIbl6ASPzKkbR1ILkguKk9FxDveLE3OLSvHS95PzcTYzgqH4mtYNxZYPFIUYBDkYl
	Ht4HzPlBQqyJZcWVuYcYJTiYlUR4dwQDhXhTEiurUovy44tKc1KLDzEmAx0+kVlKNDkfmHDy
	SuINjU3MjCyNzCyMTMzNSRNWEuc90GodKCSQnliSmp2aWpBaBLOFiYNTqoFx2l074VOdGgsl
	WZb5T9rAeVXE65G/8LpYmR1lWc8zuUzf/ujmmTyzTWmeeaFz3Ivcp4rpS55kOFaquKjeCAr9
	vVwx9ZyajurySSbytveNTA9XhfsXpoqKebs0s6oJau159N1c0ua21yrp6P26i29Ma85u539j
	ud7h9YZpUWdkBRtW6oQU9SmxFGckGmoxFxUnAgAisAYCLgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2013-10-29 (화), 15:32 +0800, shifei10.ge:
> Hi,I think we don't need to put the invalid page that get_node_page returned.
> So I add " idx = i--" based on your version.Following is the patch: 
> 
> ---
>  fs/f2fs/node.c |   13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> index 304d5ce..fd5f721 100644
> --- a/fs/f2fs/node.c
> +++ b/fs/f2fs/node.c
> @@ -631,19 +631,19 @@ static int truncate_partial_nodes(struct dnode_of_data *dn,
>  		return 0;
>  
>  	/* get indirect nodes in the path */
> -	for (i = 0; i < depth - 1; i++) {
> +	for (i = 0; i < idx + 1; i++) {
>  		/* refernece count'll be increased */
>  		pages[i] = get_node_page(sbi, nid[i]);
>  		if (IS_ERR(pages[i])) {
> -			depth = i + 1;
>  			err = PTR_ERR(pages[i]);
> +			idx = i--;

You meant (idx = i - 1)?
If so, idx = i--; is wrong.

-- 
Jaegeuk Kim
Samsung

