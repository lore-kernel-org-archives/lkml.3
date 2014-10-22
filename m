Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446AbaJVOpI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 10:45:08 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:62842 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbaJVOpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 10:45:06 -0400
Message-ID: <5447C2ED.5020707@linaro.org>
Date: Wed, 22 Oct 2014 16:45:01 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Steven Rostedt <rostedt@goodmis.org>, Dave Jones <davej@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Nicolas Pitre <nico@linaro.org>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: lockdep splat in CPU hotplug
References: <alpine.LNX.2.00.1410211255531.24255@pobox.suse.cz> <alpine.LNX.2.00.1410221125280.22681@pobox.suse.cz> <5447BEFE.2040806@linaro.org> <alpine.LNX.2.00.1410221634550.22681@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1410221634550.22681@pobox.suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2014 04:36 PM, Jiri Kosina wrote:
> On Wed, 22 Oct 2014, Daniel Lezcano wrote:
>
>>>> I am seeing the lockdep report below when resuming from suspend-to-disk
>>>> with current Linus' tree (c2661b80609).
>>>>
>>>> The reason for CCing Ingo and Peter is that I can't make any sense of one
>>>> of the stacktraces lockdep is providing.
>>>>
>>>> Please have a look at the very first stacktrace in the dump, where lockdep
>>>> is trying to explain where cpu_hotplug.lock#2 has been acquired. It seems
>>>> to imply that cpuidle_pause() is taking cpu_hotplug.lock, but that's not
>>>> the case at all.
>>>>
>>>> What am I missing?
>>>
>>> Okay, reverting 442bf3aaf55a ("sched: Let the scheduler see CPU idle
>>> states") and followup 83a0a96a5f26 ("sched/fair: Leverage the idle state
>>> info when choosing the "idlest" cpu") which depends on it makes the splat
>>> go away.
>>
>> Are you able to reproduce it by offlining the cpu and onlining it again ?
>
> No, that doesn't trigger it (please note that all the relevant stacktraces
> from lockdep are going through hibernation).

Ok, thanks.


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

