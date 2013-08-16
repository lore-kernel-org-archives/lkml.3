Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375Ab3HPMnz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 08:43:55 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:18455 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836Ab3HPMny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 08:43:54 -0400
Date: Fri, 16 Aug 2013 08:43:28 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Vaughan Cao <vaughan.cao@oracle.com>
Cc: jeremy@goop.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xen: initialize xen panic handler for PVHVM
Message-ID: <20130816124327.GC10190@konrad-lan.dumpdata.com>
References: <1376640656-32381-1-git-send-email-vaughan.cao@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376640656-32381-1-git-send-email-vaughan.cao@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 16, 2013 at 04:10:56PM +0800, Vaughan Cao wrote:
> kernel use callback linked in panic_notifier_list to notice others when panic
> happens.
> NORET_TYPE void panic(const char * fmt, ...){
>     ...
>     atomic_notifier_call_chain(&panic_notifier_list, 0, buf);
> }
> When xen aware this, it will call xen_reboot(SHUTDOWN_crash) to send out an
  ^^^^^^^^^^^^^^^^^^^-> "When Xen becomes aware of this"

> event with reason code - SHUTDOWN_crash.
> xen_panic_handler_init() is defined to register on panic_notifier_list but
> we only call it in xen_arch_setup which only be called by pvm, this patch is
                                          ^^^^^^^-> "is only"
>  necessary for pvhvm.

Could you tell me what has been happening without this patch?

Thank you.

> 
> Signed-off-by: Vaughan Cao <vaughan.cao@oracle.com>
> ---
>  arch/x86/xen/enlighten.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> index 4aec5ed..53e5726 100644
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -1713,6 +1713,8 @@ static void __init xen_hvm_guest_init(void)
>  
>  	xen_hvm_init_shared_info();
>  
> +	xen_panic_handler_init();
> +
>  	if (xen_feature(XENFEAT_hvm_callback_vector))
>  		xen_have_vector_callback = 1;
>  	xen_hvm_smp_init();
> -- 
> 1.7.11.7
> 
