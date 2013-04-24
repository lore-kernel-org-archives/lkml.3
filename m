Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757317Ab3DXQm0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 12:42:26 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:51076 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755277Ab3DXQmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 12:42:24 -0400
Message-ID: <51780B6B.1040205@linaro.org>
Date: Wed, 24 Apr 2013 09:42:19 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Kay Sievers <kay@vrfy.org>
CC: Alexander Holler <holler@ahsoftware.de>,
        LKML <linux-kernel@vger.kernel.org>, Feng Tang <feng.tang@intel.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: CONFIG_RTC_HCTOSYS lost on x86 with ALWAYS_USE_PERSISTENT_CLOCK
 changes?
References: <CAPXgP13kizK95JyLxKxgWrGnV9b11ZTyi3vuc5YFDmROzckg4w@mail.gmail.com> <517746E4.908@linaro.org> <CAPXgP128yAq1jju-gsZcaS-mZPt+7tq0tt-uVk3Yqr77abd26Q@mail.gmail.com> <51774F44.2060704@linaro.org> <517769A9.5060308@ahsoftware.de> <51780348.6090202@linaro.org> <CAPXgP10OJGHwZZHCtUMZfnSzj2cKJmg6NGg2pPKiuHWPKuuo-Q@mail.gmail.com>
In-Reply-To: <CAPXgP10OJGHwZZHCtUMZfnSzj2cKJmg6NGg2pPKiuHWPKuuo-Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2013 09:32 AM, Kay Sievers wrote:
> On Wed, Apr 24, 2013 at 6:07 PM, John Stultz <john.stultz@linaro.org> wrote:
>
>> So summarizing the above, because as much as I'm aware, its always been
>> redundant and unnecessary on x86.  Thus being able at build time to mark it
>> as unnecessary was attractive, since it reduced the code paths running at
>> suspend/resume.
>>
>> That said, Kay's concerns about userland implications (basically the
>> userland side effects of SYSTOHC being enabled) give me pause, so I may
>> revert the HAS_PERSISTENT_CLOCK on x86 change.
> Thanks a lot for all the missing details!
>
> No, I think that all makes too much sense to revert it. Let's just
> find a way to solve it properly. I don't think it is of any pressing
> importance to keep the old behaviour, if we can still provide the
> functionality today.

So some compile time optimizations for code that likely needs to be 
reworked anyway aren't worth the risk of breaking userland to me. Let me 
pull these out (on the kernel side, the same code paths will run, we 
just avoid some extra checks) so the hctosys flag doesn't change in 
distro configs that expect it.

thanks
-john

