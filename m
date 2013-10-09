Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849Ab3JIPy0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 11:54:26 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:47679 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754410Ab3JIPyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 11:54:22 -0400
Date: Wed, 9 Oct 2013 11:54:13 -0400
From: Tejun Heo <tj@kernel.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>, Andy King <acking@vmware.com>,
        Jon Mason <jon.mason@intel.com>,
        Matt Porter <mporter@kernel.crashing.org>, linux-pci@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-mips@linux-mips.org,
        linuxppc-dev@lists.ozlabs.org, linux390@de.ibm.com,
        linux-s390@vger.kernel.org, x86@kernel.org, linux-ide@vger.kernel.org,
        iss_storagedev@hp.com, linux-nvme@lists.infradead.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        e1000-devel@lists.sourceforge.net, linux-driver@qlogic.com,
        Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        "VMware, Inc." <pv-drivers@vmware.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH RFC 07/77] PCI/MSI: Re-design MSI/MSI-X interrupts
 enablement pattern
Message-ID: <20131009155413.GD22495@htj.dyndns.org>
References: <cover.1380703262.git.agordeev@redhat.com>
 <d8c36203ada6efbfa9f7ce92c2f713ee3b6d6b8d.1380703262.git.agordeev@redhat.com>
 <20131007181749.GB27396@htj.dyndns.org>
 <20131008074826.GD10669@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131008074826.GD10669@dhcp-26-207.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Alexander.

On Tue, Oct 08, 2013 at 09:48:26AM +0200, Alexander Gordeev wrote:
> > If there are many which duplicate the above pattern, it'd probably be
> > worthwhile to provide a helper?  It's usually a good idea to reduce
> > the amount of boilerplate code in drivers.
> 
> I wanted to limit discussion in v1 to as little changes as possible.
> I 'planned' those helper(s) for a separate effort if/when the most
> important change is accepted and soaked a bit.

The thing is doing it this way generates more churns and noises.  Once
the simpler ones live behind a wrapper which can be built on the
existing interface, we can have both reduced cost and more latitude on
the complex cases.

> > If we do things this way, it breaks all drivers using this interface
> > until they're converted, right?
> 
> Right. And the rest of the series does it.

Which breaks bisection which we shouldn't do.

> > Also, it probably isn't the best idea
> > to flip the behavior like this as this can go completely unnoticed (no
> > compiler warning or anything, the same function just behaves
> > differently).  Maybe it'd be a better idea to introduce a simpler
> > interface that most can be converted to?
> 
> Well, an *other* interface is a good idea. What do you mean with the
> simpler here?

I'm still talking about a simpler wrapper for common cases, which is
the important part anyway.

Thanks.

-- 
tejun
