Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405AbaDPRai (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 13:30:38 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:58825 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754920AbaDPRa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 13:30:26 -0400
Date: Wed, 16 Apr 2014 13:30:22 -0400
From: Tejun Heo <tj@kernel.org>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] workqueue: fix bugs in wq_update_unbound_numa()
 failure path
Message-ID: <20140416173022.GN1257@htj.dyndns.org>
References: <58237829.Dxp0IlFuXc@daeseok-laptop.cloud.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58237829.Dxp0IlFuXc@daeseok-laptop.cloud.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 02:32:29PM +0900, Daeseok Youn wrote:
> 
> wq_update_unbound_numa() failure path has the following two bugs.
>  - alloc_unbound_pwq() is called without holding wq->mutex;
>  however, if the allocation fails, it jumps to out_unlock
>  which tries to unlock wq->mutex.
> 
>  - The function should switch to dfl_pwq on failure
>  but didn't do so after alloc_unbound_pwq() failure.
> 
> Fix it by regrabbing wq->mutex and jumping to use_dfl_pwq on
> alloc_unbound_pwq() failure.
> 
> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>

Applied to wq/for-3.15-fixes.

Thanks.

-- 
tejun
