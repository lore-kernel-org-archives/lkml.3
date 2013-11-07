Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750991Ab3KGFJn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 00:09:43 -0500
Received: from mail-oa0-f45.google.com ([209.85.219.45]:39043 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766Ab3KGFJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 00:09:39 -0500
MIME-Version: 1.0
In-Reply-To: <1383791330-8289-1-git-send-email-chenxg@marvell.com>
References: <1383791330-8289-1-git-send-email-chenxg@marvell.com>
Date: Thu, 7 Nov 2013 10:39:38 +0530
Message-ID: <CAKohpo=2xjR=nr5hyMg9bve5_uVbV79R2FTxks0bLmL7kNV9Mg@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: conservative: fix requested_freq reduction issue
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Xiaoguang Chen <chenxg@marvell.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Xiaoguang Chen <chenxg.marvell@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 November 2013 07:58, Xiaoguang Chen <chenxg@marvell.com> wrote:
> When decreasing frequency, requested_freq may be less than
> freq_target, So requested_freq minus freq_target may be negative,
> But reqested_freq's unit is unsigned int, then the negative result
> will be one larger interger which may be even higher than
> requested_freq.
>
> This patch is to fix such issue. when result becomes negative,
> set requested_freq as the min value of policy.
>
> Signed-off-by: Xiaoguang Chen <chenxg@marvell.com>
> ---
>  drivers/cpufreq/cpufreq_conservative.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)

Good Catch.

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

We need another patch for fixing the other part of code where we
increase freq..
We need to replace:

if (dbs_info->requested_freq == policy->max)
    return;

with

if (dbs_info->requested_freq >= policy->max)
    return;

So, that we don't run unnecessary code :)
