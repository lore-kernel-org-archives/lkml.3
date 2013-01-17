Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659Ab3AQTik (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 14:38:40 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:46040 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746Ab3AQTij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 14:38:39 -0500
Date: Thu, 17 Jan 2013 11:38:34 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, olaf@aepfle.de,
        apw@canonical.com, jasowang@redhat.com
Subject: Re: [PATCH 19/28] Drivers: hv: Add code to distribute channel
 interrupt load
Message-ID: <20130117193834.GA21956@kroah.com>
References: <1354373160-31332-1-git-send-email-kys@microsoft.com>
 <1354373219-31374-1-git-send-email-kys@microsoft.com>
 <1354373219-31374-19-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354373219-31374-19-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 01, 2012 at 06:46:50AM -0800, K. Y. Srinivasan wrote:
> +/*
> + * This is an array of channels (devices) that are performance critical.
> + * We attempt to distribute the interrupt load for these devices across
> + * all available CPUs.
> + */
> +static const uuid_le hp_devs[] = {
> +	/* {32412632-86cb-44a2-9b5c-50d1417354f5} */
> +	/* IDE */
> +	{
> +		.b = {
> +			0x32, 0x26, 0x41, 0x32, 0xcb, 0x86, 0xa2, 0x44,
> +			0x9b, 0x5c, 0x50, 0xd1, 0x41, 0x73, 0x54, 0xf5
> +		}
> +	},
> +	/* {ba6163d9-04a1-4d29-b605-72e2ffb1dc7f} */
> +	/* Storage - SCSI */
> +	{
> +		.b  = {
> +			0xd9, 0x63, 0x61, 0xba, 0xa1, 0x04, 0x29, 0x4d,
> +			0xb6, 0x05, 0x72, 0xe2, 0xff, 0xb1, 0xdc, 0x7f
> +		}
> +	},
> +	/* {F8615163-DF3E-46c5-913F-F2D2F965ED0E} */
> +	/* Network */
> +	{
> +		.b = {
> +			0x63, 0x51, 0x61, 0xF8, 0x3E, 0xDF, 0xc5, 0x46,
> +			0x91, 0x3F, 0xF2, 0xD2, 0xF9, 0x65, 0xED, 0x0E
> +		}
> +	},
> +
> +};

You are now duplicating these "ids" in different places in the kernel,
perhaps you should put them in one place (hyperv.h?) and then reference
them that way?  It's like a device id for pci, once you use it in two
places, it goes into pci_ids.h.

I'm not going to reject this patch, but can you please do this in a
follow-on patch?

thanks,

greg k-h
