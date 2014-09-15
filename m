Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550AbaIOIaX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 04:30:23 -0400
Received: from mx0.aculab.com ([213.249.233.131]:38659 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753392AbaIOIaV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 04:30:21 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'Rickard Strandqvist'" <rickard_strandqvist@spectrumdigital.se>,
        "Wolfgang Grandegger" <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
CC: Oliver Hartkopp <socketcan@hartkopp.net>,
        Stephane Grosjean <s.grosjean@peak-system.com>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        "Christopher R. Baker" <cbaker@rec.ri.cmu.edu>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] net: can: usb: peak_usb: pcan_usb_core.c:  Cleaning up
 missing null-terminate in conjunction with strncpy
Thread-Topic: [PATCH] net: can: usb: peak_usb: pcan_usb_core.c:  Cleaning up
 missing null-terminate in conjunction with strncpy
Thread-Index: AQHP0EGesx6Ru+ZEc0K0ZqftXKP+D5wB3RxQ
Date: Mon, 15 Sep 2014 08:28:26 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D17491F2B@AcuExch.aculab.com>
References: <1410715898-15904-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1410715898-15904-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rickard Strandqvist
...
> Replacing strncpy with strlcpy to avoid strings that lacks null terminate.
...
> diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_core.c
> b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
> index 644e6ab..d4fe8ac 100644
> --- a/drivers/net/can/usb/peak_usb/pcan_usb_core.c
> +++ b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
> @@ -830,7 +830,7 @@ static void peak_usb_disconnect(struct usb_interface *intf)
>  		char name[IFNAMSIZ];
> 
>  		dev->state &= ~PCAN_USB_STATE_CONNECTED;
> -		strncpy(name, netdev->name, IFNAMSIZ);
> +		strlcpy(name, netdev->name, IFNAMSIZ);
> 
>  		unregister_netdev(netdev);
>  		free_candev(netdev);

Or:
	char name[sizeof netdev->name];
	memcpy(name, netdev->name, sizeof netdev->name);

	David



