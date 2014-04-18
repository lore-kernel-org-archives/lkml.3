Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457AbaDRRHj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 13:07:39 -0400
Received: from g2t2352.austin.hp.com ([15.217.128.51]:25892 "EHLO
	g2t2352.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbaDRRHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 13:07:33 -0400
Message-ID: <53515BC2.6000602@hp.com>
Date: Fri, 18 Apr 2014 13:07:14 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Paolo Bonzini <paolo.bonzini@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Oleg Nesterov <oleg@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Scott J Norton <scott.norton@hp.com>, Chegu Vinod <chegu_vinod@hp.com>
Subject: Re: [PATCH v9 03/19] qspinlock: Add pending bit
References: <1397747051-15401-1-git-send-email-Waiman.Long@hp.com> <1397747051-15401-4-git-send-email-Waiman.Long@hp.com> <20140417154200.GN11096@twins.programming.kicks-ass.net> <5350459F.5010903@hp.com> <20140418081345.GX11096@twins.programming.kicks-ass.net>
In-Reply-To: <20140418081345.GX11096@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2014 04:13 AM, Peter Zijlstra wrote:
> On Thu, Apr 17, 2014 at 05:20:31PM -0400, Waiman Long wrote:
>>>> +	while ((val = atomic_read(&lock->val))&   _Q_LOCKED_MASK)
>>>> +		arch_mutex_cpu_relax();
>>> That was a cpu_relax().
>> Yes, but arch_mutex_cpu_relax() is the same as cpu_relax() for x86.
> Yeah, so why bother typing more?
>
> Let the s390 people sort that if/when they try and make this work for
> them.

OK, I can revert the change if you wish. I have no objection for that.

-Longman
