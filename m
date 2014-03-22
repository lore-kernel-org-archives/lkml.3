Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830AbaCVS4f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 14:56:35 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:39281 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465AbaCVSzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 14:55:55 -0400
Date: Sat, 22 Mar 2014 14:55:51 -0400
From: Tejun Heo <tj@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Kevin Hilman <khilman@linaro.org>, LKML <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>, Mike Galbraith <bitbucket@online.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 3/3] workqueue: Add anon workqueue sysfs hierarchy
Message-ID: <20140322185551.GA24945@htj.dyndns.org>
References: <1394815131-17271-1-git-send-email-fweisbec@gmail.com>
 <1394815131-17271-4-git-send-email-fweisbec@gmail.com>
 <7ha9csionc.fsf@paris.lan>
 <20140322170114.GA20038@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140322170114.GA20038@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 22, 2014 at 06:01:18PM +0100, Frederic Weisbecker wrote:
> 1) Call a per workqueue mutex when a work execute on an ordered workqueue. Although
>   contention should be very rare (only while we replace the workqueue attrs and
>   switch to a new worker), frequent locking may have a visible impact.
> 
> 2) Have a seperate worker for all ordered workqueues. But we may lose a bit of
>   serialization with other workqueues along the way.

Ordered workqueues are always bound to the fallback default worker
pool.  Why not just adjust cpus_allowed of the worker pool?

Thanks.

-- 
tejun
