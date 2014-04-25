Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751805AbaDYHba (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 03:31:30 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:52737 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbaDYHb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 03:31:27 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.SOC.1.00.1404241249480.13595@math.ut.ee>
References: <alpine.SOC.1.00.1404241249480.13595@math.ut.ee>
Date: Fri, 25 Apr 2014 13:01:26 +0530
Message-ID: <CAKohpokQ5xHF8ZYs+1RkBCX_J910FWfoKK1gN0KBRf9eUQ+2ug@mail.gmail.com>
Subject: Re: 3.15-rc2: longhaul cpufreq stalls tasks for 120s+
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Meelis Roos <mroos@linux.ee>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 April 2014 15:26, Meelis Roos <mroos@linux.ee> wrote:
> This is VIA EPIA board with 533 MHz VIA Samuel 2 CPU. Normally, longhaul
> is not enabled automatically but with longhaul.enable=1. It used to work
> up to 3.14 but in 3.15-rc, different cpufreq-related codepaths block for
> long times and cause warnings.
>
> /usr/bin/cpufreq-set --cpu 0 --governor ondemand
> is running since boot and hangs in D state.
> Running cpufreq-info seems to just hang too.

Okay, I know WTF is going on here. My mistake, but as I said earlier this
patch only highlighted the issue by serializing things its there since last
6-8 months.

I will send out patches shortly, please test them. Description of what actually
happened will be present there in details.

In short, we are sending double notifications here, once from core and once
from driver :(
