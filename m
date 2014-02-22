Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751874AbaBVR2g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 12:28:36 -0500
Received: from mail-oa0-f41.google.com ([209.85.219.41]:52072 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527AbaBVR2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 12:28:34 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1402221104440.21251@ionos.tec.linutronix.de>
References: <1388707565-16535-1-git-send-email-yinghai@kernel.org>
	<1388707565-16535-3-git-send-email-yinghai@kernel.org>
	<alpine.DEB.2.02.1401222241100.24986@ionos.tec.linutronix.de>
	<CAE9FiQUo9NGbjiZbMsf2yBFbn=iLJ-jc3QtZ8K6qwVuhmqzq=Q@mail.gmail.com>
	<alpine.DEB.2.02.1402221104440.21251@ionos.tec.linutronix.de>
Date: Sat, 22 Feb 2014 09:28:33 -0800
X-Google-Sender-Auth: YZGYiFA0wBjQHXrRVr2K9TBW6-0
Message-ID: <CAE9FiQVf2L-FjkXR3WC=0iHNY73D2G4jyMeko4f4DPuxAXTK+Q@mail.gmail.com>
Subject: Re: [PATCH v5 02/33] genirq: Add irq_alloc_reserved_desc()
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Tony Luck <tony.luck@intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 22, 2014 at 2:08 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
>
> As I said before irq_reserve_irq() is a misnomer and a
> misconception. Of course this needs to be fixed as well.
>
> And you cannot just blindly change it because !SPARSE can use the
> allocation. We are not creating stupid corner cases just to support
> your sloppyness. Its not rocket science to do it the right way.
>
> That said, it might be worthwhile to get rid of the !SPARSE case
> completely. That would probably make quite some stuff simpler.

So we need to make all arches support SPARSE_IRQ at first?

Now we have arm, arm64, c6x, metag, powerpc, sh, x86 support SPARSE_IRQ.

The following  are not with SPARSE_IRQ yet:
alpha, arc, avr32, blackfin, cris, frv, hexagon, m32r, m68k, microblaze,
mips, mn10300, openrisc, parisc, s390, score, sparc, tile, um,
unicore32, xtensa.

Thanks

Yinghai


Thanks

Yinghai
