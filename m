Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106AbbAUAXQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 19:23:16 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:49974 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751037AbbAUAXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 19:23:15 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Bjorn Helgaas <bhelgaas@google.com>,
        Yinghai Lu <yinghai@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Len Brown <lenb@kernel.org>, Tony Luck <tony.luck@intel.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [RFC Patch 12/19] ACPI: Enforce stricter checks for address space descriptors
Date: Wed, 21 Jan 2015 01:45:50 +0100
Message-ID: <12267175.FvlCJYWCa5@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1420684386-5975-13-git-send-email-jiang.liu@linux.intel.com>
References: <1420684386-5975-1-git-send-email-jiang.liu@linux.intel.com> <1420684386-5975-13-git-send-email-jiang.liu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 08, 2015 10:32:59 AM Jiang Liu wrote:
> Enforce stricter checks for address space descriptors according to
> ACPI spec.

So is the spec the only reason for doing this?  If so, I'd say don't.

> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> ---
>  drivers/acpi/resource.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
> index 26b47f1da523..e82149e44347 100644
> --- a/drivers/acpi/resource.c
> +++ b/drivers/acpi/resource.c
> @@ -192,6 +192,14 @@ static bool acpi_decode_space(struct resource *res,
>  	bool wp = base->info.mem.write_protect;
>  	u64 len = addr->address_length;
>  
> +	/*
> +	 * Filter out invalid descriptor according to ACPI Spec 5.0, section
> +	 * 6.4.3.5 Address Space Resource Descriptors.
> +	 */
> +	if ((base->min_address_fixed != base->max_address_fixed && len) ||
> +	    (base->min_address_fixed && base->max_address_fixed && !len))
> +		return false;
> +
>  	res->start = addr->minimum;
>  	res->end = addr->maximum;
>  
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
