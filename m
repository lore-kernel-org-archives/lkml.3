Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807AbbATUxg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 15:53:36 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:51692 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbbATUxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 15:53:35 -0500
Message-ID: <54BEC04D.1050402@codeaurora.org>
Date: Tue, 20 Jan 2015 12:53:33 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Daniel Thompson <daniel.thompson@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>
CC: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Dirk Behme <dirk.behme@de.bosch.com>,
        Daniel Drake <drake@endlessm.com>,
        Dmitry Pervushin <dpervushin@gmail.com>,
        Tim Sander <tim@krieglstein.org>, John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH 3.19-rc2 v14 0/7] arm: Implement arch_trigger_all_cpu_backtrace
References: <1415968543-29469-1-git-send-email-daniel.thompson@linaro.org> <1421144818-14036-1-git-send-email-daniel.thompson@linaro.org> <54BE2D15.9080606@linaro.org>
In-Reply-To: <54BE2D15.9080606@linaro.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2015 02:25 AM, Daniel Thompson wrote:
> On 13/01/15 10:26, Daniel Thompson wrote:
>> Hi Thomas, Hi Jason:
>>     Patches 1 to 3 are for you (and should be separable from the rest
>>     of the series). The patches haven't changes since the last time
>>     I posted them. The changes in v14 tidy up the later part of the
>>     patch set in order to share more code between x86 and arm.
> No review comments! Have I finally got this right?
>
> If so it possible and/or sensible to get patches 1-3 in a tree that
> feeds linux-next. I'd really like the gic changes to meet the various
> ARM build and boot bots.

With this patchset, is it possible to call sched_clock() from within NMI
context? I ask because the generic sched_clock() code is not NMI safe
today. We were planning on making it NMI safe by doing something similar
to what was done for ktime_get_mono_fast_ns() but we haven't gotten
around to it. Mostly because no architecture that uses generic
sched_clock() has support for NMIs right now.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project

