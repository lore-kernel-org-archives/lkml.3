Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529AbaI2Omo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 10:42:44 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:57673 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694AbaI2Omm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 10:42:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: suravee.suthikulpanit@amd.com, will.deacon@arm.com, liviu.dudau@arm.com,
        marc.zyngier@arm.com, mark.rutland@arm.com, catalin.marinas@arm.com,
        jason@lakedaemon.net, tglx@linutronix.de, robh+dt@kernel.org,
        bhelgaas@google.com, Mark Rutland <Mark.Rutland@arm.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        Marc Zyngier <Marc.Zyngier@arm.com>, linux-pci@vger.kernel.org,
        Will Deacon <Will.Deacon@arm.com>, linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>
Subject: Re: [RFC 4/4] irqchip: gicv2m: Add supports for ARM GICv2m MSI(-X)
Date: Mon, 29 Sep 2014 16:42:18 +0200
Message-ID: <2648363.DSa0NxqRJL@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1411937610-22125-5-git-send-email-suravee.suthikulpanit@amd.com>
References: <1411937610-22125-1-git-send-email-suravee.suthikulpanit@amd.com> <1411937610-22125-5-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:RF3GhPBaSljD31QR2Ng/OafbHPwII4FY4faSFVVVcUV
 YcMZxMlGJ+O+65sV/xuQx4DFzAC8OEnPw4resy0nPjH161NfbO
 oQ6K1A1yY9GpyfFdV1UbuygNeaeaIPfInhtrCaSiIXeL288Mre
 Z5fl+dx768R8geQpDtH6b5OHDeAr3vPQK6/zoPKIwhrjUS3HCb
 cR2W9iXPu70C8pWtBUvHG/S+HZA3NodYgeqYgjcO3Sy8XcPVB2
 8pT2A3Xrc2npenLsWHCGAIjMENTacfA5G3N/kRC5/dRp1g0Gx6
 qL8LEqxj/ImyMzbGsboOBDe++SPCZPLFdjAximbFtHZ9wPJpD/
 g6jvoMvkJLuJbgczG7k4=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 28 September 2014 15:53:30 suravee.suthikulpanit@amd.com wrote:
> +       interrupt-controller@e1101000 {
> +               compatible = "arm,gic-400";
> +               #interrupt-cells = >;
> +               #address-cells = <2>;
> +               #size-cells = <2>;
> +               interrupt-controller;
> +               interrupts = <1 8 0xf04>;
> +               ranges = <0 0 0 0xe1100000 0 0x100000>;
> +               reg = <0x0 0xe1110000 0 0x01000>,
> +                     <0x0 0xe112f000 0 0x02000>,
> +                     <0x0 0xe1140000 0 0x10000>,
> +                     <0x0 0xe1160000 0 0x10000>;
> +               v2m0: v2m@0x8000 {
> +                       compatible = "arm,gic-v2m-frame";
> +                       msi-controller;
> +                       reg = <0x0 0x80000 0 0x1000>;
> +               };
> +
> +               ....
> +
> +               v2mN: v2m@0x9000 {
> +                       compatible = "arm,gic-v2m-frame";
> +                       msi-controller;
> +                       reg = <0x0 0x90000 0 0x1000>;
> +               };
> +       };
> 

Could this just be modeled as a separate msi-controller node
outside of the GIC?

Instead of the arm,msi-base-spi/arm,msi-num-spis properties, how
about using regular "interrupts"/"interrupt-parent" properties listing
the exact interrupts? That would also make it more flexible in
case the same layout is used with a parent other than the GIC.

	ARnd
