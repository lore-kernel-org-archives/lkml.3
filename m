Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261Ab3IZOhO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 10:37:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28994 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752072Ab3IZOhK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 10:37:10 -0400
Date: Thu, 26 Sep 2013 16:39:02 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Jan Beulich <JBeulich@suse.com>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v2 2/6] PCI/MSI: Factor out pci_get_msi_cap() interface
Message-ID: <20130926143901.GE16774@dhcp-26-207.brq.redhat.com>
References: <20130918094759.GA2353@dhcp-26-207.brq.redhat.com>
 <20130918142231.GA21650@mtj.dyndns.org>
 <20130918165045.GB2353@dhcp-26-207.brq.redhat.com>
 <20130920082458.GA10507@dhcp-26-207.brq.redhat.com>
 <20130920122736.GD7630@mtj.dyndns.org>
 <20130925180220.GB26273@google.com>
 <20130925205804.GA21737@dhcp-26-207.brq.redhat.com>
 <20130925210016.GA8926@htj.dyndns.org>
 <20130926074646.GA16774@dhcp-26-207.brq.redhat.com>
 <20130926131147.GA31249@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130926131147.GA31249@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 26, 2013 at 09:11:47AM -0400, Tejun Heo wrote:
> > Because otherwise we will re-introduce a problem described by Michael:
> > "We have a small number of MSIs available, limited by hardware &
> > firmware, if we don't impose a quota then the first device that probes
> > will get most/all of the MSIs and other devices miss out."
> 
> Still not following.  Why wouldn't just letting the drivers request
> the optimal number they want and falling back to single interrupt mode
> work?  ie. why can't we just have an all or nothing interface?

I can imagine a scenario where the first device probes in, requests its
optimal number, acquires that number and exhausts MSIs in pSeries firmware.
The next few devices possibly end up with single MSI, since no MSIs left
to satisfy their optimal numbers. If one of those single-MSI'ed devices
happened to be a high-performance HBA hitting a degraded performance that
alone would force (IBM) to introduce the quotas. Now, if the same/another
device happened does not support the legacy interrupt mode and no MSI
resources have left in the platform firmware at all...

> tejun

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
