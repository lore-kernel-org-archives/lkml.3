Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933698AbaE3Pla (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 11:41:30 -0400
Received: from mail-qg0-f50.google.com ([209.85.192.50]:50446 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932126AbaE3Pl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 11:41:27 -0400
Date: Fri, 30 May 2014 11:41:23 -0400
From: Tejun Heo <tj@kernel.org>
To: Paolo Valente <paolo.valente@unimore.it>
Cc: Jens Axboe <axboe@kernel.dk>, Li Zefan <lizefan@huawei.com>,
        Fabio Checconi <fchecconi@gmail.com>,
        Arianna Avanzini <avanzini.arianna@gmail.com>,
        Paolo Valente <posta_paolo@yahoo.it>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Subject: Re: [PATCH RFC - TAKE TWO - 06/12] block, bfq: improve responsiveness
Message-ID: <20140530154123.GD24871@htj.dyndns.org>
References: <20140528221929.GG1419@htj.dyndns.org>
 <1401354343-5527-1-git-send-email-paolo.valente@unimore.it>
 <1401354343-5527-7-git-send-email-paolo.valente@unimore.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401354343-5527-7-git-send-email-paolo.valente@unimore.it>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 11:05:37AM +0200, Paolo Valente wrote:
> @@ -281,7 +323,8 @@ static inline unsigned long bfq_serv_to_charge(struct request *rq,
>  					       struct bfq_queue *bfqq)
>  {
>  	return blk_rq_sectors(rq) *
> -		(1 + ((!bfq_bfqq_sync(bfqq)) * bfq_async_charge_factor));
> +		(1 + ((!bfq_bfqq_sync(bfqq)) * (bfqq->wr_coeff == 1) *
> +		bfq_async_charge_factor));

Ah, okay, so you actually use it later.  Please disregard my previous
comment about dropping the wrapper.

Thanks.

-- 
tejun
