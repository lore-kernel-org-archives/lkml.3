Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001Ab3CFHX1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 02:23:27 -0500
Received: from mail-qa0-f54.google.com ([209.85.216.54]:51485 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004Ab3CFHXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 02:23:25 -0500
MIME-Version: 1.0
In-Reply-To: <CAOS58YNJd557hGDMGqavp8eq+B9x5WExCcpW+CwZ8dUainjUUw@mail.gmail.com>
References: <5136B7C1.6030403@huawei.com>
	<20130306062224.GJ1227@htj.dyndns.org>
	<5136E9A4.7000201@huawei.com>
	<CAOS58YN9K9OrvvdZjUV9dFOP=SpJYgeyPp0Y5yipNE47osqXpQ@mail.gmail.com>
	<5136ED2F.8080400@huawei.com>
	<CAOS58YNJd557hGDMGqavp8eq+B9x5WExCcpW+CwZ8dUainjUUw@mail.gmail.com>
Date: Tue, 5 Mar 2013 23:23:24 -0800
X-Google-Sender-Auth: TrIWkRu1uYhLBIXGmNjhnxmrdPw
Message-ID: <CAOS58YOvVoe5KZXMB+mSF2OhXF9_eR+yipk96JW9Fenn2EJ1XA@mail.gmail.com>
Subject: Re: [PATCH] cgroup: make cgrp->event_list_lock irqsafe
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 5, 2013 at 11:21 PM, Tejun Heo <tj@kernel.org> wrote:
>> wake_up() is also allowed to be called from irq handler?
>
> Yeah, well, we don't consider everything which uses wake_up() to be
> irq-safe. I'm not necessarily against making the lock irq-safe but at

More precise way to think about it wiatqueue lock would be that it's
built in a way that also allows it to be used from irq context. It
doesn't *force* irq context on all its users.

-- 
tejun
