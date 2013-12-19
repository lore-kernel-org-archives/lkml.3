Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564Ab3LSSMB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 13:12:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53304 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754556Ab3LSSL7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 13:11:59 -0500
Message-ID: <52B336D4.8010809@redhat.com>
Date: Thu, 19 Dec 2013 13:11:32 -0500
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Tony Luck <tony.luck@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, X86-ML <x86@kernel.org>,
        Michel Lespinasse <walken@google.com>, Andi Kleen <ak@linux.intel.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        Yang Zhang <yang.z.zhang@intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>, janet.morgan@intel.com,
        "Yu, Fenghua" <fenghua.yu@intel.com>
Subject: Re: [PATCH] x86: Add check for number of available vectors before
 CPU down [v2]
References: <1387394945-5704-1-git-send-email-prarit@redhat.com>	<CA+8MBbKHZ0i0mEYLUrmWwaofvnRcxc7Dvm+w0CfZf2uQydjdjQ@mail.gmail.com> <CA+8MBbLMFW5fnUdgNRFpPv9+U1DqB5AeoDOV44kZHozibxjqSg@mail.gmail.com>
In-Reply-To: <CA+8MBbLMFW5fnUdgNRFpPv9+U1DqB5AeoDOV44kZHozibxjqSg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/19/2013 01:05 PM, Tony Luck wrote:
> On Wed, Dec 18, 2013 at 11:50 AM, Tony Luck <tony.luck@intel.com> wrote:
>> Looks good to me.
> 
> Though now I've been confused by an offline question about affinity.

Heh :)  I'm pursuing it now.  Rui has asked a pretty good question that I don't
know the answer to off the top of my head.  I'm still looking at the code.

> 
> Suppose we have some interrupt that has affinity to multiple cpus. E.g.
> (real example from one of my machines):
> 
> # cat /proc/irq/94/smp_affinity_list
> 26,54
> 
> Now If I want to take either cpu26 or cpu54 offline - I'm guessing that I don't
> really need to find a new home for vector 94 - because the other one of that
> pair already has that set up.  But your check_vectors code doesn't look like
> it accounts for that - if we take cpu26 offline - it would see that
> cpu54 doesn't
> have 94 free - but doesn't check that it is for the same interrupt.
> 
> But I may be mixing "vectors" and "irqs" here.

Yep.  The question really is this: is the irq mapped to a single vector or
multiple vectors. (I think)

P.

> 
> -Tony
