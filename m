Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751350AbaH3HzJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 03:55:09 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:52110 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbaH3HzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 03:55:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Andrew Bresticker <abrestic@chromium.org>
Cc: Ralf Baechle <ralf@linux-mips.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Jeffrey Deans <jeffrey.deans@imgtec.com>,
        Markos Chandras <markos.chandras@imgtec.com>,
        Paul Burton <paul.burton@imgtec.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>, linux-mips@linux-mips.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/12] MIPS: GIC: Add device-tree support
Date: Sat, 30 Aug 2014 09:54:40 +0200
Message-ID: <15153439.zUXECAnL7k@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1409350479-19108-6-git-send-email-abrestic@chromium.org>
References: <1409350479-19108-1-git-send-email-abrestic@chromium.org> <1409350479-19108-6-git-send-email-abrestic@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:qhuEkoRlNK7oyK54wx9D4aSDSMkNfBIB51tKwzfmloK
 ZkRmj9JQFusuI1L3eYgmQXzTVZz/Ur6ngnE0Iu6ocFJ8DiMlEM
 NyJqxsS8xWkAas/iHZuF/my4ZCEE+q9myRpODkd5sCD8ZYSPvY
 i1B7A9AKhsjX8DxPJ6k5oat4asaIlyt+LwmJRtXz/0qjmCR+fd
 gIjupxkT7JJ3VOhG0T16W/+Jn0I4r+HXbc9Xh34PjiR8QqeFEU
 ENXFYvdyElma+FL0YQKEIuuULSChnR3v0ZaEAZM0gu+/ouDjBl
 O/D7VtU9m+F3I6oWQ3UELbBsYSReJQoJK1GnCYWG+G1E4NbksJ
 lwiWu4NcNdW4hsBm/QLo=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 29 August 2014 15:14:32 Andrew Bresticker wrote:
> Add device-tree support for the MIPS GIC.  With DT, no per-platform
> static device interrupt mapping is supplied and instead all device
> interrupts are specified through the DT.  The GIC-to-CPU interrupts
> must also be specified in the DT.
> 
> Platforms using DT-based probing of the GIC need only supply the
> GIC_NUM_INTRS and, if necessary, MIPS_GIC_IRQ_BASE values and
> call of_irq_init() with an of_device_id table including the GIC.
> 
> Currenlty only legacy and vecotred interrupt modes are supported.
> 
> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
> ---
>  arch/mips/include/asm/gic.h |  15 ++++++
>  arch/mips/kernel/irq-gic.c  | 122 +++++++++++++++++++++++++++++++++++++++++++-
> 


Can you move this to drivers/irqchip and use the IRQCHIP_DECLARE()
macro to define the entry point?

	Arnd
