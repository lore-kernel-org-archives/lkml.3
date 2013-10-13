Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114Ab3JMILQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 04:11:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6582 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753759Ab3JMILM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 04:11:12 -0400
Date: Sun, 13 Oct 2013 11:11:00 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de, x86@kernel.org,
        pbonzini@redhat.com, konrad.wilk@oracle.com,
        habanero@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, mtosatti@redhat.com,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] kvm fix: Enable pvspinlock after jump_label_init() to
 avoid VM hang
Message-ID: <20131013081059.GA15657@redhat.com>
References: <y>
 <1381309401-23663-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
 <525A5519.2050205@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <525A5519.2050205@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 13, 2013 at 01:38:57PM +0530, Raghavendra K T wrote:
> On 10/09/2013 02:33 PM, Raghavendra K T wrote:
> >We use jump label to enable pv-spinlock. With the changes in
> >(442e0973e927 Merge branch 'x86/jumplabel'), the jump label behaviour has changed
> >that would result in evntual hang of the VM since we would end up in a situation
> >where slowpath locks would halt the vcpus but we will not be able to wakeup the
> >vcpu by lock releaser using unlock kick.
> >
> >Similar problem in Xen and more detailed description is available in
> >a945928ea270 (xen: Do not enable spinlocks before jump_label_init() has executed)
> >
> >This patch splits kvm_spinlock_init to separate jump label changes with pvops
> >patching and also make jump label enabling after jump_label_init().
> >
> >Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
> 
> Ingo,
> Could you please take this fix?
> This is reviewed by Paolo and Steven.
It's KVM, I'll take it.

--
			Gleb.
