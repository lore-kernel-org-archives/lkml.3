Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756996AbaH1CJ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 22:09:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58609 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751086AbaH1CJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 22:09:58 -0400
Message-ID: <1409191788.2906.305.camel@ul30vt.home>
Subject: Re: [PATCH] radeon: Test for PCI root bus before assuming bus->self
From: Alex Williamson <alex.williamson@redhat.com>
To: Dave Airlie <airlied@gmail.com>
Cc: Alex Deucher <alexdeucher@gmail.com>,
        "Deucher, Alexander" <alexander.deucher@amd.com>,
        Christian Koenig <christian.koenig@amd.com>,
        Maling list - DRI developers 
	<dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 27 Aug 2014 20:09:48 -0600
In-Reply-To: <CAPM=9twcfXzFMgHEqj4aQAjsrewOfCK6o4ibrJ5ENP1Z8epM8g@mail.gmail.com>
References: <20140827190125.29558.80166.stgit@gimli.home>
	 <CADnq5_MaPBTm-PtCq57KLJqZuxw4qTuZgyzHGqhfQoY95YxYsQ@mail.gmail.com>
	 <CAPM=9twcfXzFMgHEqj4aQAjsrewOfCK6o4ibrJ5ENP1Z8epM8g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-08-28 at 11:32 +1000, Dave Airlie wrote:
> > On Wed, Aug 27, 2014 at 3:01 PM, Alex Williamson
> > <alex.williamson@redhat.com> wrote:
> >> If we assign a Radeon device to a virtual machine, we can no longer
> >> assume a fixed hardware topology, like the GPU having a parent device.
> >> This patch simply adds a few pci_is_root_bus() tests to avoid passing
> >> a NULL pointer to PCI access functions, allowing the radeon driver to
> >> work in a QEMU 440FX machine with an assigned HD8570 on the emulated
> >> PCI root bus.
> >>
> >> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> >
> 
> Does this mean inside a VM we can't enable pcie 2 speeds?

Shouldn't the device already be set to something reasonable before it's
assigned?

> This could lead to a quite disappointing speed decrease for DMA transfers.

We couldn't do it before anyway, there's no decrease.  Even with a Q35
QEMU chipset the best we were doing was tweaking dummy registers on the
upstream port.  Should VFIO be doing bus tuning prior to exposing the
device?  I suppose our other option would be to let the link control
bits of the emulated downstream port pass through to the host.  In any
case, I don't see that this patch limits performance any more than it
already is for a VM.  Thanks,

Alex

