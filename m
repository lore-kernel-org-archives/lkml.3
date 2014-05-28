Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581AbaE1NaB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 09:30:01 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:50341 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059AbaE1N37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 09:29:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Grant Likely <grant.likely@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH v3 4/7] of: configure the platform device dma parameters
Date: Wed, 28 May 2014 15:29:26 +0200
Message-ID: <4960549.viM91iY2g2@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CACRpkdZjEVYgq7tKEfmZC0Fu4n=JuUues=pAAtquLahkex=pkA@mail.gmail.com>
References: <1398353407-2345-1-git-send-email-santosh.shilimkar@ti.com> <5840140.8yGnd4Ycx3@wuerfel> <CACRpkdZjEVYgq7tKEfmZC0Fu4n=JuUues=pAAtquLahkex=pkA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:qDn9YtXtFvT3ZFG1pAj4DJpQKQJL8o3MChTfc6NJEJp
 OHL31Kdar/kbjNO28OrTyleuYQts/l4fIdENVfOB6SLA7fFsHU
 2L9qe+ogPFqk8keBLATBy23sIU2XCnfZqASizuf6Wtjy/GXFOW
 SbfRlSz15T+cZi+bd+nBzRvqnDAv56oldz2O2ZnCb1LShUqqap
 K+3tH3SKfB1c497iqC8ln2OcJBfqP6YRqmM4sFDOyCCSSOen3+
 IyOX6NveEqz9asU9b+yocevGuZriCNO/oBTP81yXNb4aKT1k9o
 JEei47a9v3mlFvnaTsGjkKzWUufBBtuKJjnliV4QZdqZDQ6EBk
 JckVfU4WdbV0nDPC6FCo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 May 2014 10:23:09 Linus Walleij wrote:
> diff --git a/arch/arm/boot/dts/integratorap.dts
> b/arch/arm/boot/dts/integratorap.dts
> index b10e6351da53..f0c397fd45c5 100644
> --- a/arch/arm/boot/dts/integratorap.dts
> +++ b/arch/arm/boot/dts/integratorap.dts
> @@ -8,6 +8,7 @@
>  / {
>         model = "ARM Integrator/AP";
>         compatible = "arm,integrator-ap";
> +       dma-ranges = <0x80000000 0x8 0x00000000 0x80000000>;
> 
>         aliases {
>                 arm,timer-primary = &timer2;
> 

It looks like you accidentally copied the ranges from keystone, even
though that has a 64-bit root bus and you only have 32-bit.

I suspect what you want is

	dma-ranges = <0x80000000 0 0x80000000>;

to translate dma_addr_t 0x80000000-0xffffffff to phys_addr_t 0x0-0x7fffffff
rather than phys_addr_t 0x800000000-0x87fffffff.

	Arnd
