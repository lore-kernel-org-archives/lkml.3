Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932529Ab3AYSHe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 13:07:34 -0500
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:36257 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932338Ab3AYSHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 13:07:31 -0500
Date: Fri, 25 Jan 2013 10:07:31 -0800
From: Dmitry Torokhov <dtor@vmware.com>
To: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        X86 ML <x86@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, devel@linuxdriverproject.org,
        olaf@aepfle.de, apw@canonical.com, jasowang@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>, JBeulich@suse.com,
        Borislav Petkov <bp@suse.de>, "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH -v2 2/2] x86: Make Linux guest support optional
Message-ID: <20130125180730.GA29810@dtor-ws.eng.vmware.com>
References: <20130125100655.GC23404@pd.tnic>
 <1359136777-4512-2-git-send-email-bp@alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359136777-4512-2-git-send-email-bp@alien8.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Borislav,

On Fri, Jan 25, 2013 at 06:59:37PM +0100, Borislav Petkov wrote:
> diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
> index 8e1a9ec53003..cb467656e684 100644
> --- a/drivers/hv/vmbus_drv.c
> +++ b/drivers/hv/vmbus_drv.c
> @@ -724,7 +724,7 @@ static int __init hv_acpi_init(void)
>  {
>  	int ret, t;
>  
> -	if (x86_hyper != &x86_hyper_ms_hyperv)
> +	if (!x86_hyper || strncmp(x86_hyper->name, "VMware", 6))
>  		return -ENODEV;

I assume this is a typo as I doubt MS is using the same signature as we
do.

>  
>  	init_completion(&probe_event);
> diff --git a/drivers/misc/vmw_balloon.c b/drivers/misc/vmw_balloon.c
> index cb56e270da11..85f15a6d8798 100644
> --- a/drivers/misc/vmw_balloon.c
> +++ b/drivers/misc/vmw_balloon.c
> @@ -786,7 +786,7 @@ static int __init vmballoon_init(void)
>  	 * Check if we are running on VMware's hypervisor and bail out
>  	 * if we are not.
>  	 */
> -	if (x86_hyper != &x86_hyper_vmware)
> +	if (!x86_hyper || strncmp(x86_hyper->name, "VMware", 6))
>  		return -ENODEV;
>

I wonder why you decided to switch from address matching (which is quite
precise and would potentially allow adding signatures without needing
to change the drivers) to string matching?

Thanks,
Dmitry
