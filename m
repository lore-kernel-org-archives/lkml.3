Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933870Ab3E1Ju7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 05:50:59 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:58245 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324Ab3E1Ju5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 05:50:57 -0400
Date: Tue, 28 May 2013 11:50:52 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Alexander Gordeev <agordeev@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-pci@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Jan Beulich <JBeulich@suse.com>, Ingo Molnar <mingo@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH v3 -tip x86/apic 1/2] PCI/MSI: Allocate as many
 multiple-MSIs as requested
Message-ID: <20130528095052.GA6764@gmail.com>
References: <cover.1368431413.git.agordeev@redhat.com>
 <8575dc590b819892f366852fe50835efaf579f4f.1368431413.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8575dc590b819892f366852fe50835efaf579f4f.1368431413.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexander Gordeev <agordeev@redhat.com> wrote:

> When multiple MSIs are enabled with pci_enable_msi_block(), the
> requested number of interrupts 'nvec' is rounded up to the nearest
> power-of-two value. The result is then used for setting up the
> number of MSI messages in the PCI device and allocation of
> interrupt resources in the operating system (i.e. vector numbers).
> Thus, in cases when a device driver requests some number of MSIs
> and this number is not a power-of-two value, the extra operating
> system resources (allocated as the result of rounding) are wasted.
> 
> This fix introduces 'msi_desc::nvec' field to address the above
> issue. When non-zero, it will report the actual number of MSIs the
> device will send, as requested by the device driver. This value
> should be used by architectures to properly set up and tear down
> associated interrupt resources.
> 
> Note, although the existing 'msi_desc::multiple' field might seem
> redundant, in fact in does not. In general case the number of MSIs a
> PCI device is initialized with is not necessarily the closest power-
> of-two value of the number of MSIs the device will send. Thus, in
> theory it would not be always possible to derive the former from the
> latter and we need to keep them both, to stress this corner case.
> Besides, since 'msi_desc::multiple' is a bitfield, throwing it out
> would not save us any space.
> 
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>

Would be nice to have an Acked-by from Bjorn for this patch.

Thanks,

	Ingo
