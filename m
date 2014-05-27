Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103AbaE0M4T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 08:56:19 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:30055 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869AbaE0M4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 08:56:18 -0400
Message-ID: <53848B38.5090408@huawei.com>
Date: Tue, 27 May 2014 20:55:20 +0800
From: Libo Chen <libo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Mike Galbraith <umgwanakikbuti@gmail.com>, <tglx@linutronix.de>,
        <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, Li Zefan <lizefan@huawei.com>
Subject: Re: balance storm
References: <5382AF2E.1040407@huawei.com> <1401090987.5339.79.camel@marge.simpson.net> <53832A36.5020205@huawei.com> <20140527094802.GN30445@twins.programming.kicks-ass.net>
In-Reply-To: <20140527094802.GN30445@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.22.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/5/27 17:48, Peter Zijlstra wrote:
> So: 
> 
> 1) what kind of weird ass workload is that? Why are you waking up so
> often to do no work?

it's just a testcase, I agree it doesn`t exist in real world.

> 
> 2) turning on/off share_pkg_resource is a horrid hack whichever way
> aruond you turn it.
> 
> So I suppose this is due to the select_idle_sibling() nonsense again,
> where we assumes L3 is a fair compromise between cheap enough and
> effective enough.
> 
> Of course, Intel keeps growing the cpu count covered by L3 to ridiculous
> sizes, 8 cores isn't nowhere near their top silly, which shifts the
> balance, and there's always going to be pathological cases (like the
> proposed workload) where its just always going to suck eggs.
> 
> Also, when running 50 such things on a 16 cpu machine, you get roughly 3
> per cpu, since their runtime is stupid low, I would expect it to pretty
> much always hit an idle cpu, which in turn should inhibit the migration.
> 
> Then again, maybe the timer slack is causing you grief, resulting in all
> 3 being woken at the same time, instead of having them staggered.
> 
> In any case, I'm not sure what the 'regression' report is against, as
> there's only a single kernel version mentioned: 3.4, and that's almost a
upstream has the same problem, I have mentioned before.

> dinosaur.


