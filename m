Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756496Ab3FSGSD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 02:18:03 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:58930 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338Ab3FSGSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 02:18:00 -0400
MIME-Version: 1.0
In-Reply-To: <1371619479-21386-1-git-send-email-chenxg@marvell.com>
References: <1371619479-21386-1-git-send-email-chenxg@marvell.com>
Date: Wed, 19 Jun 2013 11:48:00 +0530
Message-ID: <CAKohponXvsP7yrvkmbAD1aMp6AQCp6gqaJ2L97h4kQmGFbKH3g@mail.gmail.com>
Subject: Re: [PATCH v7] Cpufreq: Fix governor start/stop race condition
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Xiaoguang Chen <chenxg@marvell.com>
Cc: rjw@sisk.pl, cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, njiang1@marvell.com, zjwu@marvell.com,
        ylmao@marvell.com, chenxg.marvell@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 June 2013 10:54, Xiaoguang Chen <chenxg@marvell.com> wrote:
> Cpufreq governor's stop and start operation should be kept in sequence.
> If not, there will be unexpected behavior, for example:
>
> There are 4 CPUs and policy->cpu=CPU0, CPU1/2/3 are linked to CPU0.
> The normal sequence is as below:
>
> 1) Current governor is userspace, One application tries to set
> governor to ondemand. It will call __cpufreq_set_policy in which it
> will stop userspace governor and then start ondemand governor.
>
> 2) Current governor is userspace, Now CPU0 hotplugs in CPU3(put CPU3 online),

You need a space before (
:(

Otherwise looks good. Add my
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
