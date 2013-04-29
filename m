Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933017Ab3D2TUB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 15:20:01 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:55250 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933006Ab3D2TT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 15:19:58 -0400
Date: Mon, 29 Apr 2013 15:19:57 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Sedat Dilek <sedat.dilek@gmail.com>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Landley <rob@landley.net>, <linux-usb@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH usb-next] USB: Improve documentation for usbmon
In-Reply-To: <1367155087-4938-1-git-send-email-sedat.dilek@gmail.com>
Message-ID: <Pine.LNX.4.44L0.1304291511540.1152-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Apr 2013, Sedat Dilek wrote:

> This is a give-back to USB folks who helped me in a USB debug issue.

Thanks for sending this.  Here are some suggestions for minor 
improvements.

> Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
> ---
>  Documentation/usb/usbmon.txt | 87 ++++++++++++++++++++++++++++----------------
>  1 file changed, 55 insertions(+), 32 deletions(-)
> 
> diff --git a/Documentation/usb/usbmon.txt b/Documentation/usb/usbmon.txt
> index c42bb9c..02f5845 100644
> --- a/Documentation/usb/usbmon.txt
> +++ b/Documentation/usb/usbmon.txt
> @@ -23,35 +23,53 @@ in a text format. This is used for two purposes. First, it serves as a
>  common trace exchange format for tools while more sophisticated formats
>  are finalized. Second, humans can read it in case tools are not available.
>  
> -To collect a raw text trace, execute following steps.
> +To collect a (raw text) usbmon trace, execute the following steps.

Might as well leave out the parentheses.

>  
> -1. Prepare
> +Step #1: Prerequisites and preperation

s/preperation/preparation/

>  
> -Mount debugfs (it has to be enabled in your kernel configuration), and
> -load the usbmon module (if built as module). The second step is skipped
> -if usbmon is built into the kernel.
> +You should enable the following kernel-config options:
>  
> -# mount -t debugfs none_debugs /sys/kernel/debug
> -# modprobe usbmon
> -#
> +CONFIG_DEBUG_FS=y   <--- Enable DebugFS
> +CONFIG_USB_DEBUG=y  <--- Enable USB debugging

As far as I know, CONFIG_USB_DEBUG is not needed.

> +CONFIG_USB_MON=m    <--- Build usbmon as kernel-module

This could be either 'm' or 'y'.  Many distributions set it to 'y'.

>  
> -Verify that bus sockets are present.
> +Mount debugfs and load usbmon module:
>  
> -# ls /sys/kernel/debug/usb/usbmon
> -0s  0u  1s  1t  1u  2s  2t  2u  3s  3t  3u  4s  4t  4u
> -#
> +   # mount -t debugfs none_debugs /sys/kernel/debug

Distributions normally do this for you.

>  
> -Now you can choose to either use the socket '0u' (to capture packets on all
> +   # modprobe -v usbmon
> +   insmod /lib/modules/$(uname -r)/kernel/drivers/usb/mon/usbmon.ko

The complicated insmod command isn't needed; modprobe works perfectly
well.

> +
> +The second step is skipped if usbmon is built into the kernel.

This is unclear.  "second step" sounds like it refers to Step #2 below.

Alan Stern

