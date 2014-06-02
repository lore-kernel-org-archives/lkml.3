Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801AbaFBTAq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 15:00:46 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:63297 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbaFBTAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 15:00:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: linux-arm-kernel@lists.infradead.org, Shawn Guo <shawn.guo@freescale.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "Strashko, Grygorii" <grygorii.strashko@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>, Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v3 0/7] of: setup dma parameters using dma-ranges and dma-coherent
Date: Mon, 02 Jun 2014 21:00:16 +0200
Message-ID: <4328786.m38YGt2sIU@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <538C9E3C.2000103@ti.com>
References: <1398353407-2345-1-git-send-email-santosh.shilimkar@ti.com> <4197388.OE67ahhtqp@wuerfel> <538C9E3C.2000103@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:5CtcWu2FrmuqWapANq9JGcCUc3uVCtoegy9eWhOKbeU
 Ds3viq1hUK1TxWjGVfj3P7g8/bQOSAGyfD5GJfXp0eu7p+Kuev
 ghq312xjeLhjkhczTsZcgSwq31Urcf2Ar1mjlojxMpUm7ZiY5y
 VIlAI1Vhsrhm4UnzjP4dwLiDRiq71h6+DUnoSw8Rv3vnOHtF8V
 sI3vczT4fflRwhcxKOnN9hC3t+q+kRwRj+/n7ybJ01Gg9wY1sz
 /0oNEh53QtTlfXb3qYqiJIv74Cl7VvS+lD6ynqt8G1C1mmb7dS
 bSnnr5jO+RaTCvtvebyaMUQdGcJrIfpkQVhcPN1dRah5NKBoJ3
 Y4C6dwgj2//uW2zTh6JM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 June 2014 11:54:36 Santosh Shilimkar wrote:
> 
> On Monday 02 June 2014 11:06 AM, Arnd Bergmann wrote:
> > On Monday 02 June 2014 09:24:50 Santosh Shilimkar wrote:
> >> On Monday 02 June 2014 02:37 AM, Shawn Guo wrote:
> >>> On Thu, Apr 24, 2014 at 11:30:00AM -0400, Santosh Shilimkar wrote:
> >>>> Here is an updated v3 of the series. Series introduces support for setting up
> >>>> dma parameters based on device tree properties like 'dma-ranges' and
> >>>> 'dma-coherent' and also update to ARM 32 bit port. Earlier version of the
> >>>> series can be found here [3], [2] and [1].
> >>>
> >>> Are these two generic device tree properties documented somewhere under
> >>> Documentation/devicetree/bindings?
> >>>
> >> These bindings have been already in use before this series. But looks like
> >> they have not been documented. I will do a patch to add description for those
> >> couple of parameters.
> > 
> > dma-ranges is part of ePAPR, and was documented in some ieee-1275 addenda
> > before that, but I agree it would be nice to have something in kernel as
> > well, at the minimum something pointing to the relevant documents.
> > 
> We are thinking of updating 'Documentation/devicetree/bindings/dma/dma.txt'
> to add the information for these extra two parameters.
> 
> Is that fine or any other suggestion ?

I think that's the wrong place. That entire directory currently deals with
the specific case of DMA engines, as opposed to the more DMA bus mastering
in general. We could rename that to
Documentation/devicetree/bindings/dmaengine, but renames tend to cause
extra patch conficts, so I'd prefer finding another location for this.

How about a section in the top-level
Documentation/devicetree/booting-without-of.txt file? After all, this
is very generic and can impact any device that acts as a bus master.

	Arnd
