Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062AbaD3BLi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 21:11:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12829 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752677AbaD3BLf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 21:11:35 -0400
Date: Wed, 30 Apr 2014 09:12:50 +0800
From: Dave Young <dyoung@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Matt Fleming <matt@console-pimps.org>, matt.fleming@intel.com,
        hpa@zytor.com, akpm@linux-foundation.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [PATCH] ignore ,keep for efi earlyprintk
Message-ID: <20140430011250.GB1959@darkstar.redhat.com>
References: <20140424093658.GA7158@dhcp-16-198.nay.redhat.com>
 <20140425115345.GC26088@console-pimps.org>
 <20140426072821.GA2286@darkstar.redhat.com>
 <20140429094539.GD26088@console-pimps.org>
 <alpine.DEB.2.02.1404291217380.6261@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1404291217380.6261@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/14 at 12:21pm, Thomas Gleixner wrote:
> On Tue, 29 Apr 2014, Matt Fleming wrote:
> > I would just replace the existing calls to early_ioremap() with
> > efi_ioremap() and implement it like so (all in
> > arch/x86/platform/efi/early_printk.c),
> > 
> > static void *efi_ioremap(resource_size_t phys_addr, unsigned long size)
> > {
> > 	if (system_state == SYSTEM_BOOTING)
> > 		return early_ioremap(phys_addr, size);
> > 
> > 	return ioremap(phys_addr, size);
> > }
> > 
> > At least I think SYSTEM_BOOTING is the correct way to figure out when to
> > use early_ioremap(), I'm open to other suggestions though.
> 
> ioremap() is available after paging_init() has been called.
> 
> Just x86 has this extra bits so you can use early_ioremap/unmap
> _AFTER_ paging_init(). No idea why, but probably to cope with some
> brilliant init calls which run pre and post paging_init().

Good idea, will use an initcall function for this purpose.
Thanks a lot.
Dave
