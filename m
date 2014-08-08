Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932820AbaHHWU0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 18:20:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:32884 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757251AbaHHWUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 18:20:22 -0400
Date: Fri, 8 Aug 2014 15:20:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Roger Tseng <rogerable@realtek.com>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rtsx_usb: export device table
Message-Id: <20140808152021.a3cbcf4f1fe95dca4531f36f@linux-foundation.org>
In-Reply-To: <53E541C7.9030407@suse.com>
References: <53E541C7.9030407@suse.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 08 Aug 2014 17:31:51 -0400 Jeff Mahoney <jeffm@suse.com> wrote:

> The rtsx_usb driver contains the table for the devices it supports but
> doesn't export it. As a result, no alias is generated and it doesn't
> get loaded automatically.
> 
> Via https://bugzilla.novell.com/show_bug.cgi?id=890096
> 
> ...
> 
> --- a/drivers/mfd/rtsx_usb.c
> +++ b/drivers/mfd/rtsx_usb.c
> @@ -744,6 +744,7 @@ static struct usb_device_id rtsx_usb_usb
>  	{ USB_DEVICE(0x0BDA, 0x0140) },
>  	{ }
>  };
> +MODULE_DEVICE_TABLE(usb, rtsx_usb_usb_ids);
>  
>  static struct usb_driver rtsx_usb_driver = {
>  	.name			= "rtsx_usb",
> 

I'd normally duck a patch like this because I don't do MFD.

But you omitted the Cc:stable tag, so I grabbed the patch to ensure
that this tag is included.

