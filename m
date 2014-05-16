Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932527AbaEPTWy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 15:22:54 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:54463 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756949AbaEPTWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 15:22:52 -0400
Date: Fri, 16 May 2014 15:22:49 -0400
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Kevin Hilman <khilman@linaro.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Mike Galbraith <bitbucket@online.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 3/5] workqueue: Create low-level unbound workqueues
 cpumask
Message-ID: <20140516192249.GK5379@htj.dyndns.org>
References: <1400257015-28222-1-git-send-email-fweisbec@gmail.com>
 <1400257015-28222-4-git-send-email-fweisbec@gmail.com>
 <alpine.DEB.2.10.1405161250350.492@gentwo.org>
 <20140516183500.GI5379@htj.dyndns.org>
 <alpine.DEB.2.10.1405161350360.1681@gentwo.org>
 <20140516190042.GJ5379@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140516190042.GJ5379@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2014 at 03:00:42PM -0400, Tejun Heo wrote:
> > /sys/kernel/workqueue/.... ?
> 
> Right, that could have been more in line with slab files.  It's
> already too late tho.  This has been exposed for quite a while now.
> Urgh...

Okay, another difference, so things under /sys/devices generate
uevents and can thus be configured on boot or dynamically as the nodes
are created, which doesn't work for other /sys directories and
top-level directories take more boilerplate code.  Maybe the right
thing to do is moving /sys/kernel under /sys/devices and making
/sys/kernel a symlink?  It kinda sucks that the whole thing sits
outside the usual notification mechanism.

Thanks.

-- 
tejun
