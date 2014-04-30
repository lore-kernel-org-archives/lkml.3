Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945975AbaD3Rje (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 13:39:34 -0400
Received: from mail-qa0-f54.google.com ([209.85.216.54]:53074 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945926AbaD3Rjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 13:39:33 -0400
Date: Wed, 30 Apr 2014 13:39:28 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
cc: peterz@infradead.org, mingo@elte.hu, linaro-kernel@lists.linaro.org,
        linux-pm@vger.kernel.org, rjw@rjwysocki.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] sched: idle: Encapsulate the code to compile it
 out
In-Reply-To: <1398342291-16322-2-git-send-email-daniel.lezcano@linaro.org>
Message-ID: <alpine.LFD.2.11.1404301311390.980@knanqh.ubzr>
References: <1398342291-16322-1-git-send-email-daniel.lezcano@linaro.org> <1398342291-16322-2-git-send-email-daniel.lezcano@linaro.org>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Apr 2014, Daniel Lezcano wrote:

> Encapsulate the large portion of cpuidle_idle_call inside another
> function so when CONFIG_CPU_IDLE=n, the code will be compiled out.
> Also that is benefitial for the clarity of the code as it removes
> a nested indentation level.

I agree with the nesting level concern.

However I dislike the proliferation of #ifdef's in the main code. Those 
added in this patch are unnecessary. We want as much compilation 
coverage as possible.

With cpuidle_enabled() already hardcoded to return -ENODEV when 
CONFIG_CPU_IDLE=n, the compiler should already be smart enough to 
optimize away all the redundant code in that case.  You may look at the 
assembly output from the compiler if you're not sure.

And if you're still not trusting the compiler then the second best 
option is to use IS_ENABLED(CONFIG_CPU_IDLE) inside some if statement.


Nicolas
