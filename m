Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762092Ab3DCVyV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 17:54:21 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:42055 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757802Ab3DCVyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 17:54:19 -0400
Date: Wed, 3 Apr 2013 14:54:12 -0700
From: Tejun Heo <tj@kernel.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        davem@davemloft.net, airlied@redhat.com, axboe@kernel.dk,
        tglx@linutronix.de, peterz@infradead.org, mingo@redhat.com,
        rostedt@goodmis.org, linux-rt-users@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V4 3/4] block: queue work on unbound wq
Message-ID: <20130403215412.GG3411@htj.dyndns.org>
References: <cover.1364740180.git.viresh.kumar@linaro.org>
 <91239cde99aaba2715f63db1f88241d9f4a36e13.1364740180.git.viresh.kumar@linaro.org>
 <20130331181931.GA7533@htj.dyndns.org>
 <CAKohpo=nWsUh5y7y_tacGez7uN76QbRFRVPSQcKQMGM1nUBWtw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohpo=nWsUh5y7y_tacGez7uN76QbRFRVPSQcKQMGM1nUBWtw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Viresh.

Sorry about the delay.  Lost this one somehow.

On Mon, Apr 01, 2013 at 12:01:05PM +0530, Viresh Kumar wrote:
> Just wanted to make this clear before writing it:
> 
> You want me to do something like (With better names):
> 
> int wq_unbound_for_power_save_enabled = 0;
> 
> #ifdef CONFIG_WQ_UNBOUND_FOR_POWER_SAVE
> #define WQ_UNBOUND_FOR_POWER_SAVE   wq_unbound_for_power_save_enabled
> #else
> #define WQ_UNBOUND_FOR_POWER_SAVE 0
> 
> And provide a call to enable/disable wq_unbound_for_power_save_enabled ??

Not a call, probably a module_param() so that it can be switched
on/off during boot.  You can make the param writable so that it can be
flipped run-time but updating existing workqueues would be non-trivial
and I don't think it's gonna be worthwhile.

Thanks!

-- 
tejun
