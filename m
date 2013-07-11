Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695Ab3GKU7E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 16:59:04 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:53223 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756624Ab3GKU7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 16:59:02 -0400
Date: Thu, 11 Jul 2013 13:59:02 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "open list:INTEL IOMMU (VT-d)" <iommu@lists.linux-foundation.org>
Subject: Re: WARNING: at drivers/iommu/dmar.c:484 warn_invalid_dmar with
 Intel Motherboard
Message-ID: <20130711205902.GB22605@roeck-us.net>
References: <20130709202406.GA11867@roeck-us.net>
 <CAErSpo6Ma1TnBP-UGGhWFN1rj48y+yTS=VmVw_s30_FWgjfdpg@mail.gmail.com>
 <20130709223106.GA16429@roeck-us.net>
 <20130709232252.GB2676@sequoia2.sous-sol.org>
 <20130709234331.GA10833@roeck-us.net>
 <20130711190054.GC24833@sequoia2.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130711190054.GC24833@sequoia2.sous-sol.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 11, 2013 at 12:00:54PM -0700, Chris Wright wrote:
> * Guenter Roeck (linux@roeck-us.net) wrote:
> > On Tue, Jul 09, 2013 at 04:22:52PM -0700, Chris Wright wrote:
> > > One thing I've seen is the BIOS zeroing the base register address when
> > > VT-d is disabled in BIOS.  So, Guenter, a "fix" may be simply enabling
> > > VT-d in the BIOS.
> > > 
> > Ah, yes, I think I may have that disabled. I'll check it tonight.
> 
> Did you find out if BIOS change fixed this?
> 
No, it didn't. Enabling or disabling virtualization in the BIOS did not make
a difference. It looks like there is a bad DMAR table entry (with address 0)
in the ACPI data. In case you are interested how it looks like:

DMAR @ 0xcb3f3f90
  0000: 44 4d 41 52 90 00 00 00 01 d5 49 4e 54 45 4c 20  DMAR......INTEL
  0010: 44 48 38 37 52 4c 20 20 40 01 00 00 49 4e 54 4c  DH87RL  @...INTL
  0020: 01 00 00 00 26 00 00 00 00 00 00 00 00 00 00 00  ....&...........
  0030: 00 00 10 00 01 00 00 00 00 00 00 00 00 00 00 00  ................
  0040: 01 00 30 00 00 00 00 00 00 b0 eb cb 00 00 00 00  ..0.............
  0050: ff 9f ec cb 00 00 00 00 01 08 00 00 00 00 1d 00  ................
  0060: 01 08 00 00 00 00 1a 00 01 08 00 00 00 00 14 00  ................
  0070: 01 00 20 00 00 00 00 00 00 00 00 d7 00 00 00 00  .. .............
  0080: ff ff 1f df 00 00 00 00 01 08 00 00 00 00 02 00  ................

Turns out the i7-4770K doesn't support VT-d, so my current understanding
is that there should be no DMAR table in the first place.

Guenter
