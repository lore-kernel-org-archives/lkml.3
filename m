Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934001Ab3CSXXt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 19:23:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41566 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752286Ab3CSXXs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 19:23:48 -0400
Message-ID: <5148F2E9.5000401@zytor.com>
Date: Tue, 19 Mar 2013 16:21:13 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        penguin-kernel@i-love.sakura.ne.jp,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: Re: [PATCH] x86/microcode_intel_early.c: Get 32-bit physical address
 by __pa_nodebug()
References: <1363705484-27645-1-git-send-email-fenghua.yu@intel.com> <CAE9FiQVhziaB9vEUNw-EBvA1Bfey=uMEw+CERuqSyPgU3qCJUA@mail.gmail.com>
In-Reply-To: <CAE9FiQVhziaB9vEUNw-EBvA1Bfey=uMEw+CERuqSyPgU3qCJUA@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2013 04:15 PM, Yinghai Lu wrote:
> On Tue, Mar 19, 2013 at 8:04 AM, Fenghua Yu <fenghua.yu@intel.com> wrote:
>> From: Fenghua Yu <fenghua.yu@intel.com>
>>
>> In 32-bit, __pa_symbol() in CONFIG_DEBUG_VIRTUAL accesses kernel data (e.g.
>> max_low_pfn) that haven't been setup yet in such early boot phase. To fix the
>> issue, __pa_nodebug() replaces __pa_symbol() to get a global symbol's physical
>> address.
> 
> That explanation is not precise.
> 
> __phys_addr in 32bit when DEBUG_VIRTUAL is set, it does have check
>         /* max_low_pfn is set early, but not _that_ early */
>         if (max_low_pfn) {
>          ....
>         }
> the reason should be:
> in head_32.S, 32bit flat mode, you need to switch to phys addr to access
> global variable max_low_pfn.
> 

Uh, no.

It already does that.  The problem is that __pa_symbol() breaks with
CONFIG_DEBUG_VIRTUAL at this point; we need to use __pa_nodebug().

	-hpa

