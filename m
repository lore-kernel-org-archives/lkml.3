Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272Ab3FQNPk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 09:15:40 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:35942 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755490Ab3FQNPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 09:15:39 -0400
From: Rojhalat Ibrahim <imr@rtschenk.de>
To: Scott Wood <scottwood@freescale.com>
Cc: Michael Guntsche <michael.guntsche@it-loops.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] powerpc/pci: Fix setup of Freescale PCI / PCIe controllers
Date: Mon, 17 Jun 2013 15:15:33 +0200
Message-ID: <2435509.QyTW5GJC53@pcimr>
User-Agent: KMail/4.10.3 (Linux/3.4.26; KDE/4.10.3; x86_64; ; )
In-Reply-To: <1371241083.2996.7@snotra>
References: <1371241083.2996.7@snotra>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 June 2013 15:18:03 Scott Wood wrote:
> On 06/14/2013 04:05:34 AM, Rojhalat Ibrahim wrote:
> > Commit 50d8f87d2b3 (powerpc/fsl-pci Make PCIe hotplug work with
> > Freescale
> > PCIe controllers) does not handle non-PCIe controllers properly,
> > which causes
> > a panic during boot for certain configurations.
> > This patch fixes the issue by calling setup_indirect_pci for all
> > device types.
> > fsl_indirect_read_config is now only used for booke/86xx PCIe
> > controllers.
> > 
> > Reported-by: Michael Guntsche <mike@it-loops.com>
> > Cc: Scott Wood <scottwood@freescale.com>
> > Signed-off-by: Rojhalat Ibrahim <imr@rtschenk.de>
> > ---
> > v2: Make it more consistent.
> > 
> >  arch/powerpc/sysdev/fsl_pci.c |   20 +++++++-------------
> >  1 file changed, 7 insertions(+), 13 deletions(-)
> > 
> > diff --git a/arch/powerpc/sysdev/fsl_pci.c
> > b/arch/powerpc/sysdev/fsl_pci.c
> > index 028ac1f..5682c8a 100644
> > --- a/arch/powerpc/sysdev/fsl_pci.c
> > +++ b/arch/powerpc/sysdev/fsl_pci.c
> > @@ -97,20 +97,12 @@ static int fsl_indirect_read_config(struct
> > pci_bus *bus,
> > unsigned int devfn,
> > 
> >  	return indirect_read_config(bus, devfn, offset, len, val);
> >  
> >  }
> > 
> > -static struct pci_ops fsl_indirect_pci_ops =
> > +static struct pci_ops fsl_indirect_pcie_ops =
> > 
> >  {
> >  
> >  	.read = fsl_indirect_read_config,
> >  	.write = indirect_write_config,
> >  
> >  };
> 
> On 83xx:
> cc1: warnings being treated as errors
> /home/scott/fsl/git/linux/upstream/arch/powerpc/sysdev/fsl_pci.c:100:23:
> error: 'fsl_indirect_pcie_ops' defined but not used
> make[2]: *** [arch/powerpc/sysdev/fsl_pci.o] Error 1
> make[2]: *** Waiting for unfinished jobs....
> 
> I can fix this when applying, but this makes me wonder how you tested
> it, given that the whole point is to fix 83xx...  Did you fix this and
> then accidentally sent a stale version?
> 
> Also, please be careful that the patch doesn't get line wrapped -- I
> had to manually unwrap a couple places.  Use git send-email if you
> can't get KMail to cooperate.
> 
> -Scott

Sorry about the mess. I'll send a v3.
Please note: I don't have an 83xx system. So I can only test if it compiles, 
which I obviously did not do with the right config.

   Rojhalat


