Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358Ab3IZGRJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 02:17:09 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:41565 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282Ab3IZGRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 02:17:07 -0400
MIME-Version: 1.0
In-Reply-To: <5243641B.6050604@linaro.org>
References: <cover.1379779777.git.viresh.kumar@linaro.org>
	<7e9565e323c1e065eeb2a2a1075967bd21ee6066.1379779777.git.viresh.kumar@linaro.org>
	<5243641B.6050604@linaro.org>
Date: Thu, 26 Sep 2013 11:47:05 +0530
Message-ID: <CAKohpo=3qFQ+gD+3u__NtZEL4xu51FBN+og+_UE7aTR26XvRng@mail.gmail.com>
Subject: Re: [PATCH 19/21] cpuidle: create list of registered drivers
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 September 2013 04:00, Daniel Lezcano <daniel.lezcano@linaro.org> wrote:
> If you introduce a list, you will have to introduce a lock to protect
> it.

I missed it, should have added that :)

> This lock will be in the fast path cpuidle_idle_call with the
> get_driver function and conforming to the comment: "NOTE: no locks or
> semaphores should be used here".
>
> A lock has been introduced in this function already and the system hangs
> with 1024 cpus.

Hmm... I see.. I didn't knew about this expectation.. What about a rcu
read/write lock? As far as I know its too lightweight... Can we have that
in fast path?
