Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757751Ab3FEV3e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:29:34 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:42597 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755418Ab3FEV3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:29:32 -0400
Date: Wed, 5 Jun 2013 23:28:41 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Alexander Gordeev <agordeev@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Jan Beulich <JBeulich@suse.com>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v3 -tip x86/apic 1/2] PCI/MSI: Allocate as many
 multiple-MSIs as requested
Message-ID: <20130605212841.GB5816@breakpoint.cc>
References: <cover.1368431413.git.agordeev@redhat.com>
 <8575dc590b819892f366852fe50835efaf579f4f.1368431413.git.agordeev@redhat.com>
 <20130605205638.GA5816@breakpoint.cc>
 <CAErSpo5hJYhWpBfN6GpyPv-ViaYNXyyLtw96xcN59CtQjfZi6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo5hJYhWpBfN6GpyPv-ViaYNXyyLtw96xcN59CtQjfZi6w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-Suresh

On Wed, Jun 05, 2013 at 03:09:34PM -0600, Bjorn Helgaas wrote:
> 
> Alexander had an example device that advertised 16 vectors, but the
> driver knew that it could only generate 6.  That's a case where we
> can't compute 'multiple' from 'nvec' (assuming the driver supplies
> 'nvec == 6').  If we just rounded up to compute 'multiple', I think
> we'd compute 8 instead of 16.

Sure, but as I said: the only place where 'multiple' is computed / written
it is doing the round-up thingy.

> > While nitpicking, 'nvec' might deserve a better comment than 'number of
> > messages' since it holds the number of allocated interrupts. :)
> 
> I did change the name 'nvec' to 'nvec_used', which should help a bit.
> But I agree that it's still somewhat confusing.
> 
> BTW, the patches actually in my tree are at
> http://git.kernel.org/cgit/linux/kernel/git/helgaas/pci.git/log/?h=pci/alexander-msi
> (I tweaked this name and some comments slightly).

'nvec_used' is better the comment next to it is still wrong I think.

> Bjorn

Sebastian
