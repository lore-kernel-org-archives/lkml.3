Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219Ab3JBHYn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 03:24:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12237 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752784Ab3JBHYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 03:24:38 -0400
Date: Wed, 2 Oct 2013 09:26:30 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Mark Lord <kernel@start.ca>
Cc: Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Jan Beulich <JBeulich@suse.com>, Bjorn Helgaas <bhelgaas@google.com>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v2 2/6] PCI/MSI: Factor out pci_get_msi_cap() interface
Message-ID: <20131002072629.GB29860@dhcp-26-207.brq.redhat.com>
References: <CAErSpo4TU2geqzY3AYsL08KimBqtfwa4iUoFHgcFt0zMTBJkHw@mail.gmail.com>
 <20130906160621.GF22763@mtj.dyndns.org>
 <20130906233205.GF12956@google.com>
 <20130909152044.GA24962@dhcp-26-207.brq.redhat.com>
 <20130916102210.GA14102@dhcp-26-207.brq.redhat.com>
 <20130917143022.GA7707@concordia>
 <20130918094759.GA2353@dhcp-26-207.brq.redhat.com>
 <52442975.9000603@start.ca>
 <20130926130328.GD16774@dhcp-26-207.brq.redhat.com>
 <524B8908.8080607@start.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524B8908.8080607@start.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 01, 2013 at 10:46:32PM -0400, Mark Lord wrote:
> >>> The last pattern makes most of sense to me and could be updated with a more
> >>> clear sequence - a call to (bit modified) pci_msix_table_size() followed
> >>> by a call to pci_enable_msix(). I think this pattern can effectively
> >>> supersede the currently recommended "loop" practice.
> >>
> >> The loop is still necessary, because there's a race between those two calls,
> >> so that pci_enable_msix() can still fail due to lack of MSIX slots.
> > 
> > Moreover, the existing loop pattern is racy and could fail just as easily ;)
> 
> Yes, but it then loops again to correct things.

No. If it failed it should exit the loop.

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
