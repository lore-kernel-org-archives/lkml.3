Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312Ab3IMQWe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 12:22:34 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:56448 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828Ab3IMQWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 12:22:31 -0400
MIME-Version: 1.0
In-Reply-To: <20130913161527.GE12758@n2100.arm.linux.org.uk>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
	<6e2ca86ce948c0bc35f7709baf22672771fcf1e8.1379063063.git.viresh.kumar@linaro.org>
	<20130913155424.GB12758@n2100.arm.linux.org.uk>
	<CAKohpomAj0wDnjdi7XXw=bGsu0LMRrr1SMwdzBsa0GTxGrABoQ@mail.gmail.com>
	<20130913161527.GE12758@n2100.arm.linux.org.uk>
Date: Fri, 13 Sep 2013 21:52:31 +0530
Message-ID: <CAKohpomBdAgciTYnQPn6fKC7iHvuBxFLiK8kCz62q7jRHhXK1A@mail.gmail.com>
Subject: Re: [PATCH 206/228] cpufreq: sa11x0: remove calls to cpufreq_notify_transition()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 September 2013 21:45, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> The patch to which I'm replying removes the above calls.  These calls are
> necessary to shutdown various bits of CPU-clock dependent hardware
> before changing the CPU clock, and restore them - reconfiguring them
> for the new clock rate after the transition has happened.
>
> So, if you're removing these calls, what replaces them?  I don't see
> anything which does without the above set.

The other patch on which you commented about unnecessary read
locks being taken:

[PATCH 181/228] cpufreq: move freq change notifications to cpufreq

That calls these notifiers, for all platforms except the ones that have
set CPUFREQ_ASYNC_NOTIFICATION, before and after calling
->target_index()..

And so functionally the code is supposed to be the same.. Unless I
have done some stupid mistake..
