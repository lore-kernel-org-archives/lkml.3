Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261AbaBFSdx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 13:33:53 -0500
Received: from mail1.windriver.com ([147.11.146.13]:41456 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbaBFSdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 13:33:52 -0500
Message-ID: <52F3D583.9070208@windriver.com>
Date: Thu, 6 Feb 2014 13:33:39 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] nohz: ensure users are aware boot CPU is not NO_HZ_FULL
References: <1390929049-17758-1-git-send-email-paul.gortmaker@windriver.com> <20140129000630.GT9012@linux.vnet.ibm.com> <20140131163817.GC21061@localhost.localdomain>
In-Reply-To: <20140131163817.GC21061@localhost.localdomain>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-01-31 11:38 AM, Frederic Weisbecker wrote:
> On Tue, Jan 28, 2014 at 04:06:30PM -0800, Paul E. McKenney wrote:
>> On Tue, Jan 28, 2014 at 12:10:49PM -0500, Paul Gortmaker wrote:
>>> This bit of information is in the Kconfig help text:
>>>
>>>   Note the boot CPU will still be kept outside the range to
>>>   handle the timekeeping duty.
>>>
>>> However neither the variable NO_HZ_FULL_ALL, or the prompt
>>> convey this important detail, so lets add it to the prompt
>>> to make it more explicitly obvious to the average user.
>>>
>>> Cc: Frederic Weisbecker <fweisbec@gmail.com>
>>> Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
>>> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
>>
>> Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>>
>>> ---
>>>  kernel/time/Kconfig | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
>>> index 3ce6e8c5f3fc..76a1fbef1fd8 100644
>>> --- a/kernel/time/Kconfig
>>> +++ b/kernel/time/Kconfig
>>> @@ -124,7 +124,7 @@ config NO_HZ_FULL
>>>  endchoice
>>>
>>>  config NO_HZ_FULL_ALL
>>> -       bool "Full dynticks system on all CPUs by default"
>>> +       bool "Full dynticks system on all (but boot) CPUs by default"
> 
> Looks good. Now we are all using "boot CPU" to refer to the CPU 0, but it may
> not sound that obvious to everyone.
> 
> How about: "Full dynticks system on all CPUs by default (expect CPU 0)" ?

Sure, I'll send a v2 with the above, but I'll s/expect/except/   :)

Thanks,
Paul.
--

> 
> Sure this is a temporary behaviour until I get the sysidle detection use patchset in shape,
> but indeed worth a big fat warning until we sort it out.
> 
> Thanks!
> 
>>>         depends on NO_HZ_FULL
>>>         help
>>>           If the user doesn't pass the nohz_full boot option to
>>> -- 
>>> 1.8.5.2
>>>
>>
