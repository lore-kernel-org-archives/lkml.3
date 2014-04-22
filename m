Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758447AbaDVUqc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 16:46:32 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:42393 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758401AbaDVUq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 16:46:27 -0400
Date: Tue, 22 Apr 2014 16:46:23 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2 V3] workqueue: substitute POOL_FREEZING with
 __WQ_FREEZING
Message-ID: <20140422204623.GC3615@mtj.dyndns.org>
References: <1398081561-12618-1-git-send-email-laijs@cn.fujitsu.com>
 <20140421222035.GA22730@htj.dyndns.org>
 <5355CA43.5040608@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5355CA43.5040608@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Apr 22, 2014 at 09:47:47AM +0800, Lai Jiangshan wrote:
> Testing workqueue_freezing requires wq_pool_mutex held.
> Although almost-all pwq_adjust_max_active() are called with wq_pool_mutex held,
> except workqueue_set_max_active(). But I hope pwq_adjust_max_active()
> don't require the heavy wq_pool_mutex.

No it doesn't require wq_pool_mutex to be held.  All it requires is
that the changed state is visible on the subsequent
pwq_adjust_max_active() invocatino which is already trivially
guaranteed.

Thanks.

-- 
tejun
