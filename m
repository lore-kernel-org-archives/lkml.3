Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841AbaG1NhV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 09:37:21 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:25699 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102AbaG1NhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 09:37:20 -0400
X-IronPort-AV: E=Sophos;i="5.01,749,1400025600"; 
   d="scan'208";a="156898285"
Message-ID: <53D651EF.8080807@citrix.com>
Date: Mon, 28 Jul 2014 14:36:47 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Vitaly Kuznetsov <vkuznets@redhat.com>, <xen-devel@lists.xenproject.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Andrew Jones <drjones@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC 2/4] xen/pvhvm: Introduce xen_pvhvm_kexec_shutdown()
References: <1405431640-649-1-git-send-email-vkuznets@redhat.com> <1405431640-649-3-git-send-email-vkuznets@redhat.com>
In-Reply-To: <1405431640-649-3-git-send-email-vkuznets@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/07/14 14:40, Vitaly Kuznetsov wrote:
> PVHVM guest requires special actions before kexec. Register specific
> xen_pvhvm_kexec_shutdown() handler for machine_ops.shutdown().
[...]
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -1833,6 +1833,12 @@ static struct notifier_block xen_hvm_cpu_notifier = {
>  	.notifier_call	= xen_hvm_cpu_notify,
>  };
>  
> +static void xen_pvhvm_kexec_shutdown(void)
> +{
> +	xen_kexec_shutdown();

I think it would be preferrable to have

    if (kexec_in_progress)
        xen_kexec_shutdown();

David
