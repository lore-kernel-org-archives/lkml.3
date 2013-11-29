Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450Ab3K2Iol (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 03:44:41 -0500
Received: from co9ehsobe001.messaging.microsoft.com ([207.46.163.24]:33635
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752417Ab3K2Ioh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 03:44:37 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(z579eh6cdkz9371I542I1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh8275dh1de097hz2dh109h2a8h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h2184h21a6h2216h22d0h2336hbe9i1155h)
From: Peter Chen <Peter.Chen@freescale.com>
To: Chris Ruehl <chris.ruehl@gtsys.com.hk>,
        "alexander.shishkin@linux.intel.com" 
	<alexander.shishkin@linux.intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/3 v2] usb: chipidea: Fix Internal error: : 808 [#1]
 ARM related to STS flag
Thread-Topic: [PATCH 2/3 v2] usb: chipidea: Fix Internal error: : 808 [#1]
 ARM related to STS flag
Thread-Index: AQHO7NN7PUjosVZfh0axoC7TxABhL5o75L0g
Date: Fri, 29 Nov 2013 08:44:32 +0000
Message-ID: <F281D0F91ED19E4D8E63A7504E8A64980413ABDA@039-SN2MPN1-021.039d.mgd.msft.net>
References: <1385709585-10459-1-git-send-email-chris.ruehl@gtsys.com.hk>
In-Reply-To: <1385709585-10459-1-git-send-email-chris.ruehl@gtsys.com.hk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.242.175]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Best regards,
Peter Chen


> -----Original Message-----
> From: linux-usb-owner@vger.kernel.org [mailto:linux-usb-
> owner@vger.kernel.org] On Behalf Of Chris Ruehl
> Sent: Friday, November 29, 2013 3:20 PM
> To: alexander.shishkin@linux.intel.com; gregkh@linuxfoundation.org
> Cc: linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org; Chris Ruehl
> Subject: [PATCH 2/3 v2] usb: chipidea: Fix Internal error: : 808 [#1] ARM
> related to STS flag
> 
> usb: chipidea: Fix Internal error: : 808 [#1] ARM related to STS flag
> 
> * init the sts flag to 0 (missed)
> * set the sts flag only if not 0
> 
> Signed-off-by: Chris Ruehl <chris.ruehl@gtsys.com.hk>
> ---
>  drivers/usb/chipidea/core.c |    8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/usb/chipidea/core.c b/drivers/usb/chipidea/core.c
> index 5075407..1a6010e 100644
> --- a/drivers/usb/chipidea/core.c
> +++ b/drivers/usb/chipidea/core.c
> @@ -245,6 +245,8 @@ static void hw_phymode_configure(struct ci_hdrc *ci)
>  {
>  	u32 portsc, lpm, sts = 0;
> 
>  	switch (ci->platdata->phy_mode) {
>  	case USBPHY_INTERFACE_MODE_UTMI:
>  		portsc = PORTSC_PTS(PTS_UTMI);
> @@ -273,10 +275,12 @@ static void hw_phymode_configure(struct ci_hdrc *ci)
> 
>  	if (ci->hw_bank.lpm) {
>  		hw_write(ci, OP_DEVLC, DEVLC_PTS(7) | DEVLC_PTW, lpm);
> -		hw_write(ci, OP_DEVLC, DEVLC_STS, sts);
> +		if (sts)
> +			hw_write(ci, OP_DEVLC, DEVLC_STS, sts);
>  	} else {
>  		hw_write(ci, OP_PORTSC, PORTSC_PTS(7) | PORTSC_PTW, portsc);
> -		hw_write(ci, OP_PORTSC, PORTSC_STS, sts);
> +		if ( sts )
> +			hw_write(ci, OP_PORTSC, PORTSC_STS, sts);
>  	}
>  }
> 
> --

Acked-by: Peter Chen <peter.chen@freescale.com>

Peter


