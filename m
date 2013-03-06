Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111Ab3CFHVI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 02:21:08 -0500
Received: from mail-qe0-f51.google.com ([209.85.128.51]:37118 "EHLO
	mail-qe0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619Ab3CFHVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 02:21:05 -0500
MIME-Version: 1.0
In-Reply-To: <5136ED2F.8080400@huawei.com>
References: <5136B7C1.6030403@huawei.com>
	<20130306062224.GJ1227@htj.dyndns.org>
	<5136E9A4.7000201@huawei.com>
	<CAOS58YN9K9OrvvdZjUV9dFOP=SpJYgeyPp0Y5yipNE47osqXpQ@mail.gmail.com>
	<5136ED2F.8080400@huawei.com>
Date: Tue, 5 Mar 2013 23:21:03 -0800
X-Google-Sender-Auth: cRDu6xrN4BYbx4fXKA3mjKkWaNc
Message-ID: <CAOS58YNJd557hGDMGqavp8eq+B9x5WExCcpW+CwZ8dUainjUUw@mail.gmail.com>
Subject: Re: [PATCH] cgroup: make cgrp->event_list_lock irqsafe
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Li.

On Tue, Mar 5, 2013 at 11:15 PM, Li Zefan <lizefan@huawei.com> wrote:
> wqh->lock is used through out fs/eventfd.c. I don't know if currently there's
> any kernel user using eventfd APIs in an irq handler, but at least that should
> be allowed.
>
> wake_up() is also allowed to be called from irq handler?

Yeah, well, we don't consider everything which uses wake_up() to be
irq-safe. I'm not necessarily against making the lock irq-safe but at
least the commit message is misleading as currently posted. I'd
suggest looking at eventfd and see whether the wakeup could actually
happen from irq context. If not, I don't know, I don't think it
matters either way. It's not like it's a difficult one to detect with
lockdep.

-- 
tejun
