Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758661Ab3FCPa1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 11:30:27 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:22173 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756139Ab3FCPaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 11:30:24 -0400
Date: Mon, 3 Jun 2013 11:28:00 -0400
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
Subject: Re: [PATCH RFC V9 2/19]  x86/ticketlock: Don't inline _spin_unlock
 when using paravirt spinlocks
Message-ID: <20130603152800.GA4224@phenom.dumpdata.com>
References: <20130601192125.5966.35563.sendpatchset@codeblue>
 <20130601192209.5966.46834.sendpatchset@codeblue>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130601192209.5966.46834.sendpatchset@codeblue>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 02, 2013 at 12:52:09AM +0530, Raghavendra K T wrote:
> x86/ticketlock: Don't inline _spin_unlock when using paravirt spinlocks
> 
> From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
> 
> The code size expands somewhat, and its better to just call
> a function rather than inline it.
> 
> Thanks Jeremy for original version of ARCH_NOINLINE_SPIN_UNLOCK config patch,
> which is simplified.
> 
> Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>

Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  arch/x86/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 685692c..80fcc4b 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -621,6 +621,7 @@ config PARAVIRT_DEBUG
>  config PARAVIRT_SPINLOCKS
>  	bool "Paravirtualization layer for spinlocks"
>  	depends on PARAVIRT && SMP
> +	select UNINLINE_SPIN_UNLOCK
>  	---help---
>  	  Paravirtualized spinlocks allow a pvops backend to replace the
>  	  spinlock implementation with something virtualization-friendly
> 
