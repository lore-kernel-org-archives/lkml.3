Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001Ab3CFHBk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 02:01:40 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:63939 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575Ab3CFHBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 02:01:35 -0500
Message-ID: <5136E9A4.7000201@huawei.com>
Date: Wed, 6 Mar 2013 15:00:52 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: "Kirill A. Shutemov" <kirill@shutemov.name>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH] cgroup: make cgrp->event_list_lock irqsafe
References: <5136B7C1.6030403@huawei.com> <20130306062224.GJ1227@htj.dyndns.org>
In-Reply-To: <20130306062224.GJ1227@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/3/6 14:22, Tejun Heo wrote:
> Hello, Li.
> 
> On Wed, Mar 06, 2013 at 11:28:01AM +0800, Li Zefan wrote:
>> cgroup_event_wake() is called with hardirq-safe wqh->lock held, so
>> the nested cgrp->event_list_lock should also be hardirq-safe.
>>
>> Fortunately I don't think the deadlock can happen in real life.
>>
>> Lockdep never complained, maybe because it never found wqh->lock was
>> held in irq context?
> 
> Why should wqh->lock be hard-irq-safe?  Is it actually grabbed from
> irq context?

becase cgroup_event_wake() is a callback to a wait queue, and it's wake_up()
that acquires wqh->lock with irq disabled.

> Locks which are grabbed with irq disabled aren't
> necessarily irq context locks as that doesn't lead to deadlocks.  They
> need to be actually grabbed from irq context.
> 
> Thanks.
> 

