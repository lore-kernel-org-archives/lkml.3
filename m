Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757839Ab3DAGbI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 02:31:08 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:43780 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757815Ab3DAGbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 02:31:06 -0400
MIME-Version: 1.0
In-Reply-To: <20130331181931.GA7533@htj.dyndns.org>
References: <cover.1364740180.git.viresh.kumar@linaro.org>
	<91239cde99aaba2715f63db1f88241d9f4a36e13.1364740180.git.viresh.kumar@linaro.org>
	<20130331181931.GA7533@htj.dyndns.org>
Date: Mon, 1 Apr 2013 12:01:05 +0530
Message-ID: <CAKohpo=nWsUh5y7y_tacGez7uN76QbRFRVPSQcKQMGM1nUBWtw@mail.gmail.com>
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

Hi Tejun,

On 31 March 2013 23:49, Tejun Heo <tj@kernel.org> wrote:
> So, let's please introduce a new flag to mark these workqueues, say,
> WQ_UNBOUND_FOR_POWER_SAVE or whatever (please come up with a better
> name) and provide a compile time switch with boot time override.

Just wanted to make this clear before writing it:

You want me to do something like (With better names):

int wq_unbound_for_power_save_enabled = 0;

#ifdef CONFIG_WQ_UNBOUND_FOR_POWER_SAVE
#define WQ_UNBOUND_FOR_POWER_SAVE   wq_unbound_for_power_save_enabled
#else
#define WQ_UNBOUND_FOR_POWER_SAVE 0

And provide a call to enable/disable wq_unbound_for_power_save_enabled ??
