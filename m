Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759426Ab3BGVGj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 16:06:39 -0500
Received: from mail-da0-f52.google.com ([209.85.210.52]:44296 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759417Ab3BGVGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 16:06:05 -0500
Date: Thu, 7 Feb 2013 13:06:00 -0800
From: Tejun Heo <tj@kernel.org>
To: Joonsoo Kim <js1304@gmail.com>, Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH wq/for-3.9] workqueue: move nr_running into worker_pool
Message-ID: <20130207210600.GU2875@htj.dyndns.org>
References: <20130124193944.GR2373@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130124193944.GR2373@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 11:39:44AM -0800, Tejun Heo wrote:
> As nr_running is likely to be accessed from other CPUs during
> try_to_wake_up(), it was kept outside worker_pool; however, while less
> frequent, other fields in worker_pool are accessed from other CPUs
> for, e.g., non-reentrancy check.  Also, with recent pool related
> changes, accessing nr_running matching the worker_pool isn't as simple
> as it used to be.
> 
> Move nr_running inside worker_pool.  Keep it aligned to cacheline and
> define CPU pools using DEFINE_PER_CPU_SHARED_ALIGNED().  This should
> give at least the same cacheline behavior.
> 
> get_pool_nr_running() is replaced with direct pool->nr_running
> accesses.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Joonsoo Kim <js1304@gmail.com>

Applied to wq/for-3.9.

Thanks.

-- 
tejun
