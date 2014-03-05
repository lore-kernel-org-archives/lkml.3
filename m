Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730AbaCEIQl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 03:16:41 -0500
Received: from service87.mimecast.com ([91.220.42.44]:56591 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbaCEIQi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 03:16:38 -0500
Date: Wed, 5 Mar 2014 08:16:33 +0000
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Tanmay Inamdar <tinamdar@apm.com>
Cc: linux-pci <linux-pci@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v5 5/7] pci: Use parent domain number when allocating
 child busses.
Message-ID: <20140305081633.GC1692@e106497-lin.cambridge.arm.com>
Mail-Followup-To: Tanmay Inamdar <tinamdar@apm.com>,
	linux-pci <linux-pci@vger.kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <Catalin.Marinas@arm.com>,
	Will Deacon <Will.Deacon@arm.com>,
	linaro-kernel <linaro-kernel@lists.linaro.org>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	LAKML <linux-arm-kernel@lists.infradead.org>,
	Arnd Bergmann <arnd@arndb.de>
References: <1393948204-11555-1-git-send-email-Liviu.Dudau@arm.com>
 <1393948204-11555-6-git-send-email-Liviu.Dudau@arm.com>
 <CACoXjcmKKObSFignRWZAuOmmvfFtLf5O04Y5romJ=c6a9Jriqg@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CACoXjcmKKObSFignRWZAuOmmvfFtLf5O04Y5romJ=c6a9Jriqg@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 05 Mar 2014 08:16:34.0080 (UTC) FILETIME=[38A0D200:01CF384B]
X-MC-Unique: 114030508163602301
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2014 at 01:49:13AM +0000, Tanmay Inamdar wrote:
> Hello,
> 
> On Tue, Mar 4, 2014 at 7:50 AM, Liviu Dudau <Liviu.Dudau@arm.com> wrote:
> > pci_alloc_child_bus() uses the newly allocated child bus to figure
> > out the domain number that is going to use for setting the device
> > name. A better option is to use the parent bus domain number.
> >
> > Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
> >
> > diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> > index 26237a0..a12cda5 100644
> > --- a/drivers/pci/probe.c
> > +++ b/drivers/pci/probe.c
> > @@ -677,7 +677,7 @@ static struct pci_bus *pci_alloc_child_bus(struct pci_bus *parent,
> >          * now as the parent is not properly set up yet.
> >          */
> >         child->dev.class = &pcibus_class;
> > -       dev_set_name(&child->dev, "%04x:%02x", pci_domain_nr(child), busnr);
> > +       dev_set_name(&child->dev, "%04x:%02x", pci_domain_nr(parent), busnr);
> >
> >         /*
> >          * Set up the primary, secondary and subordinate
> > --
> > 1.9.0
> >
> 
> This patch is not required after the fix in pci_domain_nr for arm64.
> 

True. Thanks for testing this!

Liviu

-- 
====================
| I would like to |
| fix the world,  |
| but they're not |
| giving me the   |
 \ source code!  /
  ---------------
    ¯\_(ツ)_/¯

