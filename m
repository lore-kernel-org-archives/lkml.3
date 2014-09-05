Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842AbaIEWLn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 18:11:43 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:44313 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752AbaIEWLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 18:11:38 -0400
Date: Fri, 5 Sep 2014 16:11:31 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Liviu Dudau <liviu@dudau.co.uk>, Liviu Dudau <Liviu.Dudau@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        linux-pci <linux-pci@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v9 04/12] PCI: OF: Fix the conversion of IO ranges into
 IO resources.
Message-ID: <20140905221131.GJ8080@google.com>
References: <1407860725-25202-1-git-send-email-Liviu.Dudau@arm.com>
 <1407860725-25202-5-git-send-email-Liviu.Dudau@arm.com>
 <CAL_JsqJm6qWNdrJ2F8xddFUj46y42n6hQVu1nkTaA-5Tbg--XQ@mail.gmail.com>
 <20140822130640.GM13147@bart.dudau.co.uk>
 <CAL_JsqLGa3em5Phct-H0Q=vB5AnA78h19uA=4xi3xHA1rCVq+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_JsqLGa3em5Phct-H0Q=vB5AnA78h19uA=4xi3xHA1rCVq+A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 24, 2014 at 06:27:48PM -0500, Rob Herring wrote:
> On Fri, Aug 22, 2014 at 8:06 AM, Liviu Dudau <liviu@dudau.co.uk> wrote:
> > mips is doing the same thing and I believe is not affected, pci-host-generic.c
> > was adjusting the returned values afterwards so that will not be needed and Lorenzo
> > has a patch for the driver to adapt it to this series anyway.
> >
> > pcie-designware.c also recalculates the io.start and io.end values, so that's fine
> > for now. The only ones that I believe are still affected are pci-tegra.c and
> > pcie-rcar.c for which I will need to provide a patch similar to integrator unless
> > the code gets converted to the new range parsing.
> 
> Well, the latter would be nice, but they certainly have to be fixed.
> Now that I think about it, this needs to be handled in a bisectable
> way. So I think you need to fix all affected platforms in this patch
> rather than a separate patch as you have done.

Yep, I was about to complain that the "ARM: integrator: Correct usage of
of_pci_range_to_resource()" patch needs to be squashed into whatever broke
it, but I see Rob already caught that.

Bjorn
