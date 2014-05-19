Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932161AbaESNaw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 09:30:52 -0400
Received: from mail.emea.novell.com ([130.57.118.101]:53723 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932080AbaESNav convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:12:2>);
	Mon, 19 May 2014 09:30:51 -0400
Message-Id: <537A23A50200007800013A7F@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.0 
Date: Mon, 19 May 2014 14:30:45 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Daniel Kiper" <daniel.kiper@oracle.com>
Cc: <david.vrabel@citrix.com>, <ian.campbell@citrix.com>,
        <stefano.stabellini@eu.citrix.com>, <jeremy@goop.org>,
        <matt.fleming@intel.com>, <x86@kernel.org>, <tglx@linutronix.de>,
        <xen-devel@lists.xenproject.org>, <boris.ostrovsky@oracle.com>,
        <konrad.wilk@oracle.com>, <eshelton@pobox.com>, <mingo@redhat.com>,
        <mjg59@srcf.ucam.org>, <linux-efi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [PATCH v4 1/5] efi: Introduce EFI_DIRECT flag
References: <1400272904-31121-1-git-send-email-daniel.kiper@oracle.com>
 <1400272904-31121-2-git-send-email-daniel.kiper@oracle.com>
In-Reply-To: <1400272904-31121-2-git-send-email-daniel.kiper@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 16.05.14 at 22:41, <daniel.kiper@oracle.com> wrote:
> @@ -457,6 +460,21 @@ void __init efi_free_boot_services(void)
>  	efi_unmap_memmap();
>  }
>  
> +static void __init __iomem *efi_early_ioremap(resource_size_t phys_addr,
> +							unsigned long size)
> +{
> +	if (efi_enabled(EFI_DIRECT))
> +		return early_ioremap(phys_addr, size);
> +
> +	return (__force void __iomem *)phys_addr;

Now that surely needs some explanation: I can't see how this can
ever be correct, Xen or not being completely irrelevant.

Jan

