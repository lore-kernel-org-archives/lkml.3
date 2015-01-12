Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771AbbALLIj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 06:08:39 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:53239 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587AbbALLIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 06:08:36 -0500
Message-ID: <54B3AB32.3040308@atmel.com>
Date: Mon, 12 Jan 2015 12:08:34 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Boris Brezillon <boris.brezillon@free-electrons.com>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        "Alexandre Belloni" <alexandre.belloni@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        David Laight <David.Laight@ACULAB.COM>
Subject: Re: [PATCH v3 0/5] usb: atmel_usba_udc: Rework errata handling
References: <1421060278-27329-1-git-send-email-boris.brezillon@free-electrons.com>
In-Reply-To: <1421060278-27329-1-git-send-email-boris.brezillon@free-electrons.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 12/01/2015 11:57, Boris Brezillon a écrit :
> Hello,
> 
> Here is a set of patches porting existing at91sam9rl erratum handling to
> DT and adding new code to handle at91sam9g45/9x5 erratum.
> It also adds several compatible strings to differentiate those errata.
> 
> These patches should be backported to 3.17 and 3.18 stable releases but
> they do not apply cleanly on those stable branches.
> I'll send a backport of this series once it is merged in mainline.
> 
> Regards,
> 
> Boris
> 
> Changes since v2:
> - remove UTF8 character in commit message of patch 2
> 
> Changes since v1:
> - cache INT_ENB value to speedup INT_ENB read operations

To the whole series:

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Thanks.

> Boris Brezillon (5):
>   usb: atmel_usba_udc: Rework at91sam9rl errata handling
>   usb: atmel_usba_udc: Add at91sam9g45 and at91sam9x5 errata handling
>   ARM: at91/dt: update udc compatible strings
>   usb: atmel_usba_udc: Mask status with enabled irqs
>   usb: gadget: atmel_usba: Cache INT_ENB register value
> 
>  .../devicetree/bindings/usb/atmel-usb.txt          |   5 +-
>  arch/arm/boot/dts/at91sam9g45.dtsi                 |   2 +-
>  arch/arm/boot/dts/at91sam9x5.dtsi                  |   2 +-
>  arch/arm/boot/dts/sama5d3.dtsi                     |   2 +-
>  arch/arm/boot/dts/sama5d4.dtsi                     |   2 +-
>  drivers/usb/gadget/udc/atmel_usba_udc.c            | 146 +++++++++++++--------
>  drivers/usb/gadget/udc/atmel_usba_udc.h            |   9 ++
>  7 files changed, 111 insertions(+), 57 deletions(-)
> 


-- 
Nicolas Ferre
