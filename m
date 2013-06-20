Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935500Ab3FTO15 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 10:27:57 -0400
Received: from 8bytes.org ([85.214.48.195]:35141 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935359Ab3FTO14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 10:27:56 -0400
Date: Thu, 20 Jun 2013 16:27:52 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Fedora Kernel Team <kernel-team@fedoraproject.org>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] intel_iommu: Downgrade the warning if enabling irq
 remapping fails
Message-ID: <20130620142752.GA3496@8bytes.org>
References: <20130513220444.GA22440@redhat.com>
 <cae6129769f80ed16f30118dc19ff10ba5d63fde.1368483649.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cae6129769f80ed16f30118dc19ff10ba5d63fde.1368483649.git.luto@amacapital.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Thu Jun 20 16:27:54 2013
X-DSPAM-Confidence: 0.9991
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 51c3116a20864497013954
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 13, 2013 at 03:22:42PM -0700, Andy Lutomirski wrote:
> This triggers on a MacBook Pro.
> 
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> https://bugzilla.redhat.com/show_bug.cgi?id=948262
> ---
>  drivers/iommu/intel_irq_remapping.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
> index f3b8f23..a7e0ad1 100644
> --- a/drivers/iommu/intel_irq_remapping.c
> +++ b/drivers/iommu/intel_irq_remapping.c
> @@ -654,8 +654,7 @@ error:
>  	 */
>  
>  	if (x2apic_present)
> -		WARN(1, KERN_WARNING
> -			"Failed to enable irq remapping.  You are vulnerable to irq-injection attacks.\n");
> +		pr_warn("Failed to enable irq remapping.  You are vulnerable to irq-injection attacks.\n");
>  
>  	return -1;
>  }
> -- 
> 1.8.1.4

Applied to x86/vt-d, thanks.


