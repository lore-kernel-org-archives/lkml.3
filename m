Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020Ab3LLVQ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 16:16:59 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:33251 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745Ab3LLVQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 16:16:58 -0500
Message-ID: <52AA27C7.3090206@linaro.org>
Date: Thu, 12 Dec 2013 13:16:55 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Brecht Machiels <brecht@mos6581.org>, Borislav Petkov <bp@alien8.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] 41c7f74 rtc: Disable the alarm in the hardware (v2)
References: <20131201220343.2285b12ee1c1e54252dc7dd9@mos6581.org> <529CF1D5.	6010406@linaro.org> <20131202211958.GE7380@pd.tnic> <l7ppbg$brg$1@ger.gmane.org> <52AA10F4.6070108@linaro.org>
In-Reply-To: <52AA10F4.6070108@linaro.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2013 11:39 AM, John Stultz wrote:
> On 12/05/2013 03:51 AM, Brecht Machiels wrote:
>> On Mon, 02 Dec 2013 22:19:58 +0100, Borislav Petkov wrote:
>>
>>> On Mon, Dec 02, 2013 at 12:47:17PM -0800, John Stultz wrote:
>>>> Ok, sorry about this. I've been hoping we'd get some better insight
>>>> into what's actually happening on these strange BIOSes where disabling
>>>> the irq seems to cause it to scream (powering the system back on when
>>>> its shutdown), in the hopes of having a proper workaround. But despite
>>>> Borislav's efforts, he didn't seem to be able to root cause the issue.
>>> Right, this bug is too nasty - you could generate good random numbers
>>> just from how the hardware behaves. :) And I've been trying to make
>>> sense of what happens but I failed, as you know. :(
>>>
>>> I consider it a huge waste of time and efforts having to deal with such
>>> b0rked hardware instead of throwing it out of the window into the poring
>>> rain while it is still powered.
>>>
>>>> Borislav, could you double check this patch still works on your
>>>> hardware as well?
>>> Well, we have the patch in SLES11:
>>>
>>> http://kernel.opensuse.org/cgit/kernel/commit/?h=SLE11-
>> SP3&id=835398eb94dca7d55acd1a2628372e602ae3252a
>>> and it passed testing.
>>>
>>> From what I see below, your version is equivalent to the one above with
>>> the logic reversed so it should work. I'll still try to get that
>>> affected box and run your version on it but it'll take a while.
>> Hello John and Boris,
>>
>> Thank you for your quick response. And no need for an apology, I can 
>> understand your frustration with the way some hardware behaves.
>>
>> I ran with John's patch for a couple of days, and it seems to work. 
>> Curiously, the laptop did spontaneously boot the first time that I shut 
>> it down with the patched kernel. I have no conclusive explanation for 
>> this, but I have noticed that a manual power down is necessary after 
>> booting with an unpatched kernel. Simply rebooting with a patched kernel 
>> is not enough to stop the spontaneous boots. As far as I can remember, I 
>> went directly from my custom kernel (with the v2 patch reverted) to a 
>> kernel with your patch applied, so I'm not 100% convinced everything is 
>> all right. I should say that I did experience some spontaneous boots when 
>> running only Windows XP in the past, so there may be occasions where 
>> drivers might not be able to help at all.
> Yea. It seems almost like the RTC_AIE bit is inverted in the hardware or
> something.
>
>> Thankfully, after other shutdowns/hibernates (about 6 in total) the 
>> laptop never booted spontaneously.
>>
>> As for killing alarm functionality on the affected systems, I did some 
>> quick tests. With the patched kernel, I can set the RTC alarm by echoing 
>> to /sys/class/rtc/rtc0/wakealarm, and the machine will boot at the 
>> specified time. I have also tried setting the RTC alarm, and then 
>> disabling it again by echoing '0' to /sys/class/rtc/rtc0/wakealarm. While 
>> this sets the alrm_time to five minutes in the future, alarm_IRQ is set 
>> to 'no' and the machine does *not* boot spontaneously 5 minutes after 
>> shutting down. So, all seems well, as far as I can see. Unfortunately, I 
>> don't know enough about the RTC driver to draw any conclusions from this.
> Ok. Sounds like the patch works fairly well then. I'll go ahead and
> queue it for 3.14 and -stable.
Brecht: Is it OK if I add to the patch:
 Tested-by: Brecht Machiels <brecht@mos6581.org>

Borislav:  I'd like to add your tested by too, if you've had the chance.

thanks
-john

