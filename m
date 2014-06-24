Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639AbaFXOZx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 10:25:53 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51741 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752179AbaFXOZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 10:25:51 -0400
Date: Tue, 24 Jun 2014 10:25:51 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Paul Bolle <pebolle@tiscali.nl>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>, <linux-usb@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB: remove CONFIG_USB_PERSIST from Documentation
In-Reply-To: <1403604665.1960.14.camel@x220>
Message-ID: <Pine.LNX.4.44L0.1406241017250.990-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jun 2014, Paul Bolle wrote:

> CONFIG_USB_PERSIST was removed in v2.6.26. Remove a reference to it from
> Documentation. That reference was a bit odd to begin with.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> "[...] under certain circumstances [...]"? Is that about
> USB_QUIRK_RESET_RESUME? Anyhow, I feel this paragraph needs more work,
> but that would require quite a bit of hand-holding. Perhaps Alan or Greg
> would like to hold my hand here...
> 
>  Documentation/usb/power-management.txt | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/usb/power-management.txt b/Documentation/usb/power-management.txt
> index 1392b61d6ebe..90dc927f0e1e 100644
> --- a/Documentation/usb/power-management.txt
> +++ b/Documentation/usb/power-management.txt
> @@ -304,7 +304,7 @@ using the USB Persist facility.)
>  
>  The reset_resume method is used by the USB Persist facility (see
>  Documentation/usb/persist.txt) and it can also be used under certain
> -circumstances when CONFIG_USB_PERSIST is not enabled.  Currently, if a
> +circumstances when that facility is not enabled.  Currently, if a
>  device is reset during a resume and the driver does not have a
>  reset_resume method, the driver won't receive any notification about
>  the resume.  Later kernels will call the driver's disconnect method;

I don't remember what the "certain circumstances" referred to 
originally.  Right now, if the USB_QUIRK_RESET_RESUME quirk is set 
(meaning that the device can't reset properly so it always has to be 
reset-resumed) then persist will be used even if it isn't enabled.

Also, that "Later kernels" thing has already arrived.  I believe it was 
implemented in 2.6.35.

Alan Stern

