Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085Ab3KVHuE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 02:50:04 -0500
Received: from mail-qc0-f172.google.com ([209.85.216.172]:37392 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab3KVHt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 02:49:57 -0500
Message-ID: <528F0C9E.8020409@linaro.org>
Date: Fri, 22 Nov 2013 13:19:50 +0530
From: viresh kumar <viresh.kumar@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Lan Tianyu <tianyu.lan@intel.com>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>
Subject: Re: [PATCH V2] Cpufreq: Make governor data on nonboot cpus across
 system suspend/resume
References: <9847309.KdKOG5y1Zx@vostro.rjw.lan> <1384616184-6197-1-git-send-email-tianyu.lan@intel.com> <5288425A.6000501@linaro.org>
In-Reply-To: <5288425A.6000501@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 17 November 2013 09:43 AM, viresh kumar wrote:
> On 16 November 2013 21:06, Lan Tianyu <tianyu.lan@intel.com> wrote:

> But I don't really like the solution here. You are handling frozen for EXIT in
> cpufreq-core and for INIT in governor. That doesn't look like the right
> approach. There are out of tree governors too (I know we don't care about them
> :)), and those also need to adapt with some policy made at cpufreq-core level.
> 
> I told you that I had another solution for this problem, pretty similar to
> yours. It looked like this:

Hi Lan,

There is some confusion going on here :)

There were few problems in the approach in your patch, which I have mentioned
above, and Rafael agreed to them..

> But after the PM notifiers patch I even don't want this to go.. I will make sure
> that that patch goes in, in one form or another :)

And I was still trying to get a better solution in place of these changes. And
was going on the suggestions you gave about calling cpufreq callbacks from
dpm_{suspend|resume}_noirq() calls.. And I am on my way to get things fixed that
way. And so we don't actually need this patch anymore (I just saw that you have
sent another version of it, probably because Rafael asked? Don't know what
happened there :))..

So, I will try to get something working soon for you and Nishanth..
