Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454AbaIOILK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 04:11:10 -0400
Received: from mail.peak-system.com ([213.157.13.214]:48651 "EHLO
	mail.peak-system.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575AbaIOILI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 04:11:08 -0400
X-Greylist: delayed 554 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Sep 2014 04:11:07 EDT
Message-ID: <54169CE8.8050609@peak-system.com>
Date: Mon, 15 Sep 2014 10:01:44 +0200
From: Stephane Grosjean <s.grosjean@peak-system.com>
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:24.0)
 Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
CC: Oliver Hartkopp <socketcan@hartkopp.net>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        "Christopher R. Baker" <cbaker@rec.ri.cmu.edu>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: can: usb: peak_usb: pcan_usb_core.c:  Cleaning up
 missing null-terminate in conjunction with strncpy
References: <1410715898-15904-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1410715898-15904-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-AxigenSpam-Level: 1
X-CTCH-RefID: str=0001.0A0C0201.54169CE9.019B,ss=1,fgs=0
X-CTCH-VOD: Unknown
X-CTCH-Spam: Unknown
X-AxigenVirus-Level: 1
X-AXIGEN-KAV-Info: clean: Scanned with Kaspersky Anti Virus 8.0.3.83
X-AXIGEN-KAS-Info: Not spam
X-AXIGEN-KAS-Info: Version: 4.4.2 (May 20 2011 12:01:19)
X-AXIGEN-KAS-Info: Envelope from: 
X-AXIGEN-KAS-Info: {HEADERS: 7-bit header Content-Type found with 8-bit header
 Content-Transfer-Encoding}
X-AXIGEN-KAS-Info: Rate: 10
X-AXIGEN-KAS-Info: Status: not_detected
X-AXIGEN-KAS-Info: Method: none
X-AXIGEN-KAS-Info: DBG v.5. 2378, 911. R:128,1,128,6,7,128,1,128,0.
 M:4,24,55,145,160,169,174,193,194, CF:0,907,1. Date: +0200
X-AXIGEN-KAS-Spam-Level: Not Spam
X-AXIGEN-KAS-Spam-Confidence: 10%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Stephane Grosjean <s.grosjean@peak-system.com>

Le 14/09/2014 19:31, Rickard Strandqvist a écrit :
> Replacing strncpy with strlcpy to avoid strings that lacks null terminate.
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>   drivers/net/can/usb/peak_usb/pcan_usb_core.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/can/usb/peak_usb/pcan_usb_core.c b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
> index 644e6ab..d4fe8ac 100644
> --- a/drivers/net/can/usb/peak_usb/pcan_usb_core.c
> +++ b/drivers/net/can/usb/peak_usb/pcan_usb_core.c
> @@ -830,7 +830,7 @@ static void peak_usb_disconnect(struct usb_interface *intf)
>   		char name[IFNAMSIZ];
>   
>   		dev->state &= ~PCAN_USB_STATE_CONNECTED;
> -		strncpy(name, netdev->name, IFNAMSIZ);
> +		strlcpy(name, netdev->name, IFNAMSIZ);
>   
>   		unregister_netdev(netdev);
>   		free_candev(netdev);

--
PEAK-System Technik GmbH, Otto-Roehm-Strasse 69, D-64293 Darmstadt 
Geschaeftsleitung: A.Gach/U.Wilhelm,St.Nr.:007/241/13586 FA Darmstadt 
HRB-9183 Darmstadt, Ust.IdNr.:DE 202220078, WEE-Reg.-Nr.: DE39305391 
Tel.+49 (0)6151-817320 / Fax:+49 (0)6151-817329, info@peak-system.com
--
