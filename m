Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933216AbaEEOyG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 10:54:06 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:61633 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932448AbaEEOyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 10:54:04 -0400
Date: Mon, 5 May 2014 10:54:00 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/10] workqueue: use generic pool-bind/unbind routine
 for rescuers
Message-ID: <20140505145400.GE11231@htj.dyndns.org>
References: <1398571754-12443-1-git-send-email-laijs@cn.fujitsu.com>
 <1398571754-12443-11-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398571754-12443-11-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2014 at 12:09:05PM +0800, Lai Jiangshan wrote:
> There are several problems with the code that rescuers bind itself to the pool'
> cpumask
>   1) It uses a way different from the normal workers to bind to the cpumask
>      So we can't maintain the normal/rescuer workers under the same framework.
>   2) The the code of cpu-binding for rescuer is complicated
>   3) If one or more cpuhotplugs happen while the rescuer processes the
>      scheduled works, the rescuer may not be correctly bound to the cpumask of
>      the pool. This is allowed behavior, but is not good. It will be better
>      if the cpumask of the rescuer is always kept coordination with the pool
>      across any cpuhotplugs.
> 
> Using generic pool-bind/unbind routine will solve the above problems,
> and result much more simple code.

Ah, nice.  Yeah, I definitely like it.  We can solve
iteration-from-oops problem using RCU if it becomes necessary.  I
don't quite like the name of bind_entry tho.  I'll comment on it on
that patch.

Thanks.

-- 
tejun
