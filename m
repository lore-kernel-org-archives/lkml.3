Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab3LCNtu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 08:49:50 -0500
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:47846 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404Ab3LCNts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 08:49:48 -0500
Subject: Re: [PATCH 1/6] GenWQE PCI support, health monitoring and recovery
From: Frank Haverkamp <haver@linux.vnet.ibm.com>
Reply-To: haver@linux.vnet.ibm.com
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, cody@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, utz.bacher@de.ibm.com, mmarek@suse.cz,
        rmallon@gmail.com, jsvogt@de.ibm.com, MIJUNG@de.ibm.com,
        cascardo@linux.vnet.ibm.com, michael@ibmra.de
In-Reply-To: <20131127192028.GB28409@kroah.com>
References: <1383741943-14609-1-git-send-email-haver@linux.vnet.ibm.com>
	 <1383741943-14609-2-git-send-email-haver@linux.vnet.ibm.com>
	 <20131127192028.GB28409@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Tue, 03 Dec 2013 14:49:41 +0100
Message-ID: <1386078581.12186.22.camel@oc7383187364.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-30.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13120313-2966-0000-0000-0000098F2485
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Am Mittwoch, den 27.11.2013, 11:20 -0800 schrieb Greg KH:
> On Wed, Nov 06, 2013 at 01:45:38PM +0100, Frank Haverkamp wrote:
> > +/*
> > + * Flags for extended output (dbg_print)
> > + *   We define different levels of debugging for the appropriate unit.
> > + */
> > +#define dbg_card			0x00000001
> > +#define dbg_card_ddcb			0x00000004
> > +#define dbg_card_regs			0x00000008
> > +#define dbg_card_sglist			0x00000400
> > +#define dbg_card_pinning		0x00000800
> > +
> > +#define genwqe_dprintk(_cd, dbg_unit, fmt, ...) do {			\
> > +		struct genwqe_dev *__cd = (_cd);			\
> > +		if ((_cd)->debug & (dbg_unit))				\
> > +			dev_info(&__cd->pci_dev->dev, fmt,		\
> > +				 ## __VA_ARGS__);			\
> > +	} while (0)
> 
> Ugh, really?  How is a debugging printk being sent out with dev_info()?
> 
> And why not just use dynamic kernel debugging and not create your own
> masks and macros?  We are trying to make everything use the same
> infrastructure, please don't create new ones for every individual driver
> in the kernel, that's a mess.

I removed the genwqe_dprintk function completely. Our debug flag I kept
for the moment, because I like to use the kernel hexdump functions to
print my control blocks for debugging:

      if (cd->debug & dbg_card_ddcb) {
             dev_dbg(&pci_dev->dev, "FINISHED DDCB#%d\n", req->num);
             genwqe_hexdump(pci_dev, pddcb, sizeof(*pddcb));
      }

Or is there something allowing me to do those hexdumps with the
dynamic_debug feature too? dynamic_hex_dump() looks like what I want.
So let me try to use that and get rid of my own debug support.

> 
> thanks,
> 
> greg k-h
> 

Regards

Frank



