Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751192AbaALQyx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 11:54:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14201 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899AbaALQyv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 11:54:51 -0500
Date: Sat, 11 Jan 2014 10:27:23 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Hu Yaohui <loki2441@gmail.com>
Cc: kvm <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chen Fan <chen.fan.fnst@cn.fujitsu.com>, gleb@redhat.com,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] kvm: x86: Fix debug typo error in lapic
Message-ID: <20140111122723.GA11475@amt.cnet>
References: <1388654051-5968-1-git-send-email-chen.fan.fnst@cn.fujitsu.com>
 <20140108211009.GD20624@amt.cnet>
 <CAHqbYQt0ERa4kgK97D0NWZnZdF9TtdskaH0as7fZyO7N=5AzPw@mail.gmail.com>
 <20140108232527.GA17874@amt.cnet>
 <CAHqbYQu0rYfviVMJhgeEnBKYri5OVMA7XEp2ZCVGpvsiTYRJGg@mail.gmail.com>
 <CAHqbYQs0f5bH1Sg1emeFfUzJ0SEQBoVUx3jXhH=wa7VJdeccMQ@mail.gmail.com>
 <20140109184711.GB2309@amt.cnet>
 <CAHqbYQtUtLQ38zbycjhSz=WCt7x_panWHXWz5b8=ZwYnDFTXqw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHqbYQtUtLQ38zbycjhSz=WCt7x_panWHXWz5b8=ZwYnDFTXqw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 09, 2014 at 03:08:25PM -0500, Hu Yaohui wrote:
> Hi Marcelo,
> Thanks for your replying!
> I hope you have a good day! I am sorry that it's not that obvious to
> me after I checked that function.
> If the remote vcpu is not in the same pcpu as the sender which calls
> kvm_vpcu_kick.
> Before the remote vcpu received the Host-IPI, it could be in guest
> mode which could possibly access the stale tlb entry that have been
> modifed by the sender.
> 
> For smp_call_function_wait, the wait parameter will only let the
> sender side wait until the function has been executed on all the
> target cpus, then return.
> For TLB Flush IPI, the sender has already invalidate one tlb entry,
> the received side should get the IPI ASAP to invalidate the specified
> tlb before it's accessed, or there should have some mechanisms to
> enusre that even the stale tlb entry is accessed, it's still ok. I am
> not sure what's the situation here after I reviewed all the source
> codes.

The sender only considers the TLB entry (or entries) flushed when
smp_call_function_wait finishes, that is when the receiver cpu acknowledges
it has flushed its TLB.

