Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179Ab3AXTDP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 14:03:15 -0500
Received: from mail-qe0-f45.google.com ([209.85.128.45]:36739 "EHLO
	mail-qe0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893Ab3AXTDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 14:03:13 -0500
Date: Thu, 24 Jan 2013 11:03:07 -0800
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Joonsoo Kim <js1304@gmail.com>
Subject: Re: [PATCHSET] workqueue: remove gcwq and make worker_pool the only
 backend abstraction
Message-ID: <20130124190307.GQ2373@mtj.dyndns.org>
References: <1358386969-945-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358386969-945-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2013 at 05:42:32PM -0800, Tejun Heo wrote:
> Currently, on the backend side, there are two layers of abstraction.
> For each CPU and the special unbound wq-specific CPU, there's one
> global_cwq.  gcwq in turn hosts two worker_pools - one for normal
> priority, the other for highpri - each of which actually serves the
> work items.
> 
> worker_pool is the later addition to support separate pool of workers
> for highpri workqueues.  Stuff was moved to worker_pool on as-needed
> basis and, as a result, the two pools belonging to the same CPU share
> some stuff in the gcwq - most notably the lock and the hash table for
> work items currently being executed.

Applied to wq/for-3.9.

Thanks!

-- 
tejun
