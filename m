Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759114Ab3FCP7G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 11:59:06 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:40015 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759054Ab3FCP7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 11:59:03 -0400
Date: Mon, 3 Jun 2013 11:57:59 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: gleb@redhat.com, mingo@redhat.com, jeremy@goop.org, x86@kernel.org,
        hpa@zytor.com, pbonzini@redhat.com, linux-doc@vger.kernel.org,
        habanero@linux.vnet.ibm.com, xen-devel@lists.xensource.com,
        peterz@infradead.org, mtosatti@redhat.com,
        stefano.stabellini@eu.citrix.com, andi@firstfloor.org,
        attilio.rao@citrix.com, ouyang@cs.pitt.edu, gregkh@suse.de,
        agraf@suse.de, chegu_vinod@hp.com, torvalds@linux-foundation.org,
        avi.kivity@gmail.com, tglx@linutronix.de, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, stephan.diestelhorst@amd.com,
        riel@redhat.com, drjones@redhat.com,
        virtualization@lists.linux-foundation.org,
        srivatsa.vaddagiri@gmail.com
Subject: Re: [PATCH RFC V9 12/19]  xen: Enable PV ticketlocks on HVM Xen
Message-ID: <20130603155759.GE4224@phenom.dumpdata.com>
References: <20130601192125.5966.35563.sendpatchset@codeblue>
 <20130601192503.5966.70501.sendpatchset@codeblue>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130601192503.5966.70501.sendpatchset@codeblue>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 02, 2013 at 12:55:03AM +0530, Raghavendra K T wrote:
> xen: Enable PV ticketlocks on HVM Xen

There is more to it. You should also revert 70dd4998cb85f0ecd6ac892cc7232abefa432efb

> 
> From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
> ---
>  arch/x86/xen/smp.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
> index dcdc91c..8d2abf7 100644
> --- a/arch/x86/xen/smp.c
> +++ b/arch/x86/xen/smp.c
> @@ -682,4 +682,5 @@ void __init xen_hvm_smp_init(void)
>  	smp_ops.cpu_die = xen_hvm_cpu_die;
>  	smp_ops.send_call_func_ipi = xen_smp_send_call_function_ipi;
>  	smp_ops.send_call_func_single_ipi = xen_smp_send_call_function_single_ipi;
> +	xen_init_spinlocks();
>  }
> 
