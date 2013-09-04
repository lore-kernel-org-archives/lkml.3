Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762029Ab3IDXuG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 19:50:06 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:41876 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753612Ab3IDXuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 19:50:03 -0400
Message-ID: <5227C729.5040803@codeaurora.org>
Date: Wed, 04 Sep 2013 16:50:01 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] cpufreq: serialize calls to __cpufreq_governor()
References: <085013f4e584e3fef97187bcb349c3fa76942e19.1378012620.git.viresh.kumar@linaro.org> <80c4bd8c577e5da0aa63342671773be5cdc26a9a.1378012620.git.viresh.kumar@linaro.org> <5225E205.7080008@linux.vnet.ibm.com> <1706734.hVYFTCa5rJ@vostro.rjw.lan>
In-Reply-To: <1706734.hVYFTCa5rJ@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/13 16:55, Rafael J. Wysocki wrote:
>
> Well, I'm not sure when Viresh is going to be back.
>
> Srivatsa, can you please resend this patch with a proper changelog?
>

I haven't had a chance to try this out yet, but I was just thinking
about this patch. How is it going to work? If one task opens the file
and another task is taking down the CPU wouldn't we deadlock in the
CPU_DOWN notifier waiting for the kobject to be released? Task 1 will
grab the kobject reference and sleep on the hotplug mutex and task 2
will put the kobject and wait for the completion, but it won't happen.
At least I think that's what would happen.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

