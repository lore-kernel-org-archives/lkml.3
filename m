Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751384AbaFWHTO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 03:19:14 -0400
Received: from mail.emea.novell.com ([130.57.118.101]:58688 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbaFWHTM convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:12:2>);
	Mon, 23 Jun 2014 03:19:12 -0400
Message-Id: <53A7F104020000780001C4BE@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.0 
Date: Mon, 23 Jun 2014 08:19:00 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Daniel Kiper" <daniel.kiper@oracle.com>
Cc: <andrew.cooper3@citrix.com>, <david.vrabel@citrix.com>,
        <ian.campbell@citrix.com>, <stefano.stabellini@eu.citrix.com>,
        <jeremy@goop.org>, <matt.fleming@intel.com>, <x86@kernel.org>,
        <tglx@linutronix.de>, <xen-devel@lists.xenproject.org>,
        <boris.ostrovsky@oracle.com>, <konrad.wilk@oracle.com>,
        <eshelton@pobox.com>, <mingo@redhat.com>, <mjg59@srcf.ucam.org>,
        <linux-efi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <hpa@zytor.com>
Subject: Re: [PATCH v6 1/9] efi: Use early_mem*() instead of
 early_io*()
References: <1403299768-9955-1-git-send-email-daniel.kiper@oracle.com>
 <1403299768-9955-2-git-send-email-daniel.kiper@oracle.com>
In-Reply-To: <1403299768-9955-2-git-send-email-daniel.kiper@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 20.06.14 at 23:29, <daniel.kiper@oracle.com> wrote:
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -298,7 +298,7 @@ int __init efi_config_init(efi_config_table_type_t *arch_tables)
>  			if (table64 >> 32) {
>  				pr_cont("\n");
>  				pr_err("Table located above 4GB, disabling EFI.\n");
> -				early_iounmap(config_tables,
> +				early_memunmap(config_tables,
>  					       efi.systab->nr_tables * sz);
>  				return -EINVAL;
>  			}
> @@ -314,7 +314,7 @@ int __init efi_config_init(efi_config_table_type_t *arch_tables)
>  		tablep += sz;
>  	}
>  	pr_cont("\n");
> -	early_iounmap(config_tables, efi.systab->nr_tables * sz);
> +	early_memunmap(config_tables, efi.systab->nr_tables * sz);
>  
>  	set_bit(EFI_CONFIG_TABLES, &efi.flags);
>  

If these two changes are really deemed necessary (there's the
implied assumption currently in place that early_iounmap() can
undo early_memremap() mappings), then ia64 will need a
definition added for early_memunmap() or its build will break.

Jan

