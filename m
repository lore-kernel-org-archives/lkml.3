Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933496AbaEGNUu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 09:20:50 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:62181 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933140AbaEGNUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 09:20:47 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpon3J7c1waqcN_sqOKw=2ahzF2tk4yT8+e8fndxKobtqiA@mail.gmail.com>
References: <f13134fea7e7658ae3dab90faca1e6578b8f82e7.1397017662.git.viresh.kumar@linaro.org>
	<alpine.DEB.2.02.1405071203150.6261@ionos.tec.linutronix.de>
	<CAKohpon3J7c1waqcN_sqOKw=2ahzF2tk4yT8+e8fndxKobtqiA@mail.gmail.com>
Date: Wed, 7 May 2014 18:50:47 +0530
Message-ID: <CAKohpom5w=ZERxjkAyTkJFrGFu7SUMs27jHm=9dSB1dYYk-1Tg@mail.gmail.com>
Subject: Re: [PATCH V2] clocksource: register cpu notifier to remove timer
 from dying CPU
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linaro Networking <linaro-networking@linaro.org>,
        Arvind Chauhan <Arvind.Chauhan@arm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Fengguang Wu <fengguang.wu@intel.com>, Jet Chen <jet.chen@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 May 2014 16:06, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> And if that's the case what do we want should we do with these
> timers (i.e. ones added with add_timer_on or mod_timer_pinned)
> when we try to quiesce a cpu using cpuset.quiesce [1]?

Okay, I thought again and above looked stupid :) .. During isolation
we can't migrate any pinned timers and so these will stay as is.
But we shouldn't change the code (which I changed in my initial
patchset), which migrates away pinned timers as well..

Probably just add a pr_warn() there and mention we are migrating
a pinned timer. That's it.

--
viresh
