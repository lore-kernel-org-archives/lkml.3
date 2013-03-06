Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab3CFGWb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 01:22:31 -0500
Received: from mail-gg0-f182.google.com ([209.85.161.182]:39344 "EHLO
	mail-gg0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736Ab3CFGW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 01:22:29 -0500
X-Greylist: delayed 17662 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Mar 2013 01:22:29 EST
Date: Tue, 5 Mar 2013 22:22:24 -0800
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH] cgroup: make cgrp->event_list_lock irqsafe
Message-ID: <20130306062224.GJ1227@htj.dyndns.org>
References: <5136B7C1.6030403@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5136B7C1.6030403@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Li.

On Wed, Mar 06, 2013 at 11:28:01AM +0800, Li Zefan wrote:
> cgroup_event_wake() is called with hardirq-safe wqh->lock held, so
> the nested cgrp->event_list_lock should also be hardirq-safe.
> 
> Fortunately I don't think the deadlock can happen in real life.
> 
> Lockdep never complained, maybe because it never found wqh->lock was
> held in irq context?

Why should wqh->lock be hard-irq-safe?  Is it actually grabbed from
irq context?  Locks which are grabbed with irq disabled aren't
necessarily irq context locks as that doesn't lead to deadlocks.  They
need to be actually grabbed from irq context.

Thanks.

-- 
tejun
