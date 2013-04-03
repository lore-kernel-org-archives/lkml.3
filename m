Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760187Ab3DCBOn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 21:14:43 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:50075 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759866Ab3DCBOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 21:14:41 -0400
MIME-Version: 1.0
In-Reply-To: <1364799360-23145-9-git-send-email-jaegeuk.kim@samsung.com>
References: <1364799360-23145-1-git-send-email-jaegeuk.kim@samsung.com>
	<1364799360-23145-9-git-send-email-jaegeuk.kim@samsung.com>
Date: Wed, 3 Apr 2013 10:14:40 +0900
Message-ID: <CAKYAXd__NqtAqub5X-30RAirPfyp5d75sxbp9t5wdtYfmTSzUg@mail.gmail.com>
Subject: Re: [PATCH 9/9] f2fs: fix the bitmap consistency of dirty segments
From: Namjae Jeon <linkinjeon@gmail.com>
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/1, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> Like below, there are 8 segment bitmaps for SSR victim candidates.
>
> enum dirty_type {
> 	DIRTY_HOT_DATA,		/* dirty segments assigned as hot data logs */
> 	DIRTY_WARM_DATA,	/* dirty segments assigned as warm data logs */
> 	DIRTY_COLD_DATA,	/* dirty segments assigned as cold data logs */
> 	DIRTY_HOT_NODE,		/* dirty segments assigned as hot node logs */
> 	DIRTY_WARM_NODE,	/* dirty segments assigned as warm node logs */
> 	DIRTY_COLD_NODE,	/* dirty segments assigned as cold node logs */
> 	DIRTY,			/* to count # of dirty segments */
> 	PRE,			/* to count # of entirely obsolete segments */
> 	NR_DIRTY_TYPE
> };
>
> The upper 6 bitmaps indicates segments dirtied by active log areas
> respectively.
> And, the DIRTY bitmap integrates all the 6 bitmaps.
>
> For example,
>  o DIRTY_HOT_DATA : 1010000
>  o DIRTY_WARM_DATA: 0100000
>  o DIRTY_COLD_DATA: 0001000
>  o DIRTY_HOT_NODE : 0000010
>  o DIRTY_WARM_NODE: 0000001
>  o DIRTY_COLD_NODE: 0000000
> In this case,
>  o DIRTY          : 1111011,
>
>  which means that we should guarantee the consistency between DIRTY and
> other
>  bitmaps concreately.
>
> However, the SSR mode selects victims freely from any log types, which can
> set
> multiple bits across the various bitmap types.
>
> So, this patch eliminates this inconsistency.
>
> Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Looks good to me~
Reviewed-by: Namjae Jeon <namjae.jeon@samsung.com>

Thanks.
