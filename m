Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751479Ab3FXNqZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 09:46:25 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:56589 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939Ab3FXNqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 09:46:23 -0400
Message-ID: <51C84E94.8020100@linux.vnet.ibm.com>
Date: Mon, 24 Jun 2013 19:20:12 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@osdl.org>
CC: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Jens Axboe <axboe@kernel.dk>, Kiyoshi Ueda <k-ueda@ct.jp.nec.com>,
        Lin Ming <ming.m.lin@intel.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] block:Remove extra condition in end of disk check
References: <20130623171711.7127.16248.sendpatchset@codeblue.in.ibm.com>
In-Reply-To: <20130623171711.7127.16248.sendpatchset@codeblue.in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062413-8878-0000-0000-000007AA2224
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CCing more relevant people (with the help of get_maintainer --git-blame)

On 06/23/2013 10:47 PM, Raghavendra K T wrote:
> From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
>
> Since #sector is always positive the reduced condition check
> encompasses maxsector < nr_sectors check.
>
> Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
> ---
> An userspace program looping with:
> maxsector - 0-9999
> nr_sector - 0-999
> sector - 0-999 gave 6.4% improvement with new condition though I agree that
> it is not the best way to test it perhaps :)
>
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 33c33bc..4a78583 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -1656,7 +1656,7 @@ static inline int bio_check_eod(struct bio *bio, unsigned int nr_sectors)
>   	if (maxsector) {
>   		sector_t sector = bio->bi_sector;
>
> -		if (maxsector < nr_sectors || maxsector - nr_sectors < sector) {
> +		if (maxsector - nr_sectors < sector) {
>   			/*
>   			 * This may well happen - the kernel calls bread()
>   			 * without checking the size of the device, e.g., when
>
>

