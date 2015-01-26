Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731AbbAZKMG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 05:12:06 -0500
Received: from smtp2.provo.novell.com ([137.65.250.81]:44741 "EHLO
	smtp2.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828AbbAZKME (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Mon, 26 Jan 2015 05:12:04 -0500
Message-ID: <1422267106.24914.11.camel@stgolabs.net>
Subject: Re: [PATCH] x86,xen: use current->state helpers
From: Davidlohr Bueso <dave@stgolabs.net>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org
Date: Mon, 26 Jan 2015 02:11:46 -0800
In-Reply-To: <1422267008.24914.10.camel@stgolabs.net>
References: <1422267008.24914.10.camel@stgolabs.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oops, cc'ing lkml.

On Mon, 2015-01-26 at 02:10 -0800, Davidlohr Bueso wrote:
> Call __set_current_state() instead of assigning the new state directly.
> These interfaces also aid CONFIG_DEBUG_ATOMIC_SLEEP environments,
> keeping track of who changed the state.
> 
> Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
> ---
>  arch/x86/xen/smp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
> index 4c071ae..08e8489 100644
> --- a/arch/x86/xen/smp.c
> +++ b/arch/x86/xen/smp.c
> @@ -507,7 +507,7 @@ static int xen_cpu_disable(void)
>  static void xen_cpu_die(unsigned int cpu)
>  {
>  	while (xen_pv_domain() && HYPERVISOR_vcpu_op(VCPUOP_is_up, cpu, NULL)) {
> -		current->state = TASK_UNINTERRUPTIBLE;
> +		__set_current_state(TASK_UNINTERRUPTIBLE);
>  		schedule_timeout(HZ/10);
>  	}
>  


