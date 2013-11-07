Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697Ab3KGLcg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 06:32:36 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:17533 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801Ab3KGLcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 06:32:32 -0500
X-AuditID: cbfec7f5-b7ef66d00000795a-73-527b7a4e98d7
From: Tomasz Figa <t.figa@samsung.com>
To: Grant Likely <grant.likely@linaro.org>
Cc: Olof Johansson <olof@lixom.net>, devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 1/2] of: irq: Fix interrupt-map entry matching
Date: Thu, 07 Nov 2013 12:32:25 +0100
Message-id: <1773667.KXPxL5WsyI@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.11.2 (Linux/3.11.5-gentoo; KDE/4.11.2; x86_64; ; )
In-reply-to: <2713030.RoDxNQo0oz@amdc1227>
References: <1381869563-16083-1-git-send-email-grant.likely@linaro.org>
 <2177804.l4VGDTRFDu@amdc1227> <2713030.RoDxNQo0oz@amdc1227>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrILMWRmVeSWpSXmKPExsVy+t/xy7r+VdVBBqcjLD40tTJbzD9yjtXi
	wJ8djBZfD69gtLi8aw6bxanrn9kc2Dx63rSwety5tofN48qJJlaPz5vkAliiuGxSUnMyy1KL
	9O0SuDJ2be5kKWjjrJj6/DlbA+NE9i5GTg4JAROJzz82QNliEhfurWfrYuTiEBJYyihxa9oe
	Zgini0mie9s/FpAqNgE1ic8Nj9hAbBEBLYkncz6DdTALXGWUuLK8nxkkISzgJPG7ZQpYEYuA
	qsTdBZfBmnkFNCX+fZ8Pto5fQF3i3banTCC2qICbxPQfB8F6OYGG/jyymB1icyujxPK1i9kg
	mgUlfky+BzaIWUBeYt/+qawQtpbE+p3HmSYwCs5CUjYLSdksJGULGJlXMYqmliYXFCel5xrp
	FSfmFpfmpesl5+duYoQE+9cdjEuPWR1iFOBgVOLhnVFTFSTEmlhWXJl7iFGCg1lJhLc5pDpI
	iDclsbIqtSg/vqg0J7X4ECMTB6dUAyNj+Mej7w/53b+5aJr5Q2ZdycTcch8tofcr5Y3WSq8s
	3HO5cp57VPSdHd3mT7s19RoK3bP8r/81UUo/ytkg6a6yfELBHPl6tbhtL9h1Kk8IBsbcFlsi
	WhFxpuJrsrJb3/bD0w32fiwPviRlN6eOcS+j5Vql1Q/vmLOWNEwMuZ0yMeO8ShPbXCWW4oxE
	Qy3mouJEALizmvBUAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

Could you pick this patch up? It fixes boot-up at least on several Exynos
based platforms, which use interrupt-map nodes with #interrupt-cells
higher than 1.

Also please disregard patch 2/2, as your fix that has been merged seems
to be fine.

Best regards,
Tomasz

On Tuesday 05 of November 2013 16:21:18 Tomasz Figa wrote:
> This patch fixes interrupt-map entry matching code to properly match all
> specifier cells with interrupt map entries.
> 
> Signed-off-by: Tomasz Figa <t.figa@samsung.com>
> ---
>  drivers/of/irq.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/of/irq.c b/drivers/of/irq.c
> index 0ed5ed4..717eed4 100644
> --- a/drivers/of/irq.c
> +++ b/drivers/of/irq.c
> @@ -195,7 +195,7 @@ int of_irq_parse_raw(const __be32 *addr, struct of_phandle_args *out_irq)
>  			/* Compare specifiers */
>  			match = 1;
>  			for (i = 0; i < (addrsize + intsize); i++, imaplen--)
> -				match = !((match_array[i] ^ *imap++) & imask[i]);
> +				match &= !((match_array[i] ^ *imap++) & imask[i]);
>  
>  			pr_debug(" -> match=%d (imaplen=%d)\n", match, imaplen);
>  
> 

