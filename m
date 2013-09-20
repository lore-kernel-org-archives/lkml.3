Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537Ab3ITXDD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 19:03:03 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:64628 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045Ab3ITXDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 19:03:01 -0400
Date: Fri, 20 Sep 2013 18:02:56 -0500
From: Tejun Heo <tj@kernel.org>
To: Maxim Patlasov <MPatlasov@parallels.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, fengguang.wu@intel.com,
        jack@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] writeback: fix delayed sync(2)
Message-ID: <20130920230256.GB8763@mtj.dyndns.org>
References: <20130920125029.17356.66782.stgit@dhcp-10-30-17-2.sw.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130920125029.17356.66782.stgit@dhcp-10-30-17-2.sw.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Sep 20, 2013 at 04:52:26PM +0400, Maxim Patlasov wrote:
> @@ -294,7 +294,7 @@ void bdi_wakeup_thread_delayed(struct backing_dev_info *bdi)
>  	unsigned long timeout;
>  
>  	timeout = msecs_to_jiffies(dirty_writeback_interval * 10);
> -	mod_delayed_work(bdi_wq, &bdi->wb.dwork, timeout);
> +	queue_delayed_work(bdi_wq, &bdi->wb.dwork, timeout);

Hmmm... this at least requires comment explaining why
mod_delayed_work() doesn't work here.  Also, I wonder whether what we
need is a function which either queues if !pending and shortens timer
if pending.  This is a relatively common pattern and the suggested fix
is subtle and fragile.

Thanks.

-- 
tejun
