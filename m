Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388AbaAXKgg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 05:36:36 -0500
Received: from mail-qa0-f48.google.com ([209.85.216.48]:60155 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327AbaAXKgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 05:36:35 -0500
Date: Fri, 24 Jan 2014 05:36:31 -0500
From: Tejun Heo <tj@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: Li Zefan <lizefan@huawei.com>, Viresh Kumar <viresh.kumar@linaro.org>,
        mingo@kernel.org, peterz@infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, linux-kernel@vger.kernel.org,
        Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH] cpusets: Allocate heap only when required
Message-ID: <20140124103631.GB4101@htj.dyndns.org>
References: <8622e93b9c49c66ffdc9ef0aa8371c322718edd5.1390475530.git.viresh.kumar@linaro.org>
 <alpine.DEB.2.02.1401231330530.7313@chino.kir.corp.google.com>
 <52E1C8BD.2010500@huawei.com>
 <alpine.DEB.2.02.1401240230190.9846@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1401240230190.9846@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 24, 2014 at 02:33:27AM -0800, David Rientjes wrote:
> It's not harmless, if heap_init() fails with -ENOMEM then the write fails 
> even though it may not be for memory_spread_page or memory_spread_slab, 
> which is the minority of the callers of this function.

And depending on details like that would actually be more harmful.
Please remember that all writes through cgroupfs may fail under very
high memory pressure.  There's no "this specific set of writes to this
specific knob isn't affected by memory pressure" guarantee.

Thanks.

-- 
tejun
