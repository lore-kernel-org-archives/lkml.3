Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526Ab3CFHC5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 02:02:57 -0500
Received: from mail-qc0-f181.google.com ([209.85.216.181]:39075 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575Ab3CFHCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 02:02:54 -0500
MIME-Version: 1.0
In-Reply-To: <5136E9A4.7000201@huawei.com>
References: <5136B7C1.6030403@huawei.com>
	<20130306062224.GJ1227@htj.dyndns.org>
	<5136E9A4.7000201@huawei.com>
Date: Tue, 5 Mar 2013 23:02:53 -0800
X-Google-Sender-Auth: l6RrMVL-X0g2nlEbEAc38OFpVI8
Message-ID: <CAOS58YN9K9OrvvdZjUV9dFOP=SpJYgeyPp0Y5yipNE47osqXpQ@mail.gmail.com>
Subject: Re: [PATCH] cgroup: make cgrp->event_list_lock irqsafe
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 5, 2013 at 11:00 PM, Li Zefan <lizefan@huawei.com> wrote:
>> Why should wqh->lock be hard-irq-safe?  Is it actually grabbed from
>> irq context?
>
> becase cgroup_event_wake() is a callback to a wait queue, and it's wake_up()
> that acquires wqh->lock with irq disabled.

So, acquiring a lock with irq disabled doesn't make it a irq lock.
Being grabbed *from* irq handler makes it a irq lock. Would the
wake_up() happen from irq handler?

Thanks.

-- 
tejun
