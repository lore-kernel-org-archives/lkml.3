Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752458Ab3HOWyU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 18:54:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20636 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751767Ab3HOWyT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 18:54:19 -0400
Message-ID: <1376607255.13642.155.camel@ul30vt.home>
Subject: Re: [PATCH] i915: Update VGA arbiter support for newer devices
From: Alex Williamson <alex.williamson@redhat.com>
To: Dave Airlie <airlied@gmail.com>
Cc: "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        Dave Airlie <airlied@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Ville =?ISO-8859-1?Q?Syrj=E4l=E4?= 
	<ville.syrjala@linux.intel.com>
Date: Thu, 15 Aug 2013 16:54:15 -0600
In-Reply-To: <CAPM=9twr6Ho7PCFdL9GubzDNPedO9tBvC1YPofpkJ01Avx=8_g@mail.gmail.com>
References: <20130815223917.27890.28003.stgit@bling.home>
	 <CAPM=9twr6Ho7PCFdL9GubzDNPedO9tBvC1YPofpkJ01Avx=8_g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-08-16 at 08:49 +1000, Dave Airlie wrote:
> On Fri, Aug 16, 2013 at 8:43 AM, Alex Williamson
> <alex.williamson@redhat.com> wrote:
> > This is intended to add VGA arbiter support for Intel HD graphics on
> > Core processors.  The old GMCH registers no longer exist, so even
> > though it appears that i915 participates in VGA arbitration, it doesn't
> > work.  On Intel HD graphics we already attempt to disable VGA regions
> > of the device.  This makes registering as a VGA client unnecessary since
> > we don't intend to operate differently depending on how many VGA devices
> > are present.  We can disable VGA memory regions by clearing a memory
> > enable bit in the VGA MSR.  That only leaves VGA IO, which we update
> > the VGA arbiter to know that we don't participate in VGA memory
> > arbitration.  We also add a hook on unload to re-enable memory and
> > reinstate VGA memory arbitration.
> 
> I would think there is still a VGA disable bit on the Intel device
> somewhere, we'd just need
> Intel to look in the docs and find it. A bit that can nuke both i/o
> and cmd regs.

The only bit available is in the GGC and is a keyed/locked register that
not only disables VGA memory and I/O, but also modifies the class code
of the device.  Early Core processors didn't lock this, but it's
untouchable in newer ones AFAICT.  Thanks,

Alex

