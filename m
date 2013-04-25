Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932363Ab3DYBir (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 21:38:47 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:31176 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932154Ab3DYBip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 21:38:45 -0400
Message-ID: <5178890E.9090201@huawei.com>
Date: Thu, 25 Apr 2013 09:38:22 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: Prarit Bhargava <prarit@redhat.com>, John Stultz <john.stultz@linaro.org>,
        <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] hrtimer, add expiry time overflow check in hrtimer_interrupt
References: <1365425235-26191-1-git-send-email-prarit@redhat.com> <5163264B.3050707@linaro.org> <516329D2.1050003@redhat.com> <20130424224218.GA7767@roeck-us.net>
In-Reply-To: <20130424224218.GA7767@roeck-us.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/4/25 6:42, Guenter Roeck wrote:
> On Mon, Apr 08, 2013 at 04:34:26PM -0400, Prarit Bhargava wrote:
>>
>>
>> On 04/08/2013 04:19 PM, John Stultz wrote:
>>> On 04/08/2013 05:47 AM, Prarit Bhargava wrote:
>>
>>>>
>>>> A simple check for an overflow can resolve this problem.  Using KTIME_MAX
>>>> instead of the overflow value will result in the hrtimer function being run,
>>>> and the reprogramming of the timer after that.
>>>>
>>>> Signed-off-by: Prarit Bhargava <prarit@redhat.com>
>>>> Cc: Thomas Gleixner <tglx@linutronix.de>
>>>> Cc: John Stultz <john.stultz@linaro.org>
>>>
>>> Prarit: Should this be tagged for -stable?
>>
>> John,
>>
>> Yes, this should go to -stable.  cc'd.
>>
> Hi,
> 
> I am a bit surprised that this patch has not found its way into mainline yet,
> as everyone seems to agree that it is a candidate for -stable.
> 
> I hit this problem very reliably (ie with each boot) with 3.8.x on systems
> which have no RTC and run systemd. Seen with Freescale P5040 as well as
> a Broadcom MIPS based system.
> 

FYI, we also hit this warning with 3.4-rt.

