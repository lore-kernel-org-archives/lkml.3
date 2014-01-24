Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169AbaAXKvX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 05:51:23 -0500
Received: from mail-bk0-f53.google.com ([209.85.214.53]:35639 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbaAXKvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 05:51:21 -0500
Date: Fri, 24 Jan 2014 02:51:12 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Tejun Heo <tj@kernel.org>
cc: Li Zefan <lizefan@huawei.com>, Viresh Kumar <viresh.kumar@linaro.org>,
        mingo@kernel.org, peterz@infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, linux-kernel@vger.kernel.org,
        Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH] cpusets: Allocate heap only when required
In-Reply-To: <20140124103631.GB4101@htj.dyndns.org>
Message-ID: <alpine.DEB.2.02.1401240243260.24372@chino.kir.corp.google.com>
References: <8622e93b9c49c66ffdc9ef0aa8371c322718edd5.1390475530.git.viresh.kumar@linaro.org> <alpine.DEB.2.02.1401231330530.7313@chino.kir.corp.google.com> <52E1C8BD.2010500@huawei.com> <alpine.DEB.2.02.1401240230190.9846@chino.kir.corp.google.com>
 <20140124103631.GB4101@htj.dyndns.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Jan 2014, Tejun Heo wrote:

> > It's not harmless, if heap_init() fails with -ENOMEM then the write fails 
> > even though it may not be for memory_spread_page or memory_spread_slab, 
> > which is the minority of the callers of this function.
> 
> And depending on details like that would actually be more harmful.
> Please remember that all writes through cgroupfs may fail under very
> high memory pressure.  There's no "this specific set of writes to this
> specific knob isn't affected by memory pressure" guarantee.
> 

Nobody is depending on shit, the patch is removing a completely pointless 
memory allocation in braindead cpuset code.  What you think is "harmful" 
or "more harmful" is irrelevant, but nobody said anything about depending 
on that behavior to do anything.

Thanks.
