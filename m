Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932067AbbAGVDb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 16:03:31 -0500
Received: from down.free-electrons.com ([37.187.137.238]:55956 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754951AbbAGVD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 16:03:26 -0500
Date: Wed, 7 Jan 2015 22:03:13 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        David Laight <David.Laight@ACULAB.COM>
Subject: Re: [PATCH v2 0/5] usb: atmel_usba_udc: Rework errata handling
Message-ID: <20150107210313.GC2447@piout.net>
References: <1420552022-8422-1-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420552022-8422-1-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The whole series looks good to me, you can add my
Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>



On 06/01/2015 at 14:46:57 +0100, Boris Brezillon wrote :
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
> Changes since v1:
> - cache INT_ENB value to speedup INT_ENB read operations
> 
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
> -- 
> 1.9.1
> 

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
