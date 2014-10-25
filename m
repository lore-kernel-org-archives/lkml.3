Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690AbaJYTqd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 15:46:33 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:45158 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbaJYTqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 15:46:32 -0400
Message-ID: <544B4534.4030204@gmail.com>
Date: Sat, 25 Oct 2014 02:37:40 -0400
From: "Michael L. Semon" <mlsemon35@gmail.com>
User-Agent: Mozilla/5.0 (X11; FreeBSD amd64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "Martin K. Petersen" <martin.petersen@oracle.com>
CC: linux-kernel@vger.kernel.org, axboe@fb.com
Subject: Re: Slow dc3dd in 3.18 on x86
References: <544AA317.8070609@gmail.com> <yq1r3xxtfa7.fsf@sermon.lab.mkp.net>	<544AEEF1.30506@gmail.com> <yq1wq7osyr3.fsf@sermon.lab.mkp.net>
In-Reply-To: <yq1wq7osyr3.fsf@sermon.lab.mkp.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/14 21:51, Martin K. Petersen wrote:
>>>>>> "Michael" == Michael L Semon <mlsemon35@gmail.com> writes:
>
> Michael> There was nothing regarding integrity in /sys/block/sda.  I was
> Michael> under the impression that both bio integrity and T10 checksums
> Michael> require hardware support from good hardware, so the config
> Michael> items have always been shut off.
>
> That's correct. But I see what's going on.
>
> Please try this:
>
> commit 8d331952d2cd341d5c0e64eee961f78f6eb4b968
> Author: Martin K. Petersen <martin.petersen@oracle.com>
> Date:   Fri Oct 24 21:39:12 2014 -0400
>
>      block: Fix merge logic when CONFIG_BLK_DEV_INTEGRITY is not defined
>
>      Commit 4eaf99beadce switched to returning bool and as a result
>      reversed the logic of the integrity merge checks.  However, the
>      empty stubs used when the block integrity code is compiled out were
>      still returning 0. Make these stubs return "true".
>
>      Reported-by: Michael L. Semon <mlsemon35@gmail.com>
>      Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
>
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 9fbf4d3196ed..7442c6b9187e 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -1590,13 +1590,13 @@ static inline bool blk_integrity_merge_rq(struct request_queue *rq,
>   					  struct request *r1,
>   					  struct request *r2)
>   {
> -	return 0;
> +	return true;
>   }
>   static inline bool blk_integrity_merge_bio(struct request_queue *rq,
>   					   struct request *r,
>   					   struct bio *b)
>   {
> -	return 0;
> +	return true;
>   }
>   static inline bool blk_integrity_is_initialized(struct gendisk *g)
>   {
>

Excellent!  All is well with the problem kernel.  All is well with the
night's git master + xfs-oss/for-next as well.  The saved E-mail patched
cleanly against both kernels using `git am`.  About 40 GB of data was
written, some using fio, most using dc3dd.  No problems.

I'll keep this patch and stand behind its good results so far.

Thanks again!

Michael

