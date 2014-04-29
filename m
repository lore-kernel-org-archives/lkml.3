Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757403AbaD2KVO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 06:21:14 -0400
Received: from www.linutronix.de ([62.245.132.108]:38584 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756515AbaD2KVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 06:21:11 -0400
Date: Tue, 29 Apr 2014 12:21:15 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Matt Fleming <matt@console-pimps.org>
cc: Dave Young <dyoung@redhat.com>, matt.fleming@intel.com, hpa@zytor.com,
        akpm@linux-foundation.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [PATCH] ignore ,keep for efi earlyprintk
In-Reply-To: <20140429094539.GD26088@console-pimps.org>
Message-ID: <alpine.DEB.2.02.1404291217380.6261@ionos.tec.linutronix.de>
References: <20140424093658.GA7158@dhcp-16-198.nay.redhat.com> <20140425115345.GC26088@console-pimps.org> <20140426072821.GA2286@darkstar.redhat.com> <20140429094539.GD26088@console-pimps.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2014, Matt Fleming wrote:
> I would just replace the existing calls to early_ioremap() with
> efi_ioremap() and implement it like so (all in
> arch/x86/platform/efi/early_printk.c),
> 
> static void *efi_ioremap(resource_size_t phys_addr, unsigned long size)
> {
> 	if (system_state == SYSTEM_BOOTING)
> 		return early_ioremap(phys_addr, size);
> 
> 	return ioremap(phys_addr, size);
> }
> 
> At least I think SYSTEM_BOOTING is the correct way to figure out when to
> use early_ioremap(), I'm open to other suggestions though.

ioremap() is available after paging_init() has been called.

Just x86 has this extra bits so you can use early_ioremap/unmap
_AFTER_ paging_init(). No idea why, but probably to cope with some
brilliant init calls which run pre and post paging_init().

Thanks,

	tglx
