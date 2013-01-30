Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339Ab3A3PxY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 10:53:24 -0500
Received: from mail-oa0-f51.google.com ([209.85.219.51]:62811 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502Ab3A3PxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 10:53:22 -0500
MIME-Version: 1.0
In-Reply-To: <1359550803-18577-4-git-send-email-fabio.baltieri@linaro.org>
References: <1359550803-18577-1-git-send-email-fabio.baltieri@linaro.org>
	<1359550803-18577-4-git-send-email-fabio.baltieri@linaro.org>
Date: Wed, 30 Jan 2013 21:23:22 +0530
Message-ID: <CAKohpompi7mzd+XmrUzJ4T=apzpmUcryHaBfQWUoO5G3+4y=_Q@mail.gmail.com>
Subject: Re: [PATCH v7 3/4] cpufreq: conservative: call dbs_check_cpu only
 when necessary
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        swarren@wwwdotorg.org, linaro-dev@lists.linaro.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>, mathieu.poirier@linaro.org,
        Joseph Lo <josephl@nvidia.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 January 2013 18:30, Fabio Baltieri <fabio.baltieri@linaro.org> wrote:
> Modify conservative timer to not resample CPU utilization if recently
> sampled from another SW coordinated core.
>
> Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>

We are again doing the same mistake which i fixed with:

commit 4471a34f9a1f2da220272e823bdb8e8fa83a7661
Author: Viresh Kumar <viresh.kumar@linaro.org>
Date:   Fri Oct 26 00:47:42 2012 +0200

    cpufreq: governors: remove redundant code

    Initially ondemand governor was written and then using its code conservative
    governor is written. It used a lot of code from ondemand governor,
but copy of
    code was created instead of using the same routines from both
governors. Which
    increased code redundancy, which is difficult to manage.

    This patch is an attempt to move common part of both the governors to
    cpufreq_governor.c file to come over above mentioned issues.
