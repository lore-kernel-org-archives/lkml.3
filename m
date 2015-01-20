Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147AbbATXve (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 18:51:34 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:34540 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbbATXvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 18:51:32 -0500
Message-ID: <1421797890.9970.14.camel@haakon3.risingtidesystems.com>
Subject: Re: [PATCH] ib_srpt: wait_for_completion_timeout does not return
 negativ status
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Nicholas Mc Guire <der.herr@hofr.at>
Cc: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Bart Van Assche <bvanassche@acm.org>, Jingoo Han <jg1.han@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        Ira Weiny <ira.weiny@intel.com>, Christoph Hellwig <hch@infradead.org>,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 20 Jan 2015 15:51:30 -0800
In-Reply-To: <1421407217-9105-1-git-send-email-der.herr@hofr.at>
References: <1421407217-9105-1-git-send-email-der.herr@hofr.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nicholas,

On Fri, 2015-01-16 at 12:20 +0100, Nicholas Mc Guire wrote:
> Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
> ---
> 
> Patch is against 3.19.0-rc3 -next-20150109
> 
> Patch was compiletested only with x86_64_defconfig +
> CONFIG_TARGET_CORE=m, CONFIG_INFINIBAND=m, CONFIG_INFINIBAND_SRPT=m
> 
>  drivers/infiniband/ulp/srpt/ib_srpt.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
> index eb694dd..4e58c76 100644
> --- a/drivers/infiniband/ulp/srpt/ib_srpt.c
> +++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
> @@ -3533,7 +3533,7 @@ static void srpt_close_session(struct se_session *se_sess)
>  	spin_unlock_irq(&sdev->spinlock);
>  
>  	res = wait_for_completion_timeout(&release_done, 60 * HZ);
> -	WARN_ON(res <= 0);
> +	WARN_ON(res == 0);
>  }
>  
>  /**

Notice that 'res' here is still incorrectly defined as an 'int', instead
of 'unsigned long'.

I've updated your patch to use the proper type for res, and added a
short commit log to describe what it's doing.

Merged into target-pending/for-next.

Thanks!

--nab

