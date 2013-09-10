Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679Ab3IJGwR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 02:52:17 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:54388 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754633Ab3IJGwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 02:52:13 -0400
MIME-Version: 1.0
In-Reply-To: <5225E205.7080008@linux.vnet.ibm.com>
References: <085013f4e584e3fef97187bcb349c3fa76942e19.1378012620.git.viresh.kumar@linaro.org>
	<80c4bd8c577e5da0aa63342671773be5cdc26a9a.1378012620.git.viresh.kumar@linaro.org>
	<5225E205.7080008@linux.vnet.ibm.com>
Date: Tue, 10 Sep 2013 12:22:12 +0530
Message-ID: <CAKohpom-UFkvORuuzAEUj1jVofHTEkDMhSmMUo4_0Xxfj605-g@mail.gmail.com>
Subject: Re: [PATCH 2/2] cpufreq: serialize calls to __cpufreq_governor()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Stephen Boyd <sboyd@codeaurora.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Back finally and I see lots of mails over cpufreq stuff.. :)

On 3 September 2013 18:50, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
> This doesn't solve the problem completely: it prevents the store_*() task
> from continuing *only* when it concurrently executes the __cpufreq_governor()
> function along with the CPU offline task. But if the two calls don't overlap,
> we will still have the possibility where the store_*() task tries to acquire
> the timer mutex after the CPU offline task has just finished destroying it.

How exactly? My brain is still on vacations :)

Anyway, this was one of the problem that I tried to solve with my patch.
But there can be other race conditions where things can go wrong and so
that patch may still be useful.

Call to __cpufreq_governor() must be serialized I believe.
