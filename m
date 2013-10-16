Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758936Ab3JPXFW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 19:05:22 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:38600 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066Ab3JPXFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 19:05:19 -0400
Date: Wed, 16 Oct 2013 17:05:15 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: tianyu.lan@intel.com
Cc: lenb@kernel.org, rjw@sisk.pl, yinghai@kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Resend PATCH 2/5] ACPI/Resource: Add address translation support
Message-ID: <20131016230515.GB17866@google.com>
References: <1381493941-4650-1-git-send-email-tianyu.lan@intel.com>
 <1381493941-4650-3-git-send-email-tianyu.lan@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381493941-4650-3-git-send-email-tianyu.lan@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 11, 2013 at 08:18:58PM +0800, tianyu.lan@intel.com wrote:
> From: Lan Tianyu <tianyu.lan@intel.com>
> 
> According ACPI 5.0 spec Section 19.1.8

This section reference is wrong.  Table 5-133 (on page 243) does
point to Section 19.1.8, but that section is only the ASL grammar
description and doesn't have any useful information about what
_TRA means.

A more useful reference (and the source of the quote below) is
Section 6.4.3.5.1.

> "For bridges, translate addresses across the bridge, this is the
> offset that must be added to the address on the secondary side
> to obtain the address on the primary side. Non-bridge devices
> must list 0."

You didn't quote this correctly.  Here's a copy/paste from the spec:

    For bridges that translate addresses across the bridge, this is
    the offset that must be added to the address on the secondary side
    to obtain the address on the primary side. Non-bridge devices must
    list 0 for all Address Translation offset bits.

> This patch is to add address translation offset to the start/end
> of struct resource in the acpi_dev_resource_address_space().
> Further more, non-bridge device's translation_offset should 0.
> So this change will affect other devices.
> 
> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>

I like the patch, though :)  With the above corrections,

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

> ---
>  drivers/acpi/resource.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
> index 929f416..84bc3db 100644
> --- a/drivers/acpi/resource.c
> +++ b/drivers/acpi/resource.c
> @@ -192,8 +192,8 @@ bool acpi_dev_resource_address_space(struct acpi_resource *ares,
>  	if (ACPI_FAILURE(status))
>  		return true;
>  
> -	res->start = addr.minimum;
> -	res->end = addr.maximum;
> +	res->start = addr.minimum + addr.translation_offset;
> +	res->end = addr.maximum + addr.translation_offset;
>  	window = addr.producer_consumer == ACPI_PRODUCER;
>  
>  	switch(addr.resource_type) {
> -- 
> 1.8.2.1
> 
