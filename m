Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759243Ab3DYTyV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 15:54:21 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:48497 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759139Ab3DYTyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 15:54:18 -0400
Message-ID: <517989E7.3040101@linaro.org>
Date: Thu, 25 Apr 2013 12:54:15 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Kay Sievers <kay@vrfy.org>
CC: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Alexander Holler <holler@ahsoftware.de>,
        LKML <linux-kernel@vger.kernel.org>, Feng Tang <feng.tang@intel.com>
Subject: Re: CONFIG_RTC_HCTOSYS lost on x86 with ALWAYS_USE_PERSISTENT_CLOCK
 changes?
References: <CAPXgP13kizK95JyLxKxgWrGnV9b11ZTyi3vuc5YFDmROzckg4w@mail.gmail.com> <517746E4.908@linaro.org> <CAPXgP128yAq1jju-gsZcaS-mZPt+7tq0tt-uVk3Yqr77abd26Q@mail.gmail.com> <51774F44.2060704@linaro.org> <517769A9.5060308@ahsoftware.de> <51780348.6090202@linaro.org> <5178D719.2060405@ahsoftware.de> <5179562C.3000903@linaro.org> <20130425183301.GA31863@obsidianresearch.com> <CAPXgP13PaBqtU+MQnz6fT+B18WJP3_tqSCv+OYA5W_z6F=VWdg@mail.gmail.com>
In-Reply-To: <CAPXgP13PaBqtU+MQnz6fT+B18WJP3_tqSCv+OYA5W_z6F=VWdg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2013 12:45 PM, Kay Sievers wrote:
> On Thu, Apr 25, 2013 at 8:33 PM, Jason Gunthorpe
> <jgunthorpe@obsidianresearch.com> wrote:
>> So, my conclusion is nobody with a RTC looking for space savings, will
>> disable CONFIG_RTC, which means we can safely rely on
>> CONFIG_RTC_SYSTOHC to do this work. To that end, I would encourage
>> everyone who sets CONFIG_GENERIC_CMOS_UPDATE to also set
>> CONFIG_RTC_SYSTOHC - that will let update_persistent_clock to be
>> ripped out over time without impacting users.
> John's original patch forcefully disabled CONFIG_RTC_SYSTOHC on x86,
> which is quite the opposite of what you recommend here. :)
>
> Could you guys both sort that out and give an idea what the
> recommended setup should look like today, ignoring all space saving
> and possible hctosys API changes caused by this. Should
> CONFIG_RTC_SYSTOHC be enabled or not?

Its fine if its enabled. We have logic in the kernel to do the right 
thing when we're on a system that has the persistent clock and also has 
SYSTOHC enabled.

My patch disabled SYSTOHC just to simplify some of the logic at build 
time, and in my mind, simplify the config choices.
But as much as I dislike needless config choices, I realize config churn 
isn't great either.

So I do think as we eventually consolidate the RTC and persistent_clock 
code, using SYSTOHC in the end is probably a good way to go (although we 
may drop the config and just always enable that logic).

That said, I suspect we need RTC equivalents to the xen/kvm/vrtc logic 
in the x86 persistent_clock code before we'll be able to tear out the 
persistent_clock code (I think just cmos and efi have RTC drivers).

thanks
-john

