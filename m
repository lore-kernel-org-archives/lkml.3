Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530AbbAUATq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 19:19:46 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:64234 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750717AbbAUATo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 19:19:44 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Bjorn Helgaas <bhelgaas@google.com>,
        Yinghai Lu <yinghai@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Len Brown <lenb@kernel.org>, Tony Luck <tony.luck@intel.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [RFC Patch 09/19] ACPI: Fix a bug in parsing ACPI Memroy24 resource
Date: Wed, 21 Jan 2015 01:42:20 +0100
Message-ID: <1633329.njF7Ian1Kn@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1420684386-5975-10-git-send-email-jiang.liu@linux.intel.com>
References: <1420684386-5975-1-git-send-email-jiang.liu@linux.intel.com> <1420684386-5975-10-git-send-email-jiang.liu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 08, 2015 10:32:56 AM Jiang Liu wrote:
> According to ACPI spec 5, section 6.4.3.1 "24-Bit Memory Range Descriptor",
> minimum, maximum and address_length field in struct acpi_resource_memory24
> is in granularity of 256-bytes. So shift 8-bit left to get correct address.

Are you sure about this?

I'm reading ACPI 5.1 ATM and (on page 316) it only says about the range length
being in 256 byte blocks.

> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> ---
>  drivers/acpi/resource.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
> index abe3a29ad802..f4aeef22a9d8 100644
> --- a/drivers/acpi/resource.c
> +++ b/drivers/acpi/resource.c
> @@ -90,8 +90,8 @@ bool acpi_dev_resource_memory(struct acpi_resource *ares, struct resource *res)
>  	switch (ares->type) {
>  	case ACPI_RESOURCE_TYPE_MEMORY24:
>  		memory24 = &ares->data.memory24;
> -		acpi_dev_get_memresource(res, memory24->minimum,
> -					 memory24->address_length,
> +		acpi_dev_get_memresource(res, memory24->minimum << 8,
> +					 memory24->address_length << 8,
>  					 memory24->write_protect);
>  		break;
>  	case ACPI_RESOURCE_TYPE_MEMORY32:
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
