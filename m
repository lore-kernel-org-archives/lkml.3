Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757940Ab3KHQ6W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 11:58:22 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:57124 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757441Ab3KHQ6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 11:58:20 -0500
Date: Fri, 8 Nov 2013 11:58:19 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Julius Werner <jwerner@chromium.org>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Benson Leung <bleung@chromium.org>,
        Vincent Palatin <vpalatin@chromium.org>
Subject: Re: [PATCH v2] usb: hub: Use correct reset for wedged USB3 devices
 that are NOTATTACHED
In-Reply-To: <1383850754-21856-1-git-send-email-jwerner@chromium.org>
Message-ID: <Pine.LNX.4.44L0.1311081157390.1162-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Nov 2013, Julius Werner wrote:

> This patch adds a check for USB_STATE_NOTATTACHED to the
> hub_port_warm_reset_required() workaround for ports that end up in
> Compliance Mode in hub_events() when trying to decide which reset
> function to use. Trying to call usb_reset_device() with a NOTATTACHED
> device will just fail and leave the port broken.
> 
> Signed-off-by: Julius Werner <jwerner@chromium.org>
> ---
>  drivers/usb/core/hub.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
> index e6b682c..0188056 100644
> --- a/drivers/usb/core/hub.c
> +++ b/drivers/usb/core/hub.c
> @@ -4799,8 +4799,9 @@ static void hub_events(void)
>  					hub->ports[i - 1]->child;
>  
>  				dev_dbg(hub_dev, "warm reset port %d\n", i);
> -				if (!udev || !(portstatus &
> -						USB_PORT_STAT_CONNECTION)) {
> +				if (!udev ||
> +				    !(portstatus & USB_PORT_STAT_CONNECTION) ||
> +				    udev->state == USB_STATE_NOTATTACHED) {
>  					status = hub_port_reset(hub, i,
>  							NULL, HUB_BH_RESET_TIME,
>  							true);

Acked-by: Alan Stern <stern@rowland.harvard.edu>

