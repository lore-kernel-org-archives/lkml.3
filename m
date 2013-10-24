Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583Ab3JXLjo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 07:39:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40594 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753844Ab3JXLjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 07:39:43 -0400
Date: Thu, 24 Oct 2013 13:41:33 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: David Laight <David.Laight@ACULAB.COM>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ben Hutchings <bhutchings@solarflare.com>, Mark Lord <kernel@start.ca>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pci@vger.kernel.org
Subject: Re: [PATCH RFC v2 12/29] PCI/MSI: Introduce pcim_enable_msi*()
 family helpers
Message-ID: <20131024114133.GA26610@dhcp-26-207.brq.redhat.com>
References: <cover.1382103786.git.agordeev@redhat.com>
 <6bc575621ef70f72b206e4aa944acd32f1a75718.1382103786.git.agordeev@redhat.com>
 <20131024105158.GB13159@mtj.dyndns.org>
 <AE90C24D6B3A694183C094C60CF0A2F6026B73AA@saturn3.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6026B73AA@saturn3.aculab.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 24, 2013 at 11:57:40AM +0100, David Laight wrote:
> The one case it doesn't work is where the driver either
> wants the full number or the minimum number - but not
> a value in between.
> 
> Might be worth adding an extra parameter so that this
> (and maybe other) odd requirements can be met.

IMHO its not worth it, since it is not possible to generalize
all odd requirements out there. I do not think we should blow
the API in this case.

Having said that, the min-or-max interface is probably the only
worth considering. But again, I would prefer to put its semantics
to function name rather than to extra parameters, i.e.

pcim_enable_msix_min_max(struct pci_dev *dev, struct msix_entry *entries,
			 unsigned int minvec, unsigned int maxvec);

> Some static inline functions could be used for the common cases.
> 
> 	David

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
