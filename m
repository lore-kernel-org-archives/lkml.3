Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932326Ab3FEU5e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 16:57:34 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:42338 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932259Ab3FEU5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 16:57:31 -0400
Date: Wed, 5 Jun 2013 22:56:38 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-pci@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Jan Beulich <JBeulich@suse.com>, Ingo Molnar <mingo@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH v3 -tip x86/apic 1/2] PCI/MSI: Allocate as many
 multiple-MSIs as requested
Message-ID: <20130605205638.GA5816@breakpoint.cc>
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

On Mon, May 13, 2013 at 11:05:48AM +0200, Alexander Gordeev wrote:
> Note, although the existing 'msi_desc::multiple' field might seem
> redundant, in fact in does not. In general case the number of MSIs a
> PCI device is initialized with is not necessarily the closest power-
> of-two value of the number of MSIs the device will send. Thus, in
> theory it would not be always possible to derive the former from the
> latter and we need to keep them both, to stress this corner case.
> Besides, since 'msi_desc::multiple' is a bitfield, throwing it out
> would not save us any space.

The last paragraph makes me curious. The only place where 'multiple' is set is
in do_setup_msi_irqs() and this uses the next power of two for it. And since a
device is not enabled twice, it is not overridden.
So it should be possible to compute 'multiple' out of 'nvec' but it saves
cycles not do to so. I agree to keep 'multiple' but your argument does not
seem to make sense.
While nitpicking, 'nvec' might deserve a better comment than 'number of
messages' since it holds the number of allocated interrupts. :)

Sebastian
