Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757543Ab3FTKzd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 06:55:33 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:62637 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754893Ab3FTKzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 06:55:32 -0400
MIME-Version: 1.0
In-Reply-To: <51C2DD3D.5040601@samsung.com>
References: <1371716524-19370-1-git-send-email-cw00.choi@samsung.com>
	<CAKohponD5s6-g0X9rgsVt0U4RutfyXSQJRZP3vT7EuczgMMQ2Q@mail.gmail.com>
	<51C2DD3D.5040601@samsung.com>
Date: Thu, 20 Jun 2013 16:25:31 +0530
Message-ID: <CAKohpomx54Y3WVToYP0nOw-hsxKzGjp2nyfzWf5bo1s530Yg1w@mail.gmail.com>
Subject: Re: [PATCH v2] cpufreq: stats: Add 'load_table' debugfs file to show
 accumulated data of CPUs
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 June 2013 16:15, Chanwoo Choi <cw00.choi@samsung.com> wrote:
> Yes, freq->old is same freq->new.
>
> The cpufreq gorvernor(dbs_check_cpu()) send CPUFREQ_LOADCHECK noti
> right after calculating CPUs load, regardless of changing CPU frequency.
> So, I use only freq->old value without using freq->new because load_table
> debugfs file need current cpu frequency.
>
> Now, I can't think of any proper usage for freq->new.
> Do you have good way for using freq->new to include more useful data in load_table?

This information might be interesting.. At what load, we moved from
which freq to which one..

Just see if you can add the notification after frequency has been
changed.
