Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759804AbaCTUeS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 16:34:18 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:55251 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758075AbaCTUeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 16:34:16 -0400
Message-ID: <532B5ED1.8060406@cogentembedded.com>
Date: Fri, 21 Mar 2014 00:34:09 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: =?UTF-8?B?Q8OpZHJpYyBDYWJlc3Nh?= <ced@ryick.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-usb@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] coding style: fix line over 80 characters
References: <1395266697-8699-1-git-send-email-ced@ryick.net> <1395266697-8699-3-git-send-email-ced@ryick.net>
In-Reply-To: <1395266697-8699-3-git-send-email-ced@ryick.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 03/20/2014 01:04 AM, Cédric Cabessa wrote:

> Signed-off-by: Cédric Cabessa <ced@ryick.net>
> ---
>   drivers/staging/usbip/vhci_hcd.c | 33 ++++++++++++++++++++++-----------
>   1 file changed, 22 insertions(+), 11 deletions(-)

> diff --git a/drivers/staging/usbip/vhci_hcd.c b/drivers/staging/usbip/vhci_hcd.c
> index f690668..1e84577 100644
> --- a/drivers/staging/usbip/vhci_hcd.c
> +++ b/drivers/staging/usbip/vhci_hcd.c
> @@ -271,12 +271,14 @@ static int vhci_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
>   			}
>   			break;
>   		case USB_PORT_FEAT_POWER:
> -			usbip_dbg_vhci_rh(" ClearPortFeature: USB_PORT_FEAT_POWER\n");
> +			usbip_dbg_vhci_rh(
> +				" ClearPortFeature: USB_PORT_FEAT_POWER\n");

    Your version of scripts/checkpatch.pl seems outdated. It shouldn't 
complain about strings violating 80-column limit (and I've just verified it 
doesn't).

> @@ -539,7 +546,9 @@ static int vhci_urb_enqueue(struct usb_hcd *hcd, struct urb *urb,
>
>   		default:
>   			/* NOT REACHED */
> -			dev_err(dev, "invalid request to devnum 0 bRequest %u, wValue %u\n", ctrlreq->bRequest,
> +			dev_err(dev,
> +				"invalid request to devnum 0 bRequest %u, wValue %u\n",
> +				ctrlreq->bRequest,
>   				ctrlreq->wValue);
>   			ret =  -EINVAL;
>   			goto no_need_xmit;
> @@ -1060,7 +1069,9 @@ static int vhci_hcd_suspend(struct platform_device *pdev, pm_message_t state)
>   	spin_unlock(&the_controller->lock);
>
>   	if (connected > 0) {
> -		dev_info(&pdev->dev, "We have %d active connection%s. Do not suspend.\n", connected, (connected == 1 ? "" : "s"));
> +		dev_info(&pdev->dev,
> +			 "We have %d active connection%s. Do not suspend.\n",
> +			 connected, (connected == 1 ? "" : "s"));
>   		ret =  -EBUSY;
>   	} else {
>   		dev_info(&pdev->dev, "suspend vhci_hcd");

    Hm, I don't see checkpatch.pl complaints about these either in the 
'usb-next' branch of Greg's tree.

WBR, Sergei

