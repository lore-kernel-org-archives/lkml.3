Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662Ab3FCLen (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 07:34:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55363 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753436Ab3FCLek (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 07:34:40 -0400
Date: Mon, 3 Jun 2013 13:34:38 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: kys@microsoft.com, haiyangz@microsoft.com, devel@linuxdriverproject.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: hyperv: Cocci spatch "memdup.spatch"
In-Reply-To: <1370079631.29224.9.camel@localhost.localdomain>
Message-ID: <alpine.LNX.2.00.1306031334040.6750@pobox.suse.cz>
References: <1370079631.29224.9.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Jun 2013, Thomas Meyer wrote:

> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
> ---
> 
> diff -u -p a/drivers/hid/hid-hyperv.c b/drivers/hid/hid-hyperv.c
> --- a/drivers/hid/hid-hyperv.c
> +++ b/drivers/hid/hid-hyperv.c
> @@ -199,13 +199,11 @@ static void mousevsc_on_receive_device_i
>  	if (desc->bLength == 0)
>  		goto cleanup;
>  
> -	input_device->hid_desc = kzalloc(desc->bLength, GFP_ATOMIC);
> +	input_device->hid_desc = kmemdup(desc, desc->bLength, GFP_ATOMIC);
>  
>  	if (!input_device->hid_desc)
>  		goto cleanup;
>  
> -	memcpy(input_device->hid_desc, desc, desc->bLength);
> -
>  	input_device->report_desc_size = desc->desc[0].wDescriptorLength;
>  	if (input_device->report_desc_size == 0) {
>  		input_device->dev_info_status = -EINVAL;
> 

I guess you are going to get some pushback from some maintainers due to 
non-descriptive subject and missing changelog :)

I have fixed this for the hyperv patch and applied it, thanks.

-- 
Jiri Kosina
SUSE Labs
