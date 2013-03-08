Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755133Ab3CHULH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 15:11:07 -0500
Received: from www.linutronix.de ([62.245.132.108]:56441 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab3CHULE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 15:11:04 -0500
Date: Fri, 8 Mar 2013 21:10:49 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yinghai Lu <yinghai@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH v2 02/26] x86, irq: Modify irq chip once for irq
 remapping
In-Reply-To: <alpine.LFD.2.02.1303082104580.22263@ionos>
Message-ID: <alpine.LFD.2.02.1303082108590.22263@ionos>
References: <1360351703-20571-1-git-send-email-yinghai@kernel.org> <1360351703-20571-3-git-send-email-yinghai@kernel.org> <alpine.LFD.2.02.1303082104580.22263@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Mar 2013, Thomas Gleixner wrote:
> On Fri, 8 Feb 2013, Yinghai Lu wrote:
> 
> > Now after irq remapping is enabled, irq_chip fields are modified during
> > every irq setup.
> > 
> > Only need to change them one during we enable irq mapping.
> 
> Can you please start to write sensible changelogs? I'm really sick of
> your sloppyness.
> 
> > Also change irq_remap_modify_chip_defaults() to __init.
> 
> Why can you do that ?
>   
> > We don't need to use #ifdef in irq_remap_modify_chips(), as
> > IRQ_REMAP only support x86_64 AND X86_IO_APIC AND PCI_MSI,
> > also HPET_TIMER is set when x86_64 is set.
> 
> You should not describe what the patch is doing, you are again missing
> to describe why the patch is doing this. 

And just for clarification. If you are not going to provide proper
changelogs for _all_ patches of the series, this stuff is going
directly towards /dev/null. I'm not wasting my time to review any of
that otherwise.

Thanks,

	tglx
