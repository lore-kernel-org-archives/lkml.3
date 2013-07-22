Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933418Ab3GVU7G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 16:59:06 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:57904 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932316Ab3GVU7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 16:59:04 -0400
Message-ID: <51ED9D15.3010304@linaro.org>
Date: Mon, 22 Jul 2013 13:59:01 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: LKML <linux-kernel@vger.kernel.org>, Jiri Kosina <jkosina@suse.cz>,
        Borislav Petkov <bp@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
        Rabin Vincent <rabin.vincent@stericsson.com>
Subject: Re: [PATCH] RTC: Add an alarm disable quirk
References: <1374162294-29726-1-git-send-email-bp@alien8.de> <51E8194E.1030704@linaro.org> <20130718225349.GD15992@pd.tnic> <20130719142628.GC19581@pd.tnic> <20130719151321.GD19581@pd.tnic>
In-Reply-To: <20130719151321.GD19581@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2013 08:13 AM, Borislav Petkov wrote:
> On Fri, Jul 19, 2013 at 04:26:28PM +0200, Borislav Petkov wrote:
>> On Fri, Jul 19, 2013 at 12:53:49AM +0200, Borislav Petkov wrote:
>>>> I assumed it was some sort of BIOS issue where any modification of the
>>>> RTC_AIE bit caused the alarm irq line to be left high(or something
>>>> like that) that triggered the immediate power-on on shutdown. But I've
>>>> not been able to dig down on this.
>>> Ha, this actually fits like an ass on a bucket (don't ask - German
>>> proverb :-)).
>>>
>>> If what you're saying is actually the case, then this explains why not
>>> writing to 0xb doesn't cause the alarm irq to fire.
>>>
>>> Btw, in the trace above we do the disabling twice. Once from
>>> rtc_timer_remove() and then again from rtc_timer_do_work().
>>>
>>> So, if we disable it once and we touch RTC_AIE again causing the second
>>> time to rearm the alarm irq, this would explain the issue. Which reminds
>>> me:
>>>
>>> Maybe we should read out the alarm interrupt first and disable it only
>>> if it is enabled - that would save us the modification of RTC_AIE. Cool,
>>> I'll try that tomorrow.
>> Well, the below seems to do the trick. But since I don't trust the BIOS
>> in any way, I'll run it a couple more days here. Btw, I think we should
>> commit this regardless, as it saves us unneeded writes:
> Nope, this doesn't help - box just rebooted. :(
>
> So I'm back to the DMI quirk patch...

So did this work some of the time, but not all? Or was the behavior 
totally unchanged with this?

thanks
-john
