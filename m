Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527AbaDYIZG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 04:25:06 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:55697 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbaDYIYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 04:24:53 -0400
MIME-Version: 1.0
In-Reply-To: <20140425081830.10258.10979.stgit@srivatsabhat.in.ibm.com>
References: <20140425081728.10258.63980.stgit@srivatsabhat.in.ibm.com>
	<20140425081830.10258.10979.stgit@srivatsabhat.in.ibm.com>
Date: Fri, 25 Apr 2014 13:54:52 +0530
Message-ID: <CAKohpo=RP-i9L4rNmQh=vEsXT5bEbXNQU1+bo7=gHZ4kLut9nA@mail.gmail.com>
Subject: Re: [PATCH 3/3] cpufreq, powernow-k7: Fix double invocation of cpufreq_freq_transition_begin/end
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Meelis Roos <mroos@linux.ee>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 April 2014 13:48, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
> During frequency transitions, the cpufreq core takes the responsibility of
> invoking cpufreq_freq_transition_begin() and cpufreq_freq_transition_end()
> for those cpufreq drivers that define the ->target_index callback but don't
> set the ASYNC_NOTIFICATION flag.
>
> The powernow-k7 cpufreq driver falls under this category, but this driver was
> invoking the _begin() and _end() APIs itself around frequency transitions,
> which led to double invocation of the _begin() API. The _begin API makes
> contending callers wait until the previous invocation is complete. Hence,
> the powernow-k7 driver ended up waiting on itself, leading to system hangs
> during boot.
>
> Fix this by removing the calls to the _begin() and _end() APIs from the
> powernow-k7 driver, since they rightly belong to the cpufreq core.
>
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> ---
>
>  drivers/cpufreq/powernow-k7.c |    4 ----
>  1 file changed, 4 deletions(-)

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
