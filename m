Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088AbbA2B7c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:59:32 -0500
Received: from mail-oi0-f45.google.com ([209.85.218.45]:64341 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755984AbbA2B7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:59:20 -0500
Date: Wed, 28 Jan 2015 17:15:04 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Lv Zheng <lv.zheng@intel.com>,
        Len Brown <lenb@kernel.org>, Tony Luck <tony.luck@intel.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [Patch v2 09/22] ACPI: Fix a bug in parsing ACPI Memroy24
 resource
Message-ID: <20150128231504.GC17623@google.com>
References: <1422442660-455-1-git-send-email-jiang.liu@linux.intel.com>
 <1422442660-455-10-git-send-email-jiang.liu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1422442660-455-10-git-send-email-jiang.liu@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Memory24", not "Memroy24", in subject.

On Wed, Jan 28, 2015 at 06:57:27PM +0800, Jiang Liu wrote:
> According to ACPI spec 5, section 6.4.3.1 "24-Bit Memory Range Descriptor",
> minimum, maximum and address_length field in struct acpi_resource_memory24
> is in granularity of 256-bytes. So shift 8-bit left to get correct address.
> 
> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> ---
>  drivers/acpi/resource.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
> index 7ce00a63f695..5544c6d26f32 100644
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
> -- 
> 1.7.10.4
> 
