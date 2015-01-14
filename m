Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219AbbANRfq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 12:35:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35173 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145AbbANRfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 12:35:44 -0500
Message-ID: <54B6A8DF.3070806@redhat.com>
Date: Wed, 14 Jan 2015 18:35:27 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>, linux-kernel@vger.kernel.org,
        linux-rt-users@vger.kernel.org
CC: Luiz Capitulino <lcapitulino@redhat.com>, Rik van Riel <riel@redhat.com>,
        Steven Rostedt <srostedt@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org
Subject: Re: [patch -rt 0/2] use simple waitqueue for kvm vcpu waitqueue (v3)
References: <20150114171251.882318257@redhat.com>
In-Reply-To: <20150114171251.882318257@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 14/01/2015 18:12, Marcelo Tosatti wrote:
> Against v3.14-rt branch of 
> git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git
> 
> The problem:
> 
> On -RT, an emulated LAPIC timer instance has the following path:
> 
> 1) hard interrupt
> 2) ksoftirqd is scheduled
> 3) ksoftirqd wakes up vcpu thread
> 4) vcpu thread is scheduled
> 
> This extra context switch introduces unnecessary latency in the
> LAPIC path for a KVM guest.
> 
> The solution:
> 
> Allow waking up vcpu thread from hardirq context,
> thus avoiding the need for ksoftirqd to be scheduled.
> 
> Normal waitqueues make use of spinlocks, which on -RT
> are sleepable locks. Therefore, waking up a waitqueue
> waiter involves locking a sleeping lock, which
> is not allowed from hard interrupt context.
> 
> cyclictest command line:
> # cyclictest -m -n -q -p99 -l 1000000 -h60  -D 1m
> 
> This patch reduces the average latency in my tests from 14us to 11us.
> 
> v2: improve changelog (Rik van Riel)
> v3: limit (once) guest triggered printk and WARN_ON (Paolo Bonzini)
> 
> 

Looks good.

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
