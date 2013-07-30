Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752416Ab3G3LsI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 07:48:08 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:63873 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353Ab3G3LrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 07:47:02 -0400
Date: Tue, 30 Jul 2013 07:46:58 -0400
From: Tejun Heo <tj@kernel.org>
To: shli@kernel.org
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, neilb@suse.de,
        djbw@fb.com
Subject: Re: [patch 1/3] raid5: offload stripe handle to workqueue
Message-ID: <20130730114658.GA2599@htj.dyndns.org>
References: <20130730055207.698660010@kernel.org>
 <20130730055257.527231772@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130730055257.527231772@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Jul 30, 2013 at 01:52:08PM +0800, shli@kernel.org wrote:
>  static int __init raid5_init(void)
>  {
> +	raid5_wq = alloc_workqueue("raid5wq",
> +		WQ_NON_REENTRANT|WQ_UNBOUND|WQ_MEM_RECLAIM|
> +			WQ_CPU_INTENSIVE|WQ_SYSFS, 0);

Workqueues are now always non-reentrant and WQ_NON_REENTRANT is noop.
I was planning to remove it and then forgot. :) Will send out patches
to kill it.

Thanks.

-- 
tejun
