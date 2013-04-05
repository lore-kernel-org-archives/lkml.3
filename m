Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932462Ab3DEJrU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 05:47:20 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:63699 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765499Ab3DEJrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 05:47:18 -0400
MIME-Version: 1.0
In-Reply-To: <20130403215412.GG3411@htj.dyndns.org>
References: <cover.1364740180.git.viresh.kumar@linaro.org>
	<91239cde99aaba2715f63db1f88241d9f4a36e13.1364740180.git.viresh.kumar@linaro.org>
	<20130331181931.GA7533@htj.dyndns.org>
	<CAKohpo=nWsUh5y7y_tacGez7uN76QbRFRVPSQcKQMGM1nUBWtw@mail.gmail.com>
	<20130403215412.GG3411@htj.dyndns.org>
Date: Fri, 5 Apr 2013 15:17:17 +0530
Message-ID: <CAKohpomTQj-S-32JdtY76_82NraB5uBqnKZXVxk28KxMZ-NSow@mail.gmail.com>
Subject: Re: [PATCH V4 3/4] block: queue work on unbound wq
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Tejun Heo <tj@kernel.org>
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        davem@davemloft.net, airlied@redhat.com, axboe@kernel.dk,
        tglx@linutronix.de, peterz@infradead.org, mingo@redhat.com,
        rostedt@goodmis.org, linux-rt-users@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 April 2013 03:24, Tejun Heo <tj@kernel.org> wrote:
> Not a call, probably a module_param() so that it can be switched
> on/off during boot.  You can make the param writable so that it can be
> flipped run-time but updating existing workqueues would be non-trivial
> and I don't think it's gonna be worthwhile.

module_param()?? We can't compile kernel/workqueue.c as a module and
hence i went with #define + a variable with functions to set/reset it...

I am not looking to update all existing workqueues to use it but workqueues
which are affecting power for us... And if there are some very very
performance critical ones, then we must better use queue_work_on() for
them to make it more clear.
