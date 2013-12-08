Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759429Ab3LHRDN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 12:03:13 -0500
Received: from smtprelay01.ispgateway.de ([80.67.31.28]:39429 "EHLO
	smtprelay01.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655Ab3LHRDL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 12:03:11 -0500
X-Greylist: delayed 345 seconds by postgrey-1.27 at vger.kernel.org; Sun, 08 Dec 2013 12:03:11 EST
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 7.0 \(1822\))
Subject: Re: [PATCH] can: ems_usb: fix urb leaks on failure paths
From: Sebastian Haas <sebastian@sebastianhaas.info>
In-Reply-To: <52A309BE.7000602@hartkopp.net>
Date: Sun, 8 Dec 2013 17:52:33 +0100
Cc: Sebastian Haas <dev@sebastianhaas.info>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Content-Transfer-Encoding: 7BIT
Message-Id: <AF039109-A03A-4822-96ED-E4F70F90B2B9@sebastianhaas.info>
References: <1386371435-17597-1-git-send-email-khoroshilov@ispras.ru> <52A309BE.7000602@hartkopp.net>
To: Oliver Hartkopp <socketcan@hartkopp.net>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>
X-Mailer: Apple Mail (2.1822)
X-Df-Sender: MTI2MTIzMw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good. Thanks Alexey.

Acked-by: Sebastian Haas <dev@sebastianhaas.info>

On 07 Dec 2013, at 12:42, Oliver Hartkopp <socketcan@hartkopp.net> wrote:

> Hello Alexey,
> 
> looks better :-)
> 
> I added the author of this driver to double check the patch and for his
> Acked-by ...
> 
> @Sebastian: Would you like to update your e-mail address too?
> 
> Best regards,
> Oliver
> 
> 
> On 07.12.2013 00:10, Alexey Khoroshilov wrote:
>> There are a couple failure paths where urb leaks.
>> Is spare code within ems_usb_start_xmit(),
>> usb_free_urb() should be used to deallocate urb instead of usb_unanchor_urb().
>> In ems_usb_start() there is no usb_free_urb() if usb_submit_urb() fails.
>> 
>> Found by Linux Driver Verification project (linuxtesting.org).
>> 
>> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
>> ---
>> drivers/net/can/usb/ems_usb.c | 3 ++-
>> 1 file changed, 2 insertions(+), 1 deletion(-)
>> 
>> diff --git a/drivers/net/can/usb/ems_usb.c b/drivers/net/can/usb/ems_usb.c
>> index 5f9a7ad9b964..8aeec0b4601a 100644
>> --- a/drivers/net/can/usb/ems_usb.c
>> +++ b/drivers/net/can/usb/ems_usb.c
>> @@ -625,6 +625,7 @@ static int ems_usb_start(struct ems_usb *dev)
>> 			usb_unanchor_urb(urb);
>> 			usb_free_coherent(dev->udev, RX_BUFFER_SIZE, buf,
>> 					  urb->transfer_dma);
>> +			usb_free_urb(urb);
>> 			break;
>> 		}
>> 
>> @@ -798,8 +799,8 @@ static netdev_tx_t ems_usb_start_xmit(struct sk_buff *skb, struct net_device *ne
>> 	 * allowed (MAX_TX_URBS).
>> 	 */
>> 	if (!context) {
>> -		usb_unanchor_urb(urb);
>> 		usb_free_coherent(dev->udev, size, buf, urb->transfer_dma);
>> +		usb_free_urb(urb);
>> 
>> 		netdev_warn(netdev, "couldn't find free context\n");
>> 
>> 

