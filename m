Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753Ab3LCO3h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 09:29:37 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48569 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753926Ab3LCO3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 09:29:34 -0500
Date: Tue, 3 Dec 2013 06:30:36 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Frank Haverkamp <haver@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, cody@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, utz.bacher@de.ibm.com, mmarek@suse.cz,
        rmallon@gmail.com, jsvogt@de.ibm.com, MIJUNG@de.ibm.com,
        cascardo@linux.vnet.ibm.com, michael@ibmra.de
Subject: Re: [PATCH 1/6] GenWQE PCI support, health monitoring and recovery
Message-ID: <20131203143036.GC3521@kroah.com>
References: <1383741943-14609-1-git-send-email-haver@linux.vnet.ibm.com>
 <1383741943-14609-2-git-send-email-haver@linux.vnet.ibm.com>
 <20131127192028.GB28409@kroah.com>
 <1386078581.12186.22.camel@oc7383187364.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386078581.12186.22.camel@oc7383187364.ibm.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 03, 2013 at 02:49:41PM +0100, Frank Haverkamp wrote:
> Hi Greg,
> 
> Am Mittwoch, den 27.11.2013, 11:20 -0800 schrieb Greg KH:
> > On Wed, Nov 06, 2013 at 01:45:38PM +0100, Frank Haverkamp wrote:
> > > +/*
> > > + * Flags for extended output (dbg_print)
> > > + *   We define different levels of debugging for the appropriate unit.
> > > + */
> > > +#define dbg_card			0x00000001
> > > +#define dbg_card_ddcb			0x00000004
> > > +#define dbg_card_regs			0x00000008
> > > +#define dbg_card_sglist			0x00000400
> > > +#define dbg_card_pinning		0x00000800
> > > +
> > > +#define genwqe_dprintk(_cd, dbg_unit, fmt, ...) do {			\
> > > +		struct genwqe_dev *__cd = (_cd);			\
> > > +		if ((_cd)->debug & (dbg_unit))				\
> > > +			dev_info(&__cd->pci_dev->dev, fmt,		\
> > > +				 ## __VA_ARGS__);			\
> > > +	} while (0)
> > 
> > Ugh, really?  How is a debugging printk being sent out with dev_info()?
> > 
> > And why not just use dynamic kernel debugging and not create your own
> > masks and macros?  We are trying to make everything use the same
> > infrastructure, please don't create new ones for every individual driver
> > in the kernel, that's a mess.
> 
> I removed the genwqe_dprintk function completely. Our debug flag I kept
> for the moment, because I like to use the kernel hexdump functions to
> print my control blocks for debugging:
> 
>       if (cd->debug & dbg_card_ddcb) {
>              dev_dbg(&pci_dev->dev, "FINISHED DDCB#%d\n", req->num);
>              genwqe_hexdump(pci_dev, pddcb, sizeof(*pddcb));
>       }
> 
> Or is there something allowing me to do those hexdumps with the
> dynamic_debug feature too? dynamic_hex_dump() looks like what I want.

Yes, that is what to use.
