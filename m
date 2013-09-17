Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252Ab3IQOa3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 10:30:29 -0400
Received: from ozlabs.org ([203.10.76.45]:37232 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752790Ab3IQOa0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 10:30:26 -0400
Date: Wed, 18 Sep 2013 00:30:23 +1000
From: Michael Ellerman <michael@ellerman.id.au>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Jan Beulich <JBeulich@suse.com>, Bjorn Helgaas <bhelgaas@google.com>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v2 2/6] PCI/MSI: Factor out pci_get_msi_cap() interface
Message-ID: <20130917143022.GA7707@concordia>
References: <20130905150442.GA24148@htj.dyndns.org>
 <20130905154041.GD30984@dhcp-26-207.brq.redhat.com>
 <20130905154436.GC24148@htj.dyndns.org>
 <20130905185440.GA13175@dhcp-26-207.brq.redhat.com>
 <20130905200608.GA3846@htj.dyndns.org>
 <CAErSpo4TU2geqzY3AYsL08KimBqtfwa4iUoFHgcFt0zMTBJkHw@mail.gmail.com>
 <20130906160621.GF22763@mtj.dyndns.org>
 <20130906233205.GF12956@google.com>
 <20130909152044.GA24962@dhcp-26-207.brq.redhat.com>
 <20130916102210.GA14102@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130916102210.GA14102@dhcp-26-207.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 16, 2013 at 12:22:11PM +0200, Alexander Gordeev wrote:
> On Mon, Sep 09, 2013 at 05:20:44PM +0200, Alexander Gordeev wrote:
> > On Fri, Sep 06, 2013 at 05:32:05PM -0600, Bjorn Helgaas wrote:
> > > I propose that you rework it that way, and at least find out what
> > > (if anything) would break if we do that.  Or maybe we just give up
> > > some optimization; it would be nice to quantify that, too.
> > 
> > Hi Bjorn,
> > 
> > The series is what it seems a direction to take.
> > 
> > Looks like we need PPC folks to agree on the quota check update
> > for pSeries (yes, they do bail out with a positive return value
> > from arch_msi_check_device()):
> 
> Hi Ben,
> 
> An initiative to simplify MSI/MSI-X allocation interface is brewing.
> It seems pSeries quota thing is an obstacle. If it could be given up
> (patch 2/9).

How about no?

We have a small number of MSIs available, limited by hardware &
firmware, if we don't impose a quota then the first device that probes
will get most/all of the MSIs and other devices miss out.

Anyway I don't see what problem you're trying to solve? I agree the
-ve/0/+ve return value pattern is ugly, but it's hardly the end of the
world.

cheers
