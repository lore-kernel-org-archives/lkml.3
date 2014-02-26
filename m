Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751165AbaBZFUq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 00:20:46 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:56284 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbaBZFUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 00:20:44 -0500
MIME-Version: 1.0
In-Reply-To: <530D06FF.201@codeaurora.org>
References: <1393225072-3997-1-git-send-email-skannan@codeaurora.org>
	<530BAA31.4050701@codeaurora.org>
	<CAKohpo=0CgzjCgKnDxUMcN6-CgbQ2ML=Tx-K8fS7=VJJYOD0eg@mail.gmail.com>
	<15001517.xLHO8lGdWr@vostro.rjw.lan>
	<530D06FF.201@codeaurora.org>
Date: Wed, 26 Feb 2014 10:50:43 +0530
Message-ID: <CAKohpo=iUBBcznKf0YbwNpvHNRuknC1wC0=MOSMrDYSaY2VLJQ@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: Set policy to non-NULL only after all hotplug
 online work is done
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 February 2014 02:41, Saravana Kannan <skannan@codeaurora.org> wrote:
> On 02/25/2014 05:04 AM, Rafael J. Wysocki wrote:
>> On Tuesday, February 25, 2014 02:20:57 PM Viresh Kumar wrote:

> I think there's been a misunderstanding of what I'm proposing. The reference
> to policy->clk is only to get rid of the dependency that
> cpufreq_generic_get() has on the per cpu policy variable being filled. You
> can do that by just removing calls to get _IF_ clk is filled in.

cpufreq_cpu_get() can be called by other drivers as well, which may not have
clock interface implemented for them. We can't stop them from calling it.

> I'll look at the patches later today and respond. Although, I would have
> been nice you had helped me fix any issues with my patch than coming up with
> new ones. Kinda removes to motivation for submitting patches upstream.

Sorry if I demotivated you at all :)

I just wanted to get to a quick-fix and wasn't interested in getting
my patch count
up. Thought that isn't always bad :)

I sent my patches as they were very different then your approach. Obviously, I
wouldn't have done this otherwise :)
