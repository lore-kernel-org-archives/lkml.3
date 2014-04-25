Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751402AbaDYIhS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 04:37:18 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:36622 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbaDYIhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 04:37:14 -0400
MIME-Version: 1.0
In-Reply-To: <20140425081804.10258.8324.stgit@srivatsabhat.in.ibm.com>
References: <20140425081728.10258.63980.stgit@srivatsabhat.in.ibm.com>
	<20140425081804.10258.8324.stgit@srivatsabhat.in.ibm.com>
Date: Fri, 25 Apr 2014 14:07:13 +0530
Message-ID: <CAKohpo=0wppEthZzoRGTqurtt=135NWeVTKJ2y=mwy82+O7-zQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] cpufreq, longhaul: Fix double invocation of cpufreq_freq_transition_begin/end
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

> diff --git a/drivers/cpufreq/longhaul.c b/drivers/cpufreq/longhaul.c

> @@ -269,8 +269,6 @@ static void longhaul_setstate(struct cpufreq_policy *policy,

This routine has this code as well:

mult = mults[mults_index & 0x1f];
if (mult == -1)
        return;
speed = calc_speed(mult);
if ((speed > highest_speed) || (speed < lowest_speed))
        return;

And so it might return without changing frequency and that's why I
left this driver earlier for this change.. So, please return -EINVAL
from here..
