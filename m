Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508Ab3HBCy1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 22:54:27 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:58714 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966Ab3HBCyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 22:54:25 -0400
Message-ID: <51FB20D0.5070306@linux.vnet.ibm.com>
Date: Fri, 02 Aug 2013 08:30:32 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Waiman Long <waiman.long@hp.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Richard Weinberger <richard@nod.at>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        George Spelvin <linux@horizon.com>,
        Harvey Harrison <harvey.harrison@gmail.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH RFC 1/2] qspinlock: Introducing a 4-byte queue spinlock
 implementation
References: <1375324631-32868-1-git-send-email-Waiman.Long@hp.com> <1375324631-32868-2-git-send-email-Waiman.Long@hp.com> <51FAC3BA.9050705@linux.vnet.ibm.com> <51FACE78.9070901@hp.com>
In-Reply-To: <51FACE78.9070901@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080202-6102-0000-0000-000003F54DA7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2013 02:39 AM, Waiman Long wrote:
> On 08/01/2013 04:23 PM, Raghavendra K T wrote:
>> On 08/01/2013 08:07 AM, Waiman Long wrote:
[..]
>>
>> Though I could see some gains in overcommit, but it hurted undercommit
>> in some workloads :(.
>
> The gcc 4.4.7 compiler that I used in my test machine has the tendency
> of allocating stack space for variables instead of using registers when
> a loop is present. So I try to avoid having loop in the fast path. Also
> the count itself is rather arbitrary. For the first pass, I would like
> to make thing simple. We can always enhance it once it is accepted and
> merged.

Yes. agree.

>>
>> I have not yet tested on bigger machine. I hope that bigger machine will
>> see significant undercommit improvements.
>>
>
> Thank for running the test. I am a bit confused about the terminology.
> What exactly do undercommit and overcommit mean?
>

Undercommit means I meant total #vcpu < #pcpus in virtual env. so
overcommit should not be an issue in baremetal.

