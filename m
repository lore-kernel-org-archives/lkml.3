Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758224Ab3EGPs3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 11:48:29 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:49451 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758031Ab3EGPs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 11:48:28 -0400
X-IronPort-AV: E=Sophos;i="4.87,629,1363158000"; 
   d="scan'208";a="44896342"
Message-ID: <5189224A.70501@codeaurora.org>
Date: Tue, 07 May 2013 11:48:26 -0400
From: Christopher Covington <cov@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/2] ARM: Remove any correlation between IPC and BogoMips
 value
References: <1367602547-19322-1-git-send-email-will.deacon@arm.com> <5187EFF3.6010005@codeaurora.org> <20130507090849.GC25387@mudshark.cambridge.arm.com>
In-Reply-To: <20130507090849.GC25387@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2013 05:08 AM, Will Deacon wrote:
> On Mon, May 06, 2013 at 07:01:23PM +0100, Christopher Covington wrote:
>> Hi Will,
>>
>> On 05/03/2013 01:35 PM, Will Deacon wrote:
>>> Hi all,
>>>
>>> This small patch set may look a little over a month late, but there is a
>>> serious reason for posting it.
>>>
>>> When I moved the ARM delay loop over to using the architected timers
>>> rather than the CPU spinning loop (which has all the problems associated
>>> with cpu frequency scaling and what-not) I thought I was doing something
>>> useful for the port. However, it turns out that a surprising number of
>>> people have complained, and continue to complain, about the drop in
>>> their `BogoMIPs score'.
>>
>> Have you considered adding the old code back in, but in a form that's not at
>> all referenced by the delay loop code and just calculates CPU-based bogomips?
> 
> That seems like a lot of effort in order to preserve something that isn't
> even meaningful. We might be better just zeroing the value, but then we'll
> inevitably get bug reports of it being `wrong'.

If I were in to filing bug reports about bogomips values, I would be just as
likely to do it for 1, 10000, 99999, and get_random_bytes(...) as for 0.

> Plus, the calibration during boot introduces a brief delay when onlining
> each core whereas this can be skipped when using a constant timer.

If it were configurable, that might give people a reason to weigh whether they
really cared about knowing bogomips at the cost of boot time.

Christopher

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by the Linux Foundation.
