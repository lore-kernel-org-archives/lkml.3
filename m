Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342AbaI2STE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 14:19:04 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:49240 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538AbaI2STA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 14:19:00 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Liviu Dudau <liviu@dudau.co.uk>,
        linux-arch <linux-arch@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Device Tree ML <devicetree@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jingoo Han <jg1.han@samsung.com>, Liviu Dudau <Liviu.Dudau@arm.com>,
        LKML <linux-kernel@vger.kernel.org>, Will Deacon <Will.Deacon@arm.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Rob Herring <robh+dt@kernel.org>, Tanmay Inamdar <tinamdar@apm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sinan Kaya <okaya@codeaurora.org>
Subject: Re: [PATCH v12 10/12] PCI: Assign unassigned bus resources in pci_scan_root_bus()
Date: Mon, 29 Sep 2014 20:18:02 +0200
Message-ID: <6332476.od04BfvKGr@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <54287AA5.3060408@amd.com>
References: <1411498874-9864-1-git-send-email-Liviu.Dudau@arm.com> <CAErSpo5DR+TPYXBWGKRj9SRPjsbJ6kjZmAH1AXT12txEjGdZGQ@mail.gmail.com> <54287AA5.3060408@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:XoJtpB1Rhv9Hri3ESaAc8Te+9M9+MV1e0a0by5Deqb6
 T/M50M1aA8Js8BBNMIcQm/qLKJwsk2jE1UAbqb/P0fp8MTK7lG
 ONlGyNwvy/ke4uzVfyEPKDtBZCfz2q5UQ8bFpBxGNO3LlQ/sCr
 fT0YcCOTV5XR73p90HmmqrdacDJZ+f3jJkVtryp/889hmxtF7X
 wCnzPK+6NHnSK/Dkdg0zEW1no98V2xVEK3gZFcl83YbqUhrCnQ
 LeaYn7a+OZNkt5p0V4WhAAx8Igt8W9RtC1LhMbiKFmgPqXopC/
 WMLfSt5vVFK6P2D/xHJhK46lHWT7MtUdfM46f1NEk7+2O3sg+M
 pOBVWAnQYHGNQjj6IfgA=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 28 September 2014 16:16:21 Suravee Suthikulpanit wrote:
> >
> > I'm not opposed to it, but I have the same question as for setting up
> > the domain: how does pci_scan_root_bus() learn what to assign to
> > bus->msi?  It currently only gets a "void *sysdata" so there's no
> > obvious place to put it there.  You could add a pcibios interface to
> > retrieve it, I suppose, but I'm starting to get uncomfortable with
> > adding more of those because we have such a mess of them already.
> >
> 
> [Suravee] Liviu and I had a talk during Linaro Connect, and we came up
> with a new binding for the pcie controller called "msi-parent" which is
> supposed to contain phandle to the corresponded msi-controller.

Is this based on the property that we have in the pci-mvebu driver?

I hope this is meant to be compatible so we can share the implementation.

	Arnd
