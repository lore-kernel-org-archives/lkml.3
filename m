Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102Ab3LKB0J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 20:26:09 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:55159 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782Ab3LKB0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 20:26:06 -0500
Message-ID: <52A7BF24.1080101@linaro.org>
Date: Wed, 11 Dec 2013 09:25:56 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mike Galbraith <bitbucket@online.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [question] sched: idle_avg and migration latency
References: <52A6FB5C.7010706@linaro.org> <1386688302.6304.30.camel@marge.simpson.net> <52A75DE6.8090901@linaro.org>
In-Reply-To: <52A75DE6.8090901@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2013 02:31 AM, Daniel Lezcano wrote:
>>
>> That has changed a little recently.  I originally slammed avg_idle
>> itself straight to max to ensure that a bursty load would idle balance,
>> and not use stale data.  If you start cross core switching at high
>> frequency, you'll still shut idle balancing quickly.
> 
> Ok, thanks for the explanation.
> 
> I think I am a bit puzzled with the 'idle_avg' name. I am guessing the
> semantic of this variable is "how long this cpu has been idle".
> 
> The idle duration, with the no_hz, could be long, several seconds if the
> work queues have been migrated and if the timer affinity is set to
> another cpu. So if we fall in this case and there is a burst of activity
> + micro-idle and idle_avg is not leverage to max, it will stay high
> during an amount of time, thus pulling tasks at each micro idle period,
> right ?

yes, I think so.

-- 
Thanks
    Alex
