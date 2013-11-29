Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888Ab3K2DOs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 22:14:48 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56582 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934Ab3K2DOq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 22:14:46 -0500
Date: Thu, 28 Nov 2013 22:14:19 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Veaceslav Falico <vfalico@redhat.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
        Knut Petersen <Knut_Petersen@t-online.de>,
        Ingo Molnar <mingo@kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PCI: export MSI mode using attributes, not kobjects
Message-ID: <20131129031419.GB5889@neilslaptop.think-freely.org>
References: <20131127184652.GA1856@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131127184652.GA1856@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 27, 2013 at 10:46:52AM -0800, Greg Kroah-Hartman wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> The PCI MSI sysfs code is a mess with kobjects for things that don't
> really need to be kobjects.  This patch creates attributes dynamically
> for the MSI interrupts instead of using kobjects.
> 
> Note, this removes a directory from the current MSI interrupt sysfs
> code:
> 
> old MSI kobjects:
> pci_device
>    └── msi_irqs
>        └── 40
>            └── mode
> 
> new MSI attributes:
> pci_device
>    └── msi_irqs
>        └── 40
> 
> As there was only one file "mode" with the kobject model, the interrupt
> number is now a file that returns the "mode" of the interrupt (msi vs.
> msix).
> 
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ---
> 
> Neil, can you test this patch to see if irqbalance works as-is or not?
> 
ACK, Testing with git-head irqbalance on F19 with this patch and it works fine.

Thanks!
Acked-by: Neil Horman <nhorman@tuxdriver.com>

