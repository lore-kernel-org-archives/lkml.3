Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127Ab3FNHz6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 03:55:58 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:41367 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab3FNHz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 03:55:57 -0400
From: Rojhalat Ibrahim <imr@rtschenk.de>
To: Scott Wood <scottwood@freescale.com>
Cc: Michael Guntsche <michael.guntsche@it-loops.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] PCI related panic on powerpc based board with 3.10-rcX
Date: Fri, 14 Jun 2013 09:55:50 +0200
Message-ID: <6071007.YKP3JmbiTP@pcimr>
User-Agent: KMail/4.10.3 (Linux/3.4.26; KDE/4.10.3; x86_64; ; )
In-Reply-To: <1371142157.2028.9@snotra>
References: <1370971739.18413.27@snotra> <7706620.VNI3PE9pqO@pcimr> <1371142157.2028.9@snotra>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 June 2013 11:49:17 Scott Wood wrote:
> On 06/13/2013 02:21:24 AM, Rojhalat Ibrahim wrote:
> > On Wednesday 12 June 2013 16:50:26 Scott Wood wrote:
> > > On 06/12/2013 03:19:30 AM, Rojhalat Ibrahim wrote:
> > > > On Tuesday 11 June 2013 12:28:59 Scott Wood wrote:
> > > > > Yes, I figured it was non-PCIe because the code change that you
> > 
> > said
> > 
> > > > > helped was on the non-PCIe branch of the if/else.  Generally
> > 
> > it's
> > 
> > > > good
> > > > 
> > > > > to explicitly mention the chip you're using, though.
> > > > > 
> > > > > fsl_setup_indirect_pci should be renamed to
> > 
> > fsl_setup_indirect_pcie.
> > 
> > > > > Your patch above should be applied, and fsl_setup_indirect_pcie
> > > > 
> > > > should
> > > > 
> > > > > be moved into the booke/86xx ifdef to avoid an unused function
> > > > 
> > > > warning.
> > > > 
> > > > > -Scott
> > > > 
> > > > How about this patch? It uses setup_indirect_pci for the PCI case
> > 
> > in
> > 
> > > > mpc83xx_add_bridge. Additionally it adds a check in
> > > > fsl_setup_indirect_pci
> > > > to only use the modified read function in case of PCIe.
> > > 
> > > If we're adding the check to fsl_setup_indirect_pci, there's no
> > 
> > need to
> > 
> > > change the 83xx call back to setup_indirect_pci.  I see that 85xx is
> > > also callirng fsl_setup_indirect_pci for both; it'd be good to be
> > > consistent.
> > > 
> > > In any case, can you send a proper patch with a signoff and commit
> > > message?
> > > 
> > > -Scott
> > 
> > Where is it called for 85xx? As far as I can tell
> > fsl_setup_indirect_pci is
> > called exactly once in fsl_add_bridge and nowhere else (after
> > applying the
> > proposed patch).
> 
> fsl_add_bridge() is where it's called for 85xx.
> 
> > For 83xx the decision between PCI and PCIe has already been made at
> > the point where the setup function is called. So IMO it doesn't make
> > sense
> > to call fsl_setup_indirect_pci and do the check again. Moreover PCIe
> > on 83xx
> > uses a completely different set of functions.
> 
> My concern is consistency.  E.g. if 85xx is using
> fsl_setup_indirect_pci for both, but 83xx isn't, then a developer using
> 83xx could end up breaking 85xx by introducing another PCIe dependency
> in fsl_setup_indirect_pci.  Or an 85xx developer could put something
> non-PCIe-related in fsl_setup_indirect_pci that 83xx would benefit from.
> 
> Alternatively, you could call it fsl_setup_indirect_pcie, and move the
> PCIe check into fsl_add_bridge().
> 
> -Scott

Ok. I'll post a v2 of the patch.

   Rojhalat

