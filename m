Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932Ab3JaLL2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 07:11:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54356 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751787Ab3JaLL0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 07:11:26 -0400
Message-ID: <52723AD9.4040902@redhat.com>
Date: Thu, 31 Oct 2013 12:11:21 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130923 Thunderbird/17.0.9
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
Subject: Re: [PATCH RFC] kvm: optimize out smp_mb using srcu_read_unlock
References: <20131030190929.GA7153@redhat.com> <20131030201552.GP4126@linux.vnet.ibm.com> <20131030232605.GA28823@redhat.com> <20131031045629.GT4126@linux.vnet.ibm.com> <20131031064743.GB20205@redhat.com>
In-Reply-To: <20131031064743.GB20205@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 31/10/2013 07:47, Gleb Natapov ha scritto:
> This looks dubious to me. All other smp_mb__after_* variants are there
> because some atomic operations have different memory barrier semantics on
> different arches,

It doesn't have to be arches; unlock APIs typically have release
semantics only, but SRCU is stronger.

> but srcu_read_unlock() have the same semantics on all
> arches, so smp_mb__after_srcu_read_unlock() becomes
> smp_mb__after_a_function_that_happens_to_have_mb_now_but_may_not_have_in_the_feature().
> How likely it is that smp_mb() will disappear from srcu_read_unlock()
> (if was added for a reason I guess)?  May be we should change documentation
> to say that srcu_read_unlock() is a memory barrier which will reflect
> the reality.

That would be different from all other unlock APIs.

Paolo
