Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022AbaBEGn5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 01:43:57 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:42680 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbaBEGn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 01:43:56 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-ef-52f1dda9e9d6
Message-id: <52F1DDA8.90605@samsung.com>
Date: Wed, 05 Feb 2014 10:43:52 +0400
From: Alexey Perevalov <a.perevalov@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623
 Thunderbird/17.0.7
MIME-version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        anton@enomsg.org, kyungmin.park@samsung.com, akpm@linux-foundation.org,
        cw00.choi@samsung.com
Subject: Re: [PATCH v2 0/3] Deferrable timers support for timerfd API
References: <1389609835-24377-1-git-send-email-a.perevalov@samsung.com>
 <52DEC6A3.9020600@linaro.org> <52E606D8.6000401@samsung.com>
 <alpine.DEB.2.02.1402041419420.24986@ionos.tec.linutronix.de>
In-reply-to: <alpine.DEB.2.02.1402041419420.24986@ionos.tec.linutronix.de>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrALMWRmVeSWpSXmKPExsVy+t/xa7or734MMtg9V8Vizvo1bBYHt2pa
	XP/ynNXizG9di7NNb9gtLu+aw2axedNUZgd2jwn9nxg97lzbw+bx7tw5do8TM36zePRtWcXo
	8XmTXABbFJdNSmpOZllqkb5dAlfG25c72ApaOSq+bTjI1sC4jq2LkZNDQsBEonnZNyhbTOLC
	vfVgtpDAUkaJ2Svkuxi5gOzPjBKr+9+AJXgFNCTez13BAmKzCKhKTFzcydzFyMHBJmAgse+e
	LYgpKhAhcXS5JkS1oMSPyffAqkWAOjdeusUMMpJZYCWjxNxvf9hBEsICrhIntq9nhdh1jFHi
	/J01zCAJTgEviRuf74J1MwtYS6yctI0RwpaX2LzmLfMERoFZSJbMQlI2C0nZAkbmVYyiqaXJ
	BcVJ6blGesWJucWleel6yfm5mxghof51B+PSY1aHGAU4GJV4eA2EPwYJsSaWFVfmHmKU4GBW
	EuFN7AYK8aYkVlalFuXHF5XmpBYfYmTi4JRqYAzMjzzfE5TIvP7i1KBjAQb8kzWtX0kF3Zkn
	WXf/oYuPlnBAbfNVVttt38s/e26SP1+3YIep5/TJa0WDpAU4r2v9ODPb4vDNE7nfjxvxZySy
	HU9is9iUeWGu4peJPfJXDBqfv208UspgV9yU3bN1R/FL+3uZy0M81vMwSmevTPy7xSRAzS8h
	RImlOCPRUIu5qDgRAKgp/FdTAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2014 08:10 PM, Thomas Gleixner wrote:
> On Mon, 27 Jan 2014, Alexey Perevalov wrote:
>> On 01/21/2014 11:12 PM, John Stultz wrote:
>>> Thomas: Any thought here? Should we be trying to unify the timerfd flags
>>> and the posix timer flags (specifically things like TIMER_CANCEL_ON_SET,
>>> which is currently timerfd-only)?  Should a deferrable flag be added to
>>> the hrtimer core or left to the timer wheel?
> The timer cancel on set was added only to timerfd because timerfd is a
> non posix interface and we are halfways free to add stuff to
> it. Adding extra flags to the real posix timer interfaces is a
> different story.
And what about "deferrable" possibility for hrtimers, do you consider it 
reasonable?

>
> What's the rationale for a deferrable flag for user space interfaces?
The main reason of this was do not call user space timers on system 
idle, to safe power on embedded systems, especially in case of NOHZ.

>
> Thanks,
>
> 	tglx
>


-- 
Best regards,
Alexey Perevalov
