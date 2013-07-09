Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243Ab3GIXni (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 19:43:38 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:32791 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754110Ab3GIXne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 19:43:34 -0400
Date: Tue, 9 Jul 2013 16:43:31 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "open list:INTEL IOMMU (VT-d)" <iommu@lists.linux-foundation.org>
Subject: Re: WARNING: at drivers/iommu/dmar.c:484 warn_invalid_dmar with
 Intel Motherboard
Message-ID: <20130709234331.GA10833@roeck-us.net>
References: <20130709202406.GA11867@roeck-us.net>
 <CAErSpo6Ma1TnBP-UGGhWFN1rj48y+yTS=VmVw_s30_FWgjfdpg@mail.gmail.com>
 <20130709223106.GA16429@roeck-us.net>
 <20130709232252.GB2676@sequoia2.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130709232252.GB2676@sequoia2.sous-sol.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 09, 2013 at 04:22:52PM -0700, Chris Wright wrote:
> * Guenter Roeck (linux@roeck-us.net) wrote:
> > On Tue, Jul 09, 2013 at 03:05:39PM -0600, Bjorn Helgaas wrote:
> > > [+cc Joerg, David, iommu list]
> > > 
> > > On Tue, Jul 9, 2013 at 2:24 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> > > > I started seeing this problem after updating the BIOS trying fix another issue,
> > > > though I may have missed it earlier.
> > > >
> > > > I understand this is a BIOS bug. Would be great if someone can pass this on
> > > > to Intel BIOS engineers.
> > > 
> > > Maybe.  It'd be nice if Linux handled it better, though.
> > > 
> > If anyone has an idea how to do that, I'll be happy to write a patch.
> 
> I'm not sure there's much you can do.  The BIOS is saying there's a DMAR
> unit, and then saying the registers are at addr 0x0.  The kernel is
> simply warning you about the invalid DMAR table entry.
> 
> One thing I've seen is the BIOS zeroing the base register address when
> VT-d is disabled in BIOS.  So, Guenter, a "fix" may be simply enabling
> VT-d in the BIOS.
> 
Ah, yes, I think I may have that disabled. I'll check it tonight.

Does that really warrant a traceback, or would a warning message be more
appropriate (possibly telling the user to enable VT-d) ?

Thanks,
Guenter
