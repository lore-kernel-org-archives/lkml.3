Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939AbaJMUTF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 16:19:05 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:32223 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753695AbaJMUTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 16:19:03 -0400
Message-ID: <543C33B1.2010700@fb.com>
Date: Mon, 13 Oct 2014 14:18:57 -0600
From: Jens Axboe <axboe@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Dmitry Monakhov <dmonakhov@openvz.org>, <linux-kernel@vger.kernel.org>
CC: <keith.busch@intel.com>
Subject: Re: [PATCH] block: update locking context for blk_free_devt
References: <1413225357-18981-1-git-send-email-dmonakhov@openvz.org>
In-Reply-To: <1413225357-18981-1-git-send-email-dmonakhov@openvz.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-10-13_03:2014-10-13,2014-10-13,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=1.14817400032052e-09 kscore.compositescore=0
 circleOfTrustscore=16.8481097386542 compositescore=0.99797067526462
 urlsuspect_oldscore=0.99797067526462 suspectscore=2
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=62764
 rbsscore=0.99797067526462 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1410130205
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-10-13 12:35, Dmitry Monakhov wrote:
> After 2da78092 this function will not longer sleepy
>
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>   block/genhd.c |    4 +---
>   1 files changed, 1 insertions(+), 3 deletions(-)
>
> diff --git a/block/genhd.c b/block/genhd.c
> index 09da5e4..ae9aaa5 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -441,12 +441,10 @@ int blk_alloc_devt(struct hd_struct *part, dev_t *devt)
>    * Free @devt which was allocated using blk_alloc_devt().
>    *
>    * CONTEXT:
> - * Might sleep.
> + * Don't care.
>    */
>   void blk_free_devt(dev_t devt)
>   {
> -	might_sleep();
> -
>   	if (devt == MKDEV(0, 0))
>   		return;

What's this against? The might_sleep() was killed about a month ago by 
commit 46f341ffcfb5. The comment wasn't updated though, it should be.

-- 
Jens Axboe

