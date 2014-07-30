Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532AbaG3Xoe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 19:44:34 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:53919 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbaG3Xoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 19:44:32 -0400
Date: Wed, 30 Jul 2014 16:44:29 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Fengguang Wu <fengguang.wu@intel.com>
cc: Christoph Lameter <cl@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [scheduler] BUG: unable to handle kernel paging request at
 000000000000d110
In-Reply-To: <20140730135853.GL16537@localhost>
Message-ID: <alpine.DEB.2.02.1407301643480.26444@chino.kir.corp.google.com>
References: <20140730135853.GL16537@localhost>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jul 2014, Fengguang Wu wrote:

> 
> Hi Christoph,
> 
> The parent commit is clean in this case.
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-3.17-consistent-ops
> commit 9b0c63851edaf54e909475fe2a0946f57810e98a
> Author:     Christoph Lameter <cl@linux.com>
> AuthorDate: Fri Jun 20 14:31:18 2014 -0500
> Commit:     Tejun Heo <tj@kernel.org>
> CommitDate: Fri Jul 18 19:21:39 2014 -0400
> 
>     scheduler: Replace __get_cpu_var with this_cpu_ptr
>     
>     Convert all uses of __get_cpu_var for address calculation to use
>     this_cpu_ptr instead.
>     
>     Cc: Peter Zijlstra <peterz@infradead.org>
>     Acked-by: Ingo Molnar <mingo@kernel.org>
>     Signed-off-by: Christoph Lameter <cl@linux.com>
>     Signed-off-by: Tejun Heo <tj@kernel.org>

All the instances in kernel/sched/* should be of the form 
*this_cpu_ptr(&mask) due to the special handling of struct cpumask *, 
correct?
