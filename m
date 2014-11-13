Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933522AbaKMPc1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 10:32:27 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:57646 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752659AbaKMPc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 10:32:26 -0500
Date: Thu, 13 Nov 2014 15:32:28 +0000
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Cc: Will Deacon <Will.Deacon@arm.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        arnd@arndb.de, robh+dt@kernel.org
Subject: Re: [PATCH 2/2] PCI: generic: Add set_msi_parent callback
Message-ID: <20141113153228.GC9726@red-moon>
References: <1415647480-3320-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1415647480-3320-3-git-send-email-suravee.suthikulpanit@amd.com>
 <20141111112424.GB16265@arm.com>
 <54622C58.1040701@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54622C58.1040701@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CC'ing Arnd and RobH]

On Tue, Nov 11, 2014 at 03:33:44PM +0000, Suravee Suthikulpanit wrote:
> On 11/11/14 18:24, Will Deacon wrote:
> >> @@ -313,6 +324,9 @@ static int gen_pci_probe(struct platform_device *pdev)
> >> >  		return err;
> >> >  	}
> >> >
> >> >+	pci->mchip = of_pci_find_msi_chip_by_node(of_parse_phandle(np,
> >> >+						  "msi-parent", 0));
> > This bit should be in the generic of_pci.c code and not duplicated for
> > each host controller.
> >
> > Will
> 
> I forgot to mention and include in the patch that we are also 
> introducing "msi-parent" binding to the generic host controller. I'll do 
> that in v2.
> 
> Unless this is something that we would like to add to the generic OF 
> binding for PCI, I think it should be in the pci-host-generic.c.

Is there a reason why we do *not* want to add this property to generic OF
PCI binding ?

Thanks,
Lorenzo
