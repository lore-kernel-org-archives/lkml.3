Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917AbaG1NOf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 09:14:35 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:64873 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703AbaG1NOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 09:14:32 -0400
X-IronPort-AV: E=Sophos;i="5.01,749,1400025600"; 
   d="scan'208";a="156891861"
Message-ID: <53D64CB5.4070703@citrix.com>
Date: Mon, 28 Jul 2014 14:14:29 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Matt Rushton <mvrushton@gmail.com>, <konrad.wilk@oracle.com>,
        <boris.ostrovsky@oracle.com>
CC: <msw@amazon.com>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xensource.com>, Matt Rushton <mrushton@amazon.com>
Subject: Re: [PATCH v2 1/2] xen/setup: Remove Identity Map Debug Message
References: <1405814495-10868-1-git-send-email-mrushton@amazon.com>
In-Reply-To: <1405814495-10868-1-git-send-email-mrushton@amazon.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/07/14 01:01, Matt Rushton wrote:
> Removing a debug message for setting the identity map since it becomes
> rather noisy after rework of the identity map code.

Reviewed-by: David Vrabel <david.vrabel@citrix.com>

David

> --- a/arch/x86/xen/p2m.c
> +++ b/arch/x86/xen/p2m.c
> @@ -841,10 +841,9 @@ unsigned long __init set_phys_range_identity(unsigned long pfn_s,
>  			pfn = ALIGN(pfn, P2M_PER_PAGE);
>  	}
>  
> -	if (!WARN((pfn - pfn_s) != (pfn_e - pfn_s),
> +	WARN((pfn - pfn_s) != (pfn_e - pfn_s),
>  		"Identity mapping failed. We are %ld short of 1-1 mappings!\n",
> -		(pfn_e - pfn_s) - (pfn - pfn_s)))
> -		printk(KERN_DEBUG "1-1 mapping on %lx->%lx\n", pfn_s, pfn);
> +		(pfn_e - pfn_s) - (pfn - pfn_s));
>  
>  	return pfn - pfn_s;
>  }
> 

