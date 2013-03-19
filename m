Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933419Ab3CSXsq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 19:48:46 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:34022 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933158Ab3CSXsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 19:48:43 -0400
MIME-Version: 1.0
In-Reply-To: <3E5A0FA7E9CA944F9D5414FEC6C7122055946F9E@ORSMSX105.amr.corp.intel.com>
References: <1363705484-27645-1-git-send-email-fenghua.yu@intel.com>
	<CAE9FiQVhziaB9vEUNw-EBvA1Bfey=uMEw+CERuqSyPgU3qCJUA@mail.gmail.com>
	<3E5A0FA7E9CA944F9D5414FEC6C7122055946F9E@ORSMSX105.amr.corp.intel.com>
Date: Tue, 19 Mar 2013 16:48:42 -0700
X-Google-Sender-Auth: c0K9cikUS0WMXr7yD3IbUpc-tA4
Message-ID: <CAE9FiQVHqt+Tx4vLuHQUQoZ-PcaGO4-oq7SjA5oq_M6mJh9DDQ@mail.gmail.com>
Subject: Re: [PATCH] x86/microcode_intel_early.c: Get 32-bit physical address
 by __pa_nodebug()
From: Yinghai Lu <yinghai@kernel.org>
To: "Yu, Fenghua" <fenghua.yu@intel.com>
Cc: H Peter Anvin <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        "penguin-kernel@i-love.sakura.ne.jp" 
	<penguin-kernel@i-love.sakura.ne.jp>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 4:36 PM, Yu, Fenghua <fenghua.yu@intel.com> wrote:
>> From: yhlu.kernel@gmail.com [mailto:yhlu.kernel@gmail.com] On Behalf Of
>> Yinghai Lu
>> On Tue, Mar 19, 2013 at 8:04 AM, Fenghua Yu <fenghua.yu@intel.com>
>> wrote:
>> > From: Fenghua Yu <fenghua.yu@intel.com>
>> >
>> > In 32-bit, __pa_symbol() in CONFIG_DEBUG_VIRTUAL accesses kernel data
>> (e.g.
>> > max_low_pfn) that haven't been setup yet in such early boot phase. To
>> fix the
>> > issue, __pa_nodebug() replaces __pa_symbol() to get a global symbol's
>> physical
>> > address.
>>
>> That explanation is not precise.
>>
>> __phys_addr in 32bit when DEBUG_VIRTUAL is set, it does have check
>>         /* max_low_pfn is set early, but not _that_ early */
>>         if (max_low_pfn) {
>>          ....
>>         }
>> the reason should be:
>> in head_32.S, 32bit flat mode, you need to switch to phys addr to
>> access
>> global variable max_low_pfn.
>
> Max_low_pfn is not set up yet at this point, but __pa_symbol() reads it
> if CONFIG_DEBUG_VIRTUAL. There is no need to access max_low_pfn or any
> other data that is not setup yet if CONFIG_DEBUG_VIRTUAL.
>
> So I think the explanation is ok.


Changlog said:

 In 32-bit, __pa_symbol() in CONFIG_DEBUG_VIRTUAL accesses kernel data
(e.g. max_low_pfn) that haven't been setup yet in such early boot phase.

---

So do you mean we have to change all __pa_symbol before
setup.c::setup_arch/find_low_pfn_range ?
because only at that time max_low_pfn get setup.
