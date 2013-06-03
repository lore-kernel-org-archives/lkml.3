Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757795Ab3FCN2V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 09:28:21 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:61314 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716Ab3FCN2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 09:28:19 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Dave Martin <dave.martin@linaro.org>, arm@kernel.org
Subject: Re: [PATCH] drivers/bus: arm-cci: fix combined ARMv6+v7 build
Date: Mon, 03 Jun 2013 15:28:07 +0200
Message-ID: <9496903.tJWqnjnUVv@wuerfel>
User-Agent: KMail/4.10.2 (Linux/3.10.0-rc3-next-20130527+; KDE/4.10.3; x86_64; ; )
In-Reply-To: <alpine.LFD.2.03.1306030922380.1200@syhkavp.arg>
References: <2485806.Uv8bUctxav@wuerfel> <alpine.LFD.2.03.1306030922380.1200@syhkavp.arg>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:ZCjLwxSTeCgc4xKndIbR6561TGl5OyP/LydZ2Yhbpky
 2K/sJpXUVh6HBqq8l/F9SCGW0eyk0ECKn9yVB2Xc2veLAXseKb
 81oeT+oEeMfX0hT6dtQMKIXFTknoI2u0sA7E4uxBIifL/qKaEX
 HagO3xGxydIdZIZkTf1C3K8GfGQxZ+quhnAJKIgXeGHfBp9QV9
 gLw99h2Y1326vzMJn6FuXE3STHj7liUANDtOTWj374D5Cl1/pK
 xEtuyPLc8lejlE0h0XfHxGp/9WaGUo0zNcKIWIWdJS1ixSR790
 NnajkQp2AZ1FTqUXloNyfTr/Nl4w1jQsAjUsKX3iEgV/DRHJJ/
 FF0POeWOja3PrjWqu1vo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 June 2013 09:23:58 Nicolas Pitre wrote:
> On Mon, 3 Jun 2013, Arnd Bergmann wrote:
> 
> > When we build a kernel with support for both ARMv6 and ARMv7,
> > gas is trying to be helpful by pointing out that the arm-cci
> > driver would not work on ARMv6:
> > 
> > /tmp/ccu1LDeU.s: Assembler messages:
> > /tmp/ccu1LDeU.s:450: Error: selected processor does not support ARM mode `wfi '
> > /tmp/ccu1LDeU.s:451: Error: selected processor does not support ARM mode `wfe '
> > make[4]: *** [drivers/bus/arm-cci.o] Error 1
> > 
> > We know that the driver will only be used on ARMv7, hence we
> > can annotate the inline assembly listing to allow those instructions.
> > 
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > Cc: Nicolas Pitre <nico@linaro.org>
> > Cc: Dave Martin <dave.martin@linaro.org>
> 
> Acked-by: Nicolas Pitre <nico@linaro.org>

Thanks

> Since this code is merged into ARM-SOC, I assume you'll take care of 
> this patch?

Yes, I applied it on top of the next/soc branch now.

	Arnd
