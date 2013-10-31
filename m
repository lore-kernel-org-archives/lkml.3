Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321Ab3JaM2l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 08:28:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57688 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751817Ab3JaM2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 08:28:40 -0400
Date: Thu, 31 Oct 2013 14:28:36 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
Subject: Re: [PATCH RFC] kvm: optimize out smp_mb using srcu_read_unlock
Message-ID: <20131031122836.GQ4651@redhat.com>
References: <20131030190929.GA7153@redhat.com>
 <20131030201552.GP4126@linux.vnet.ibm.com>
 <20131030232605.GA28823@redhat.com>
 <20131031045629.GT4126@linux.vnet.ibm.com>
 <20131031064743.GB20205@redhat.com>
 <52723AD9.4040902@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52723AD9.4040902@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 31, 2013 at 12:11:21PM +0100, Paolo Bonzini wrote:
> Il 31/10/2013 07:47, Gleb Natapov ha scritto:
> > This looks dubious to me. All other smp_mb__after_* variants are there
> > because some atomic operations have different memory barrier semantics on
> > different arches,
> 
> It doesn't have to be arches; 
Of course it doesn't, but it is now :)

>                               unlock APIs typically have release
> semantics only, but SRCU is stronger.
> 
Yes the question is if it is by design or implementation detail we should
not rely on.

> > but srcu_read_unlock() have the same semantics on all
> > arches, so smp_mb__after_srcu_read_unlock() becomes
> > smp_mb__after_a_function_that_happens_to_have_mb_now_but_may_not_have_in_the_feature().
> > How likely it is that smp_mb() will disappear from srcu_read_unlock()
> > (if was added for a reason I guess)?  May be we should change documentation
> > to say that srcu_read_unlock() is a memory barrier which will reflect
> > the reality.
> 
> That would be different from all other unlock APIs.
> 
As long as it is documented... smp_mb__after_srcu_read_unlock() is just
a form of documentation anyway right now. I do not have strong objection
to smp_mb__after_srcu_read_unlock() though, the improvement is impressive
for such a small change.

--
			Gleb.
