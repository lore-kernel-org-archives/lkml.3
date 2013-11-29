Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550Ab3K2Rwr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 12:52:47 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40868 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224Ab3K2Rwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 12:52:43 -0500
Date: Fri, 29 Nov 2013 09:53:36 -0800
From: Greg KH <greg@kroah.com>
To: Veaceslav Falico <vfalico@redhat.com>, Neil Horman <nhorman@tuxdriver.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
        Knut Petersen <Knut_Petersen@t-online.de>,
        Ingo Molnar <mingo@kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PCI: export MSI mode using attributes, not kobjects
Message-ID: <20131129175336.GA6152@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131129031419.GB5889@neilslaptop.think-freely.org>
 <20131129094137.GC3028@redhat.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 29, 2013 at 10:41:37AM +0100, Veaceslav Falico wrote:
> On Wed, Nov 27, 2013 at 10:46:52AM -0800, Greg Kroah-Hartman wrote:
> >From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >
> >The PCI MSI sysfs code is a mess with kobjects for things that don't
> >really need to be kobjects.  This patch creates attributes dynamically
> >for the MSI interrupts instead of using kobjects.
> >
> >Note, this removes a directory from the current MSI interrupt sysfs
> >code:
> >
> >old MSI kobjects:
> >pci_device
> >   └── msi_irqs
> >       └── 40
> >           └── mode
> >
> >new MSI attributes:
> >pci_device
> >   └── msi_irqs
> >       └── 40
> >
> >As there was only one file "mode" with the kobject model, the interrupt
> >number is now a file that returns the "mode" of the interrupt (msi vs.
> >msix).
> >
> >Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> Works like a charm for me.
> 
> FWIW,
> 
> Reviewed-by: Veaceslav Falico <vfalico@redhat.com>

On Thu, Nov 28, 2013 at 10:14:19PM -0500, Neil Horman wrote:
> ACK, Testing with git-head irqbalance on F19 with this patch and it works fine.
> 
> Thanks!
> Acked-by: Neil Horman <nhorman@tuxdriver.com>

Great, thanks for both of you testing this.

Bjorn, any objection to take this through your tree for 3.14-rc1?

thanks,

gre k-h
