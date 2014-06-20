Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805AbaFTTHF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 15:07:05 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:64035 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbaFTTHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 15:07:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Pratyush Anand <pratyush.anand@st.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Marek Vasut <marex@denx.de>, Russell King <linux@arm.linux.org.uk>,
        Pawel Moll <pawel.moll@arm.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Jingoo Han <jg1.han@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ABRAHAM, KISHON VIJAY" <kishon@ti.com>,
        Richard Zhu <r65037@freescale.com>, Rob Herring <robh+dt@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>, Mohit Kumar <mohit.kumar@st.com>,
        Grant Likely <grant.likely@linaro.org>,
        Kumar Gala <galak@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v2 0/8] Add Keystone PCIe controller driver
Date: Fri, 20 Jun 2014 21:05:30 +0200
Message-ID: <14956334.eDhb2zObBc@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53A46B49.3040009@ti.com>
References: <1402426287-31157-1-git-send-email-m-karicheri2@ti.com> <53A453D1.4040308@ti.com> <53A46B49.3040009@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:P+LPZQDwXQLRq6nWR21gBh3qJ9xRfIGbCkGPKmllJX1
 FDTkB7Ub9ym7qMmz6DqF9IMHRQEFVOe+sge5G8kT7UL+f1W8ky
 SPi1AZHcRjX0VPQqM29I4EMFGHefxXQ/eG73Si1tTWQVtsInbq
 r+RHbJz8jv18BeAtX7PgXw9phWzHp4t0iWec3bp2HERBStr2pw
 FslubzTc7LOrLwhVQpPIYktEV9DR+jqGHorf9Z3q3Io9K6A9gp
 WwLklEEFzVQY89BIfcSmhg/GJrujKzSe36q3QRUe/r9/FlKdEC
 CBDW6+zQhE4thd7HkEtdqdHg8CwjQ0ux0mNQUi4asezl+AR1c/
 gopXmyFlCfwWEnYZ+G44=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 June 2014 13:11:37 Santosh Shilimkar wrote:
> > 
> > Unfortunately I lost Jingoo's email from my Inbox. So I cut-n-paste the comment from
> > internet and respond.
> > 
> > Jingoo Han wrote:-
> > =============================================================================
> > I think so, too.
> > 
> > DT maintainers and arch maintainers should review the following
> > dt bindings.
> >   .../devicetree/bindings/pci/designware-pcie.txt    |   42 ++
> >   .../devicetree/bindings/pci/pci-keystone.txt       |   56 +++
> > Generic PHY maintainer (Kishon Vijay Abraham I) should review the
> > following phy driver.
> >   drivers/phy/phy-keystone-serdes.c
> > 
> >>
> >> I'm looking for acks from Mohit and/or Jingoo for the pci/host
> >> changes, and from Arnd for the devicetree/bindings changes.
> >>
> >> Adding these "-dw-3_64" files is sort of ugly.  If that code is only
> >> used by keystone, maybe it could just be moved to pci-keystone.c?  But
> >> I'll defer to Mohit and Jingoo on that and the way you modify
> >> pcie-designware.c.
> > 
> > I agree with Bjorn Helgaas's opinion. These three "-dw-3_64" files
> > look terrible! I don't have a good way to handle this; however,
> > moving this code to pci-keystone.c looks better.
> > ======================================================================
> > 
> > The original RFC I had submitted had all of the application space register
> > handling code as part of the Keystone PCI driver. As per Arnd's comment (See
> > my change log against v1), the code was moved to a separate file so that
> > the next driver that has same version of the DW hw could re-use this code.
> > I agree with Arnd and moved the code to v_3_65 specific files.  What is
> > your proposal?  Do you have objection to the file name? or it's content?
> > 
> > If objection is on the file name,  please suggest alternate names. If you
> > are okay with the file name, and doesn't like the code, it will be helpful
> > to review the code and provide specific comments against the patch itself
> > so that I can address the same.
> > 
> Arnd suggestion was to have the version 3.65 code in generic place since
> its IP specific and just in case some other vendor using the same version
> can leverage the code.
> 
> Concern here seems toe really those name of the files. I can't think of
> any other appropriate name. 

We should definitely keep the version in the DT "compatible" strings
wherever we know it. Regarding a better file name, I have no idea.

	Arnd
