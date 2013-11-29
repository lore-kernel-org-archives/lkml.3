Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018Ab3K2IoU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 03:44:20 -0500
Received: from co9ehsobe001.messaging.microsoft.com ([207.46.163.24]:39312
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751235Ab3K2IoR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 03:44:17 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(z579ehz9371I542I1432I78fbmzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh8275dh1de097hz2dh109h2a8h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h2184h21a6h2216h22d0h2336hbe9i1155h)
From: Peter Chen <Peter.Chen@freescale.com>
To: Chris Ruehl <chris.ruehl@gtsys.com.hk>,
        "alexander.shishkin@linux.intel.com" 
	<alexander.shishkin@linux.intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/3 v2] usb: chipidea: Reallocate regmap only if lpm is
 detected
Thread-Topic: [PATCH 1/3 v2] usb: chipidea: Reallocate regmap only if lpm is
 detected
Thread-Index: AQHO7NN77WStowiZJki6sMAdnsg+h5o75IsA
Date: Fri, 29 Nov 2013 08:44:11 +0000
Message-ID: <F281D0F91ED19E4D8E63A7504E8A64980413ABCC@039-SN2MPN1-021.039d.mgd.msft.net>
References: <1385709573-10419-1-git-send-email-chris.ruehl@gtsys.com.hk>
In-Reply-To: <1385709573-10419-1-git-send-email-chris.ruehl@gtsys.com.hk>
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


 

> -----Original Message-----
> From: linux-usb-owner@vger.kernel.org [mailto:linux-usb-
> owner@vger.kernel.org] On Behalf Of Chris Ruehl
> Sent: Friday, November 29, 2013 3:20 PM
> To: alexander.shishkin@linux.intel.com; gregkh@linuxfoundation.org
> Cc: linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org; Chris Ruehl
> Subject: [PATCH 1/3 v2] usb: chipidea: Reallocate regmap only if lpm is
> detected
> 
> usb: chipidea: Reallocate regmap only if lpm is detected
> 
> The regmap only needs to reallocate if the hw_read on the CAP register
> shows
> lpm is used. Therefore the if() statement check the change.
> 
> Signed-off-by: Chris Ruehl <chris.ruehl@gtsys.com.hk>
> ---
>  drivers/usb/chipidea/core.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/chipidea/core.c b/drivers/usb/chipidea/core.c
> index 5d8981c..5075407 100644
> --- a/drivers/usb/chipidea/core.c
> +++ b/drivers/usb/chipidea/core.c
> @@ -208,7 +208,8 @@ static int hw_device_init(struct ci_hdrc *ci, void
> __iomem *base)
>  	reg = hw_read(ci, CAP_HCCPARAMS, HCCPARAMS_LEN) >>
>  		__ffs(HCCPARAMS_LEN);
>  	ci->hw_bank.lpm  = reg;
> -	hw_alloc_regmap(ci, !!reg);
> +	if (reg)
> +		hw_alloc_regmap(ci, !!reg);
>  	ci->hw_bank.size = ci->hw_bank.op - ci->hw_bank.abs;
>  	ci->hw_bank.size += OP_LAST;
>  	ci->hw_bank.size /= sizeof(u32);
> --

Acked-by: Peter Chen <peter.chen@freescale.com>

Peter


