Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237AbaBSVat (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 16:30:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59253 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751858AbaBSVas (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 16:30:48 -0500
Message-ID: <5305222B.4080706@zytor.com>
Date: Wed, 19 Feb 2014 13:29:15 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Waiman Long <waiman.long@hp.com>, Peter Zijlstra <peterz@infradead.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
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
References: <1392669684-4807-1-git-send-email-Waiman.Long@hp.com> <53029167.4060109@zytor.com> <20140218073111.GW27965@twins.programming.kicks-ass.net> <5303B4C4.2040907@hp.com> <20140218212827.GR14089@laptop.programming.kicks-ass.net> <5303FDEC.9060001@hp.com> <20140219085107.GG27965@twins.programming.kicks-ass.net> <53050501.3070101@hp.com>
In-Reply-To: <53050501.3070101@hp.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2014 11:24 AM, Waiman Long wrote:
> On 02/19/2014 03:51 AM, Peter Zijlstra wrote:
>> On Tue, Feb 18, 2014 at 07:42:20PM -0500, Waiman Long wrote:
>>> On 02/18/2014 04:28 PM, Peter Zijlstra wrote:
>>>> On Tue, Feb 18, 2014 at 02:30:12PM -0500, Waiman Long wrote:
>>>>> I will start looking at how to make it work with paravirt.
>>>>> Hopefully, it
>>>>> won't take too long.
>>>> The cheap way out is to simply switch to the test-and-set spinlock on
>>>> whatever X86_FEATURE_ indicates a guest I suppose.
>>> I don't think there is X86_FEATURE flag that indicates running in a
>>> guest.
>>> In fact, a guest should never find out if it is running virtualized.
>> No it very much should; how else is paravirt ever going to work?
> 
> We do have a CONFIG_PARAVIRT macro that turns on or off PV support. The
> queue spinlock can be easily changed into an unfair lock which allows
> lock stealing. We could have a config option to make it unfair in the
> PARAVIRT environment, but I don't think Linus like the idea of an unfair
> lock.
> 

The case where we run native on a system with CONFIG_PARAVIRT enabled
DOES matter.

	-hpa


