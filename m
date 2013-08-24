Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932072Ab3HXAWd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 20:22:33 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:62280 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755357Ab3HXAWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 20:22:30 -0400
MIME-Version: 1.0
In-Reply-To: <5217EB9A.5050206@wwwdotorg.org>
References: <1377287112-12018-1-git-send-email-ccross@android.com>
	<5217EB9A.5050206@wwwdotorg.org>
Date: Fri, 23 Aug 2013 17:22:29 -0700
X-Google-Sender-Auth: p7DgO3IfLxWZT-SiiYyD5VBYfa0
Message-ID: <CAMbhsRQzmyftujGhD+b7WwdXWP9b+=R0D7SavgKSjWKuFNLejQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] cpuidle: coupled: disable interrupts after entering
 safe state
From: Colin Cross <ccross@android.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Neil Zhang <zhangwm@marvell.com>,
        Joseph Lo <josephl@nvidia.com>,
        linux-tegra <linux-tegra@vger.kernel.org>, stable@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 4:09 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 08/23/2013 01:45 PM, Colin Cross wrote:
>> Calling cpuidle_enter_state is expected to return with interrupts
>> enabled, but interrupts must be disabled before starting the
>> ready loop synchronization stage.  Call local_irq_disable after
>> each call to cpuidle_enter_state for the safe state.
>
> Tested-by: Stephen Warren <swarren@nvidia.com>
>
> Note: I tested the current Tegra cpuidle code that's in next-20130819.
> IIRC, Joseph reported the issue when trying to enable some additional
> feature in Tegra30 cpuidle. I didn't actually try to enable whatever
> that was; I just briefly tested for regressions in the existing code
> configuration.

Is that for the series or just this patch?
