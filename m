Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313AbaGVOi3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 10:38:29 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:48477 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbaGVOi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 10:38:28 -0400
Date: Tue, 22 Jul 2014 10:38:24 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2 V2] workqueue: remove the argument @wakeup from
 worker_set_flags()
Message-ID: <20140722143824.GC13851@htj.dyndns.org>
References: <20140718225317.GC5739@htj.dyndns.org>
 <1406005330-11864-1-git-send-email-laijs@cn.fujitsu.com>
 <1406005330-11864-2-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406005330-11864-2-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 01:02:00PM +0800, Lai Jiangshan wrote:
> worker_set_flags() doesn't necessarily wake next worker and the @wakeup
> can be removed, the caller can use the following conbination instead
> when needed:
> 
> 	worker_set_flags();
> 	if (need_more_worker(pool))
>  		wake_up_worker(pool);
> 
> It reduces the machine-code and footprint for the process_one_work()
> if worker_set_flags() is really inlined.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Applied 1-2 to wq/for-3.17 w/ descriptions and comments updated.

Thanks.

-- 
tejun
