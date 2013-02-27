Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115Ab3B0Ify (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 03:35:54 -0500
Received: from mail-lb0-f169.google.com ([209.85.217.169]:33562 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754558Ab3B0Ifx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 03:35:53 -0500
MIME-Version: 1.0
In-Reply-To: <20130227082335.GB30395@linux-sh.org>
References: <20130218142834.28739.39417.sendpatchset@w520>
	<20130227082335.GB30395@linux-sh.org>
Date: Wed, 27 Feb 2013 17:35:51 +0900
Message-ID: <CANqRtoSbiPhRbDsZppkJ+F48tEmuCdSfVRo3dTs9cEUxfvLopA@mail.gmail.com>
Subject: Re: [PATCH] irqchip: Renesas INTC External IRQ pin driver
From: Magnus Damm <magnus.damm@gmail.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        benh@kernel.crashing.org, grant.likely@secretlab.ca,
        horms@verge.net.au, tglx@linutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 5:23 PM, Paul Mundt <lethal@linux-sh.org> wrote:
> On Mon, Feb 18, 2013 at 11:28:34PM +0900, Magnus Damm wrote:
>> From: Magnus Damm <damm@opensource.se>
>>
>> This patch adds a driver for external IRQ pins connected
>> to the INTC block on recent SoCs from Renesas.
>>
> So how exactly does this interact with the existing sh_intc code? Or is
> there some reason why you have opted to bypass it in order to implement a
> simplified reduced-functionality version of INTC support focused only on
> external pins? If both are used together this is going to be a nightmare
> for locking, and it's also non-obvious how the IRQ domains on both sides
> will interact.
>
> This needs a lot more explanation.

Recent GIC-based SoCs do not make use of INTC for any on-chip I/O
devices. This driver is meant to be used as a layer between the actual
IRQ pin and the GIC. Anything else needs the full driver. The existing
non-DT INTC driver can happily coexist with this driver like it does
in the case of sh73a0 here:

[PATCH 02/03] ARM: shmobile: INTC External IRQ pin driver on sh73a0

The driver is not meant to be used with INTC-only based systems like
sh7372 and the SH architecture. I would be very happy if someone could
get their shit together and fix up DT support for the common INTC
code. This has not happened yet though. So if you know anyone with
time to spare then feel free to suggest them to work together with
Iwamatsu-san to get the DT version of the code reviewed together with
Linaro.

Thanks,

/ magnus
