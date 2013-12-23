Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757465Ab3LWOmb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 09:42:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42533 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753518Ab3LWOma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 09:42:30 -0500
Date: Mon, 23 Dec 2013 15:44:18 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org, Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tejun Heo <tj@kernel.org>, Ben Hutchings <bhutchings@solarflare.com>,
        David Laight <David.Laight@ACULAB.COM>, Mark Lord <kernel@start.ca>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pci@vger.kernel.org
Subject: Re: [PATCH v4 9/9] PCI/MSI: Introduce pci_auto_enable_msi*() family
 helpers
Message-ID: <20131223144418.GA11342@dhcp-26-207.brq.redhat.com>
References: <cover.1387140921.git.agordeev@redhat.com>
 <bbf6f73ef3e16e5dfd7d41fc1e4412f641acb0f3.1387140921.git.agordeev@redhat.com>
 <20131218003002.GA15119@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131218003002.GA15119@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 05:30:02PM -0700, Bjorn Helgaas wrote:
> > +int pci_auto_enable_msi_range(struct pci_dev *dev, struct msix_entry *entries,
> > +			      int minvec, int maxvec)

[...]

> > +If this function returns a positive number it indicates at least the
> > +returned number of MSI interrupts have been successfully allocated (it may
> > +have allocated more in order to satisfy the power-of-two requirement).
> 
> I assume this means the return value may be larger than the "maxvec"
> requested, right?  And the driver is free to use all the vectors up to the
> return value, even those above maxvec, right?

No, the returned value may not be larger than the "maxvec" ever. This is just
paraphrasing the semantics of exisitng pci_enable_msi_block() interface - a
value written to MMC register might be larger than the returned value, but the
driver may not use the extra vectors it did not request.

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
