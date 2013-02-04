Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886Ab3BDTtt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 14:49:49 -0500
Received: from mail-ve0-f173.google.com ([209.85.128.173]:62740 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754494Ab3BDTtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 14:49:47 -0500
Date: Mon, 4 Feb 2013 11:49:42 -0800
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/13] workqueue: remove WORK_CPU_NONE
Message-ID: <20130204194942.GZ27963@mtj.dyndns.org>
References: <1359657696-2767-1-git-send-email-laijs@cn.fujitsu.com>
 <1359657696-2767-2-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359657696-2767-2-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Lai.

On Fri, Feb 01, 2013 at 02:41:24AM +0800, Lai Jiangshan wrote:
> In __next_wq_cpu() for_each_*wq_cpu(), the name WORK_CPU_LAST
> is proper than WORK_CPU_NONE, convert them to WORK_CPU_LAST.
> 
> WORK_CPU_NONE is not used any more, just remove it.
...
>  #define for_each_wq_cpu(cpu)						\
>  	for ((cpu) = __next_wq_cpu(-1, cpu_possible_mask, 3);		\
> -	     (cpu) < WORK_CPU_NONE;					\
> +	     (cpu) < WORK_CPU_LAST;					\
>  	     (cpu) = __next_wq_cpu((cpu), cpu_possible_mask, 3))

LAST implies that it's the last element of the range and thus that
it's an inclusive range.  Maybe we should rename it to WORK_CPU_END?

Thanks.

-- 
tejun
