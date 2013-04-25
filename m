Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758834Ab3DYQNg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 12:13:36 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:37467 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757220Ab3DYQNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 12:13:35 -0400
Message-ID: <5179562C.3000903@linaro.org>
Date: Thu, 25 Apr 2013 09:13:32 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Alexander Holler <holler@ahsoftware.de>
CC: Kay Sievers <kay@vrfy.org>, LKML <linux-kernel@vger.kernel.org>,
        Feng Tang <feng.tang@intel.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: CONFIG_RTC_HCTOSYS lost on x86 with ALWAYS_USE_PERSISTENT_CLOCK
 changes?
References: <CAPXgP13kizK95JyLxKxgWrGnV9b11ZTyi3vuc5YFDmROzckg4w@mail.gmail.com> <517746E4.908@linaro.org> <CAPXgP128yAq1jju-gsZcaS-mZPt+7tq0tt-uVk3Yqr77abd26Q@mail.gmail.com> <51774F44.2060704@linaro.org> <517769A9.5060308@ahsoftware.de> <51780348.6090202@linaro.org> <5178D719.2060405@ahsoftware.de>
In-Reply-To: <5178D719.2060405@ahsoftware.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2013 12:11 AM, Alexander Holler wrote:
> Am 24.04.2013 18:07, schrieb John Stultz:
>
>>> And why is RTC_SYSTOHC now gone on x86?
>>
>> So summarizing the above, because as much as I'm aware, its always been
>> redundant and unnecessary on x86.  Thus being able at build time to mark
>> it as unnecessary was attractive, since it reduced the code paths
>> running at suspend/resume.
>
> Hmm, I thought RTC_SYSTOHC was there to update the used RTC clock with 
> the time from NTP (and liked that). Therefor I don't understand why it 
> is redundant and unnecessary on x86. Of course, most systems do have 
> something in userspace to set the RTC on shutdown, so it isn't really 
> needed.

Prior to SYSTOHC being introduced, we only synced system time to the RTC 
via update_persistent_clock() on systems that had that interface. 
SYSTOHC is relatively new and lets the system sync to RTCs that don't 
have the persistent clock.

thanks
-john

