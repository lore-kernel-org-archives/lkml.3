Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900Ab3IZITW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 04:19:22 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:39224 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550Ab3IZITT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 04:19:19 -0400
Message-ID: <5243EE02.9020207@linaro.org>
Date: Thu, 26 Sep 2013 10:19:14 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 19/21] cpuidle: create list of registered drivers
References: <cover.1379779777.git.viresh.kumar@linaro.org>	<7e9565e323c1e065eeb2a2a1075967bd21ee6066.1379779777.git.viresh.kumar@linaro.org>	<5243641B.6050604@linaro.org> <CAKohpo=3qFQ+gD+3u__NtZEL4xu51FBN+og+_UE7aTR26XvRng@mail.gmail.com>
In-Reply-To: <CAKohpo=3qFQ+gD+3u__NtZEL4xu51FBN+og+_UE7aTR26XvRng@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2013 08:17 AM, Viresh Kumar wrote:
> On 26 September 2013 04:00, Daniel Lezcano <daniel.lezcano@linaro.org> wrote:
>> If you introduce a list, you will have to introduce a lock to protect
>> it.
>
> I missed it, should have added that :)
>
>> This lock will be in the fast path cpuidle_idle_call with the
>> get_driver function and conforming to the comment: "NOTE: no locks or
>> semaphores should be used here".
>>
>> A lock has been introduced in this function already and the system hangs
>> with 1024 cpus.
>
> Hmm... I see.. I didn't knew about this expectation.. What about a rcu
> read/write lock? As far as I know its too lightweight... Can we have that
> in fast path?

Nope, we can't use rcu in the idle path :)

http://lists.infradead.org/pipermail/linux-arm-kernel/2012-February/083054.html


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

