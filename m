Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751507Ab3LKT5T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 14:57:19 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:56991 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924Ab3LKT5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 14:57:18 -0500
Message-ID: <52A8C39A.4040301@linaro.org>
Date: Wed, 11 Dec 2013 11:57:14 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Brecht Machiels <brecht@mos6581.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>,
        Jonathan Nieder <jrnieder@gmail.com>,
        Heinz Wiesinger <HMWiesinger@gmx.at>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [REGRESSION] 41c7f74 rtc: Disable the alarm in the hardware (v2)
References: <20131201220343.2285b12ee1c1e54252dc7dd9@mos6581.org> <529CF1D5.6010406@linaro.org>
In-Reply-To: <529CF1D5.6010406@linaro.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2013 12:47 PM, John Stultz wrote:
> On 12/01/2013 01:03 PM, Brecht Machiels wrote:
>> Hi,
>>
>> I recently installed (Arch x86_64) Linux with the 3.12.1 kernel on a Toshiba Satellite L300 laptop. After shutting down Linux, the laptop will spontaneously boot up after about five minutes. This seems to be consistent. There are no options in the BIOS for en/disabling or configuring the RTC wakeup alarm. After 'shudown --halt' and shutting down the laptop manually (pressing the power button for 3 seconds), it will not spontaneously boot up. I understand Linux is configuring the RTC alarm on shutdown? 
>>
>> After finding some other reports of similar problems, I have built a custom 3.12.1 kernel after reverting commit 41c7f74 (rtc: Disable the alarm in the hardware (v2)) [1]. This seems to solve the problem for me.
>>
>> Related discussions and bug reports:
>> * http://thread.gmane.org/gmane.linux.kernel/1527538
>>   refers to: https://bugzilla.novell.com/show_bug.cgi?id=812592
>>              https://bugzilla.novell.com/show_bug.cgi?id=805740
>> * http://thread.gmane.org/gmane.linux.kernel/1275165/focus=1388471
>>   refers to: http://bugs.debian.org/691902
>>
>> Both LKML threads seem to have died without any action being taken.
>>
>> Setting the RTC alarm time way in the future, as suggested in [2] didn't work for me.
>>
>> Output of dmidecode is attached. Please let me know if any other information could be useful.
>>
>> [1] https://github.com/torvalds/linux/commit/41c7f74
>> [2] https://forums.computers.toshiba-europe.com/forums/thread.jspa?messageID=256816
> Ok, sorry about this. I've been hoping we'd get some better insight into
> what's actually happening on these strange BIOSes where disabling the
> irq seems to cause it to scream (powering the system back on when its
> shutdown), in the hopes of having a proper workaround. But despite
> Borislav's efforts, he didn't seem to be able to root cause the issue.
>
> So sadly at this point I guess having the dmi based quirk is the only
> reasonable approach. The downside is it will end up killing alarm
> functionality on the hardware.
>
> Let me know if the following functions for you (I think I've added the
> quirk properly for your system, but am not sure).


Hey Brecht,
   Just wanted to follow up and see if you had a chance to try this patch?

thanks
-john

