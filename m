Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629Ab3J3AdU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 20:33:20 -0400
Received: from top.free-electrons.com ([176.31.233.9]:41849 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751381Ab3J3AdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 20:33:18 -0400
Date: Tue, 29 Oct 2013 21:33:18 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        sachin.kamat@linaro.org, Vinod Koul <vinod.koul@intel.com>,
        dmaengine@vger.kernel.org
Subject: Re: [PATCH 2/2] dma: mv_xor: Use high_base mmio where appropriate
Message-ID: <20131030003317.GD2527@localhost>
References: <1383000855-8377-1-git-send-email-ezequiel.garcia@free-electrons.com>
 <1383000855-8377-2-git-send-email-ezequiel.garcia@free-electrons.com>
 <CAPcyv4iQVoYCXz16T3N4MbdVJV7MoKKeL0wq9t9WF1Kf3gz3Bw@mail.gmail.com>
 <20131029083407.GA2416@localhost>
 <20131029103229.5e095a24@skate>
 <CAPcyv4iRawGxPwcPhyKCHG+2orVNmPktObR7_TSXwN+6tZ=qog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPcyv4iRawGxPwcPhyKCHG+2orVNmPktObR7_TSXwN+6tZ=qog@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 12:15:18PM -0700, Dan Williams wrote:
> On Tue, Oct 29, 2013 at 2:32 AM, Thomas Petazzoni
> <thomas.petazzoni@free-electrons.com> wrote:
> > Dan, Ezequiel,
> >
> > On Tue, 29 Oct 2013 05:34:08 -0300, Ezequiel Garcia wrote:
> >
> >> > On Mon, Oct 28, 2013 at 3:54 PM, Ezequiel Garcia
> >> > <ezequiel.garcia@free-electrons.com> wrote:
> >> > > Despite requesting two memory resources, called 'base' and 'high_base', the
> >> > > driver uses explicitly only the former. The latter is being used implicitly
> >> > > by addressing at offset +0x200, which in practice accesses high_base.
> >> > >
> >> > > Instead of relying in such trick, let's define the registers with the
> >> > > offset from high_base, and use high_base explicitly where appropriate.
> >> > >
> >> > > Signed-off-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
> >> > > ---
> >> > >  drivers/dma/mv_xor.c |  3 ++-
> >> > >  drivers/dma/mv_xor.h | 25 +++++++++++++------------
> >> > >  2 files changed, 15 insertions(+), 13 deletions(-)
> >> >
> >> > Since it's unused I'd prefer a patch that just deletes xor_high_base.
> >> >
> >>
> >> It's wrongly *unused*, the mmio high_base is actually being used
> >> implicitly by always addressing at an offset that addresses +200.
> >>
> >> Deleting high_base would actually make it worse, for that region
> >> will no longer be ioremaped. Maybe the commit message is not clear
> >> about it?
> >
> > I agree with Ezequiel, and I believe his patch is appropriate. The
> > registers for the XOR engines are indeed split in two areas, so it
> > makes sense to have this xor_base / xor_high_base split that reflects
> > the register mapping passed from the Device Tree, and use this split in
> > the macros used to access the registers.
> >
> 
> Ah ok, so it's a bug if an implementation ever puts the second
> resource window at a non 0x200 offset.
> 
> Ezequiel , can you resend the patch to the new

Sure.

> dmaengine@vger.kernel.org list (patchwork queue) and clarify that this
> is a fix rather than a pure cleanup in the changelog?  At least
> cleanup is how I first read it.
> 

By the way, I didn't initially Cced dmaengine list because it's not
in the MAINTAINERS file.

How about we add it and avoid this happening to other developers?

diff --git a/MAINTAINERS b/MAINTAINERS
index ebaf8bd..cd57b4a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1397,6 +1397,15 @@ F:	drivers/dma/
 F:	include/linux/dmaengine.h
 F:	include/linux/async_tx.h
 
+DMAENGINE SUBSYSTEM
+M:	Dan Williams <dan.j.williams@intel.com>
+L:	dmaengine@vger.kernel.org
+S:	Maintained
+F:	Documentation/dmaengine.txt
+F:	drivers/dma/
+F:	include/linux/dma/
+F:	include/linux/dmaengine.h
+
 AT24 EEPROM DRIVER
 M:	Wolfram Sang <wsa@the-dreams.de>
 L:	linux-i2c@vger.kernel.org

I'll submit the patch if you want. Just check the above is correct.
If there's a git repo, it might be good to add is as well.
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
