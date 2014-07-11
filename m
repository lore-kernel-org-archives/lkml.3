Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257AbaGKPDc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 11:03:32 -0400
Received: from mail-qg0-f54.google.com ([209.85.192.54]:54971 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427AbaGKPDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 11:03:30 -0400
Date: Fri, 11 Jul 2014 11:03:27 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] workqueue: remove the first check and the return
 value of maybe_create_worker()
Message-ID: <20140711150327.GF27706@htj.dyndns.org>
References: <1405008074-11031-1-git-send-email-laijs@cn.fujitsu.com>
 <1405008074-11031-2-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405008074-11031-2-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 12:01:03AM +0800, Lai Jiangshan wrote:
> @@ -1887,17 +1887,11 @@ static void pool_mayday_timeout(unsigned long __pool)
>   * spin_lock_irq(pool->lock) which may be released and regrabbed
>   * multiple times.  Does GFP_KERNEL allocations.  Called only from
>   * manager.
> - *
> - * Return:
> - * %false if no action was taken and pool->lock stayed locked, %true
> - * otherwise.
>   */
> -static bool maybe_create_worker(struct worker_pool *pool)
> +static void maybe_create_worker(struct worker_pool *pool)

We probably should drop "maybe_" from the function name?

-- 
tejun
