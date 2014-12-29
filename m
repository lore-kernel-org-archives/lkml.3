Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086AbaL2J4O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 04:56:14 -0500
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:41990 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745AbaL2J4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 04:56:11 -0500
Date: Mon, 29 Dec 2014 10:56:02 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Aniroop Mathur <aniroop.mathur@gmail.com>
Cc: <heiko.carstens@de.ibm.com>, <linux390@de.ibm.com>,
        <linux-s390@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <a.mathur@samsung.com>
Subject: Re: [PATCH] s390: Initialize nr_devices count variable to -1
Message-ID: <20141229105602.08d0a469@mschwide>
In-Reply-To: <1419783173-3066-1-git-send-email-aniroop.mathur@gmail.com>
References: <1419783173-3066-1-git-send-email-aniroop.mathur@gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14122909-0025-0000-0000-0000031253B4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Dec 2014 21:42:53 +0530
Aniroop Mathur <aniroop.mathur@gmail.com> wrote:

> From: Aniroop Mathur <a.mathur@samsung.com>
> 
> This patch initializes nr_device count variable to -1 to avoid extra
> subtraction operation performed everytime scm block device is set up.
> 
> Signed-off-by: Aniroop Mathur <a.mathur@samsung.com>
> ---
>  drivers/s390/block/scm_blk.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/s390/block/scm_blk.c b/drivers/s390/block/scm_blk.c
> index 76bed17..ee2bd6f 100644
> --- a/drivers/s390/block/scm_blk.c
> +++ b/drivers/s390/block/scm_blk.c
> @@ -23,7 +23,7 @@ static int scm_major;
>  static DEFINE_SPINLOCK(list_lock);
>  static LIST_HEAD(inactive_requests);
>  static unsigned int nr_requests = 64;
> -static atomic_t nr_devices = ATOMIC_INIT(0);
> +static atomic_t nr_devices = ATOMIC_INIT(-1);
>  module_param(nr_requests, uint, S_IRUGO);
>  MODULE_PARM_DESC(nr_requests, "Number of parallel requests.");
> 
> @@ -357,7 +357,7 @@ int scm_blk_dev_setup(struct scm_blk_dev *bdev, struct scm_device *scmdev)
>  	int len, ret = -ENOMEM;
>  	unsigned int devindex, nr_max_blk;
> 
> -	devindex = atomic_inc_return(&nr_devices) - 1;
> +	devindex = atomic_inc_return(&nr_devices);
>  	/* scma..scmz + scmaa..scmzz */
>  	if (devindex > 701) {
>  		ret = -ENODEV;

This patch makes the code harder to read to avoid a single subtraction at
device setup time. I prefer readability.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

