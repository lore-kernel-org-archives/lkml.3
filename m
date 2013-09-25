Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630Ab3IYU4J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 16:56:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25210 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754901Ab3IYU4G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 16:56:06 -0400
Date: Wed, 25 Sep 2013 22:58:05 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Tejun Heo <tj@kernel.org>, Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Jan Beulich <JBeulich@suse.com>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v2 2/6] PCI/MSI: Factor out pci_get_msi_cap() interface
Message-ID: <20130925205804.GA21737@dhcp-26-207.brq.redhat.com>
References: <20130906233205.GF12956@google.com>
 <20130909152044.GA24962@dhcp-26-207.brq.redhat.com>
 <20130916102210.GA14102@dhcp-26-207.brq.redhat.com>
 <20130917143022.GA7707@concordia>
 <20130918094759.GA2353@dhcp-26-207.brq.redhat.com>
 <20130918142231.GA21650@mtj.dyndns.org>
 <20130918165045.GB2353@dhcp-26-207.brq.redhat.com>
 <20130920082458.GA10507@dhcp-26-207.brq.redhat.com>
 <20130920122736.GD7630@mtj.dyndns.org>
 <20130925180220.GB26273@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130925180220.GB26273@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 12:02:20PM -0600, Bjorn Helgaas wrote:
> On Fri, Sep 20, 2013 at 07:27:36AM -0500, Tejun Heo wrote:
> > On Fri, Sep 20, 2013 at 10:24:59AM +0200, Alexander Gordeev wrote:
> > > * Make pci_enable_msix() return 0/-errno
> > 
> > My choice would be this one.
> 
> I agree; it sounds like you've identified several bugs related to the
> current confusing interface, so fixing that seems like the first step.

Yeah, I am trying to. Turns out to be a nice exercise ;)

> I hope we can avoid adding a plethora of interfaces to address unusual
> corner cases.  But if we do the above and it turns out not to be enough,
> we can always extend it later.

Unfortunately, pSeries is a shows-topper here :( It seems we have to
introduce pci_get_msi{,x}_limit() interfaces to honour the quota
thing.  I just hope the hardware set for pSeries is limited and we
won't need to use it for all drivers.

> Bjorn

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
