Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880Ab3HWHPX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 03:15:23 -0400
Received: from [213.199.154.249] ([213.199.154.249]:50462 "EHLO
	db9outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754482Ab3HWHPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 03:15:19 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zz98dI1432I1447Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6h1082kz8dhz1de098hz2dh2a8h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h1155h)
Date: Fri, 23 Aug 2013 15:13:55 +0800
From: Dong Aisheng <b29396@freescale.com>
To: Rob Herring <robherring2@gmail.com>
CC: "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>, <rob@landley.net>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 0/3] of: add update device node status via cmdline feature
Message-ID: <20130823071354.GB2460@b29396-Latitude-E6410>
References: <1376564133-11286-1-git-send-email-b29396@freescale.com>
 <520CCB70.8090908@gmail.com>
 <20130821124722.GB17748@b29396-Latitude-E6410>
 <CAL_JsqLa1RkL0MaOCbjYbuQW7+8EKqX8RMfypN=i5UTKaF47=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAL_JsqLa1RkL0MaOCbjYbuQW7+8EKqX8RMfypN=i5UTKaF47=A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rob,

On Wed, Aug 21, 2013 at 08:23:05AM -0500, Rob Herring wrote:
....
> > How does uboot handle this according to our needs?
> > Also dynamically update the device node status with uboot command?
> > Can you help point out an example for me to check?
> >
> 
> Here's an example adding a status property with u-boot commands:
> 
> Highbank #fdt print /soc/ethernet
> ethernet@fff50000 {
>         compatible = "calxeda,hb-xgmac";
>         reg = <0xfff50000 0x00001000>;
>         interrupts = <0x00000000 0x0000004d 0x00000004 0x00000000
> 0x0000004e 0x00000004 0x00000000 0x0000004f 0x00000004>;
>         dma-coherent;
> };
> Highbank #fdt set /soc/ethernet status okay
> Highbank #fdt print /soc/ethernet
> ethernet@fff50000 {
>         status = "okay";
>         compatible = "calxeda,hb-xgmac";
>         reg = <0xfff50000 0x00001000>;
>         interrupts = <0x00000000 0x0000004d 0x00000004 0x00000000
> 0x0000004e 0x00000004 0x00000000 0x0000004f 0x00000004>;
>         dma-coherent;
> };
> 

Thanks for the information. I tried and it works.
However it seems using uboot fdt commands is much complicated than kernel
command line way as i did in this patch.
We probably may would rather using add more board dts way if can not accept this patch series.
I already replied that concern in last mail, can you help check it and provide suggestions?

Regards
Dong Aisheng

