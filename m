Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933817AbaEMOTx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 10:19:53 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:53166 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932617AbaEMOTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 10:19:51 -0400
Date: Tue, 13 May 2014 10:19:48 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Viresh Kumar <viresh.kumar@linaro.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 08/10 V2] workqueue: rename manager_mutex to attach_mutex
Message-ID: <20140513141948.GC23710@htj.dyndns.org>
References: <20140505150514.GI11231@htj.dyndns.org>
 <1399877792-13046-1-git-send-email-laijs@cn.fujitsu.com>
 <1399877792-13046-9-git-send-email-laijs@cn.fujitsu.com>
 <20140512220102.GH18959@mtj.dyndns.org>
 <5371BFA6.3090704@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5371BFA6.3090704@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, May 13, 2014 at 02:45:58PM +0800, Lai Jiangshan wrote:
> On 05/13/2014 06:01 AM, Tejun Heo wrote:
> > On Mon, May 12, 2014 at 02:56:20PM +0800, Lai Jiangshan wrote:
> >> manager_mutex is only used to protect the attaching for the pool
> >> and the pool->workers list. It protects the pool->workers and operations
> >> based on this list, such as:
> >> 	cpu-binding for the workers in the pool->workers
> >> 	concurrency management for the workers in the pool->workers
> > 
> > Concurrency management?  What are you referring to?
> 
> The operations to set/clear POOL_DISASSOCIATED and WORKER_UNBOUND
> 
> Which words will be better if I don't use "Concurrency management"

Just be explicit and spell them out?  Concurrency management in wq
context usually means nr_running tracking and the associated worker
suppression / wake up mechanism.

Thanks.

-- 
tejun
