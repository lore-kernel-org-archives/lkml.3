Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346Ab3J3Rbw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 13:31:52 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:53948 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751497Ab3J3Rbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 13:31:51 -0400
Date: Wed, 30 Oct 2013 13:31:50 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: David Cohen <david.a.cohen@linux.intel.com>
cc: balbi@ti.com, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <Paul.Zimmerman@synopsys.com>
Subject: Re: [PATCH v3 1/3] usb: gadget: add quirk_ep_out_aligned_size field
 to struct usb_gadget
In-Reply-To: <1383152778-30739-2-git-send-email-david.a.cohen@linux.intel.com>
Message-ID: <Pine.LNX.4.44L0.1310301329350.1312-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Oct 2013, David Cohen wrote:

> Due to USB controllers may have different restrictions, usb gadget layer
> needs to provide a generic way to inform gadget functions to complain
> with non-standard requirements.
> 
> This patch adds 'quirk_ep_out_aligned_size' field to struct usb_gadget
> to inform when controller's epout requires buffer size to be aligned to
> MaxPacketSize.
> 
> Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
> ---
>  include/linux/usb/gadget.h | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/include/linux/usb/gadget.h b/include/linux/usb/gadget.h
> index 942ef5e..9405d0f 100644
> --- a/include/linux/usb/gadget.h
> +++ b/include/linux/usb/gadget.h
> @@ -540,6 +540,9 @@ struct usb_gadget {
>  	struct device			dev;
>  	unsigned			out_epnum;
>  	unsigned			in_epnum;
> +
> +	/* epout requires buffer size to be aligned to MaxPacketSize */
> +	unsigned			quirk_ep_out_aligned_size:1;
>  };
>  #define work_to_gadget(w)	(container_of((w), struct usb_gadget, work))

Instead of adding this new bitflag to the end of the structure, where 
it will cause the structure to grow by at least 4 bytes, why not add it 
in the middle, along with all the other bitflags, where it won't cause 
any change in the structure's size?

If you prefer, you can move the name, dev, out_epnum, and in_epnum 
fields higher up, so that the bitflags come last.

Alan Stern

