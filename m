Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456Ab3JJOnw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 10:43:52 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:46948 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754871Ab3JJOnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 10:43:49 -0400
Date: Thu, 10 Oct 2013 10:43:43 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: <mingo@redhat.com>, <hpa@zytor.com>, <x86@kernel.org>, <gleb@redhat.com>,
        <pbonzini@redhat.com>, <tglx@linutronix.de>, <konrad.wilk@oracle.com>,
        <habanero@linux.vnet.ibm.com>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <mtosatti@redhat.com>
Subject: Re: [PATCH] kvm fix: Enable pvspinlock after jump_label_init() to
 avoid VM hang
Message-ID: <20131010104343.310b9c21@gandalf.local.home>
In-Reply-To: <1381309401-23663-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
References: <y>
	<1381309401-23663-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  9 Oct 2013 14:33:21 +0530
Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com> wrote:

> We use jump label to enable pv-spinlock. With the changes in
> (442e0973e927 Merge branch 'x86/jumplabel'), the jump label behaviour has changed
> that would result in evntual hang of the VM since we would end up in a situation
> where slowpath locks would halt the vcpus but we will not be able to wakeup the
> vcpu by lock releaser using unlock kick.
> 
> Similar problem in Xen and more detailed description is available in
> a945928ea270 (xen: Do not enable spinlocks before jump_label_init() has executed)
> 
> This patch splits kvm_spinlock_init to separate jump label changes with pvops
> patching and also make jump label enabling after jump_label_init().
> 
> Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>

Reviewed-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> ---
>  Thanks to Andrew Theurer who reported weird behaviour of pvspinlock
>  in 3.12-rc that led to my git bisection and investigation and Konrad
>  for his jump label findings for Xen.
> 
>  arch/x86/kernel/kvm.c | 17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
> 
