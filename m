Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639AbaBTRh0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 12:37:26 -0500
Received: from g4t3425.houston.hp.com ([15.201.208.53]:2281 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434AbaBTRhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 12:37:22 -0500
Message-ID: <53063D4A.9010601@hp.com>
Date: Thu, 20 Feb 2014 12:37:14 -0500
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Daniel J Blueman <daniel@numascale.com>,
        Alexander Fyodorov <halcy@yandex.ru>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>,
        Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
Subject: Re: [PATCH v4 0/3] qspinlock: Introducing a 4-byte queue spinlock
References: <1392669684-4807-1-git-send-email-Waiman.Long@hp.com> <53029167.4060109@zytor.com> <20140218073111.GW27965@twins.programming.kicks-ass.net> <5303B4C4.2040907@hp.com> <20140218212827.GR14089@laptop.programming.kicks-ass.net> <5303FDEC.9060001@hp.com> <20140219085107.GG27965@twins.programming.kicks-ass.net> <53050501.3070101@hp.com> <20140219194832.GY14089@laptop.programming.kicks-ass.net>
In-Reply-To: <20140219194832.GY14089@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2014 02:48 PM, Peter Zijlstra wrote:
> On Wed, Feb 19, 2014 at 02:24:49PM -0500, Waiman Long wrote:
>> On 02/19/2014 03:51 AM, Peter Zijlstra wrote:
>>> On Tue, Feb 18, 2014 at 07:42:20PM -0500, Waiman Long wrote:
>>>> On 02/18/2014 04:28 PM, Peter Zijlstra wrote:
>>>>> On Tue, Feb 18, 2014 at 02:30:12PM -0500, Waiman Long wrote:
>>>>>> I will start looking at how to make it work with paravirt. Hopefully, it
>>>>>> won't take too long.
>>>>> The cheap way out is to simply switch to the test-and-set spinlock on
>>>>> whatever X86_FEATURE_ indicates a guest I suppose.
>>>> I don't think there is X86_FEATURE flag that indicates running in a guest.
>>>> In fact, a guest should never find out if it is running virtualized.
>>> No it very much should; how else is paravirt ever going to work?
>> We do have a CONFIG_PARAVIRT macro that turns on or off PV support. The
>> queue spinlock can be easily changed into an unfair lock which allows lock
>> stealing. We could have a config option to make it unfair in the PARAVIRT
>> environment, but I don't think Linus like the idea of an unfair lock.
> No; a guest is very much aware of paravirt. See for example the
> static_key_false(&paravirt_ticketlocks_enabled). It would be impossible
> to set that branch if you never knew you were a guest.

Yes, that is true for paravirt, but I was talking about virtualization 
in general.

-Longman
