Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022AbbAMJwY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 04:52:24 -0500
Received: from smtp.citrix.com ([66.165.176.89]:10991 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751129AbbAMJwV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 04:52:21 -0500
X-IronPort-AV: E=Sophos;i="5.07,748,1413244800"; 
   d="scan'208";a="215246477"
Message-ID: <54B4EAC7.2080105@citrix.com>
Date: Tue, 13 Jan 2015 09:52:07 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Imre Palik <imrep.amz@gmail.com>, <xen-devel@lists.xenproject.org>,
        David Vrabel <david.vrabel@citrix.com>
CC: "Palik, Imre" <imrep@amazon.de>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Anthony Liguori <aliguori@amazon.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Xen-devel] [PATCH] xen-time: decreasing the rating of the xen
 clocksource below that of the tsc clocksource for dom0's
References: <1421136862-15083-1-git-send-email-imrep.amz@gmail.com>
In-Reply-To: <1421136862-15083-1-git-send-email-imrep.amz@gmail.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/01/15 08:14, Imre Palik wrote:
> From: "Palik, Imre" <imrep@amazon.de>
> 
> In Dom0's the use of the TSC clocksource (whenever it is stable enough to
> be used) instead of the Xen clocksource should not cause any issues, as
> Dom0 VMs never live-migrated.  The TSC clocksource is somewhat more
> efficient than the Xen paravirtualised clocksource, thus it should have
> higher rating.
> 
> This patch decreases the rating of the Xen clocksource in Dom0s to 275.
> Which is half-way between the rating of the TSC clocksource (300) and the
> hpet clocksource (250).

I'm happy with this but would like to see acks from those who objected
to v1.

David

> --- a/arch/x86/xen/time.c
> +++ b/arch/x86/xen/time.c
> @@ -487,6 +487,10 @@ static void __init xen_time_init(void)
>  	int cpu = smp_processor_id();
>  	struct timespec tp;
>  
> +	/* As Dom0 is never moved, no penalty on using TSC there */
> +	if (xen_initial_domain())
> +		xen_clocksource.rating = 275;
> +
>  	clocksource_register_hz(&xen_clocksource, NSEC_PER_SEC);
>  
>  	if (HYPERVISOR_vcpu_op(VCPUOP_stop_periodic_timer, cpu, NULL) == 0) {
> 

