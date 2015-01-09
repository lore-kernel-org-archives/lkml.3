Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757464AbbAIJ50 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 04:57:26 -0500
Received: from mail.emea.novell.com ([130.57.118.101]:41768 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756012AbbAIJ5V convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Fri, 9 Jan 2015 04:57:21 -0500
Message-Id: <54AFB410020000780005306E@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.1 
Date: Fri, 09 Jan 2015 09:57:20 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Juergen Gross" <JGross@suse.com>
Cc: <david.vrabel@citrix.com>, "xen-devel" <xen-devel@lists.xenproject.org>,
        <boris.ostrovsky@oracle.com>, <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 3/3] xen: use correct type for physical
 addresses
References: <1420736490-15351-1-git-send-email-jgross@suse.com>
 <1420736490-15351-4-git-send-email-jgross@suse.com>
In-Reply-To: <1420736490-15351-4-git-send-email-jgross@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 08.01.15 at 18:01, <JGross@suse.com> wrote:
> --- a/arch/x86/xen/setup.c
> +++ b/arch/x86/xen/setup.c
> @@ -140,7 +140,7 @@ static void __init xen_del_extra_mem(u64 start, u64 size)
>  unsigned long __ref xen_chk_extra_mem(unsigned long pfn)
>  {
>  	int i;
> -	unsigned long addr = PFN_PHYS(pfn);
> +	u64 addr = PFN_PHYS(pfn);

Isn't phys_addr_t the type to use here?

> @@ -284,7 +286,7 @@ static void __init xen_update_mem_tables(unsigned long pfn, unsigned long mfn)
>  	}
>  
>  	/* Update kernel mapping, but not for highmem. */
> -	if ((pfn << PAGE_SHIFT) >= __pa(high_memory))
> +	if (PFN_PHYS(pfn) >= (u64)(__pa(high_memory)))

I don't think you really need the cast on the right side - __pa()
should be returning a value of suitable type (and unsigned long
would be sufficient for anything up to and including high_memory).

Jan

