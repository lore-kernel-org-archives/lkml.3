Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758810AbaCSJUk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 05:20:40 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:47405 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757060AbaCSJUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 05:20:38 -0400
MIME-Version: 1.0
In-Reply-To: <5329609B.8050200@linux.vnet.ibm.com>
References: <2efc621827cbd96a05a3d34075154974b4816ecd.1394782795.git.viresh.kumar@linaro.org>
	<532840FD.308@linux.vnet.ibm.com>
	<CAKohpomhTJa06a1LSi9tK1+=6Y2MyidJSbYWuffAsU5KxVf7zw@mail.gmail.com>
	<5329609B.8050200@linux.vnet.ibm.com>
Date: Wed, 19 Mar 2014 14:50:37 +0530
Message-ID: <CAKohpomrn25hBg5o1h8WWMM+d8o2OJJUmGEmXGvVk3BqP90HJQ@mail.gmail.com>
Subject: Re: [RFC V2] cpufreq: make sure frequency transitions are serialized
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Amit Daniel <amit.daniel@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 March 2014 14:47, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
> Wait, I think I remember. The problem was about dealing with drivers that
> do asynchronous notification (those that have the ASYNC_NOTIFICATION flag
> set). In particular, exynos-5440 driver sends out the POSTCHANGE notification
> from a workqueue worker, much later than sending the PRECHANGE notification.
>
> From what I saw, this is how the exynos-5440 driver works:
>
> 1. ->target() is invoked, and the driver writes to a register and returns
>    to its caller.
>
> 2. An interrupt occurs that indicates that the frequency was changed.
>
> 3. The interrupt handler kicks off a worker thread which then sends out
>    the POSTCHANGE notification.

Correct!!

> So the important question here is, how does the exynos-5440 driver
> protect itself from say 2 ->target() calls which occur in close sequence
> (before allowing the entire chain for the first call to complete)?
>
> As far as I can see there is no such synchronization in the driver at
> the moment. Adding Amit to CC for his comments.

Yes, and that's what my patch is trying to fix. Where is the confusion?
