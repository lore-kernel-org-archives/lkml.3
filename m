Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890AbaHMCAt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 22:00:49 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:44627 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655AbaHMCAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 22:00:46 -0400
X-AuditID: cbfee61a-f79e46d00000134f-6d-53eac6c6d7c7
From: Chao Yu <chao2.yu@samsung.com>
To: "'Minchan Kim'" <minchan@kernel.org>
Cc: ngupta@vflare.org, linux-kernel@vger.kernel.org,
        "'Jerome Marchand'" <jmarchan@redhat.com>,
        "'Sergey Senozhatsky'" <sergey.senozhatsky@gmail.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>
References: <000001cfb53f$d63b6ea0$82b24be0$@samsung.com>
 <20140812073740.GA9227@bbox>
In-reply-to: <20140812073740.GA9227@bbox>
Subject: RE: [PATCH] zram: fix incorrectly stat with failed_reads
Date: Wed, 13 Aug 2014 09:59:17 +0800
Message-id: <008f01cfb69a$60a5c850$21f158f0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQF4FQUURvVmlZfToiq37apX9RhKNwG2iExAnG9SahA=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHLMWRmVeSWpSXmKPExsVy+t9jAd1jx14FG7x6KWgxZ/0aNotTf64z
	WVzeNYfNYtnX9+wWG1pmsVus/fyY3YHNY+esu+wem1Z1snmcmPGbxeP9vqtAsU+bWT0+b5IL
	YIvisklJzcksSy3St0vgyli09ylrwSS+ijMndrM2MM7g6mLk5JAQMJGYffsoO4QtJnHh3nq2
	LkYuDiGBRYwSC5/+ZYZwfjBKNE94wgZSxSagIrG84z8TiC0ioCax7uALFpAiZoEjjBItfw+D
	jRISiJC4fGQ2UBEHB6eApsSsLTUgYWEBR4mdB26wgoRZBFQlFp/PBjF5BSwlfs6oBangFRCU
	+DH5HguIzSygLjFp3iJmCFteYvOat8wQdypI7Dj7mhHiAiuJ5/d+MELUiEtsPHKLZQKj0Cwk
	o2YhGTULyahZSFoWMLKsYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAiOlWdSOxhXNlgcYhTg
	YFTi4a3gfRUsxJpYVlyZe4hRgoNZSYTXYQtQiDclsbIqtSg/vqg0J7X4EKM0B4uSOO+BVutA
	IYH0xJLU7NTUgtQimCwTB6dUA+PCFvYnnRey91bdaPIQ2qW3XZr1giLD8SOS7xRNP5TuteZ6
	93eDQ3nnYUf9adGpIqFvVn6suHDZwTBEr8/sQfsx/52rr6nm1CSwKwWrMdWLbHmn/z2urU/y
	/e7NDjYn9q97x8F+OF1546qKPP7Qd8lyzOcTHbIK99g7Lp7/s+TyoRzBLQ+m3VBiKc5INNRi
	LipOBABvVSy9kQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Minchan,

> -----Original Message-----
> From: Minchan Kim [mailto:minchan@kernel.org]
> Sent: Tuesday, August 12, 2014 3:38 PM
> To: Chao Yu
> Cc: ngupta@vflare.org; linux-kernel@vger.kernel.org; Jerome Marchand; Sergey Senozhatsky;
> Andrew Morton
> Subject: Re: [PATCH] zram: fix incorrectly stat with failed_reads
> 
> On Mon, Aug 11, 2014 at 04:39:17PM +0800, Chao Yu wrote:
> > Since we allocate a temporary buffer in zram_bvec_read to handle partial page
> > operations in this commit 924bd88d703e53d30f393fac6117f8f1bc79aab6 (Staging:
> > zram: allow partial page operations), our ->failed_reads value may be incorrect
> > as we do not increase its value when failed to allocate the temporary buffer.
> >
> > Let's fix this issue and correct the annotation of failed_reads.

[snip]

> How abouting moving failed_reads/writes in zram_bvec_rw?
> 
> int zram_bvec_rw(..)
> {
>         if (rw == READ) {
>                 atomic64_inc(num_reads);
>                 ret = zram_bvec_read(xxx);
>         } else {
>                 atomic64_inc(&num_writes);
>                 ret = zram_bvec_write(xxx);
>         }
> 
>         if (unlikely(ret)) {
>                 if (rw == READ)
>                         atomic64_inc(failed_reads);
>                 else
>                         atomic64_inc(failed_writes);
>         }
> }

I will send a v2 patch base on above codes of yours, please help to review the
following new patch.

> 
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
> --
> Kind regards,
> Minchan Kim

