Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330AbaFBQXO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 12:23:14 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:48566 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897AbaFBQXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 12:23:11 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH 1/2] pci: Add IORESOURCE_BIT entry for PCIe ECAM
 resources.
To: Kumar Gala <galak@codeaurora.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Liviu Dudau <Liviu.Dudau@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Rob Herring <robherring2@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Kishon Vijay Abraham I <kishon@ti.com>
In-Reply-To: <390B3F94-C058-47D6-82CE-0393E60014FF@codeaurora.org>
References: <20140530233034.GH1677@bart.dudau.co.uk>
	<1401496601-31983-1-git-send-email-Liviu.Dudau@arm.com>
	<1401496601-31983-2-git-send-email-Liviu.Dudau@arm.com>
	<4756033.LkcFQN0chs@wuerfel>
	<20140602150945.964D4C40381@trevor.secretlab.ca>
	<390B3F94-C058-47D6-82CE-0393E60014FF@codeaurora.org>
Date: Mon, 02 Jun 2014 17:23:06 +0100
Message-Id: <20140602162306.4AB0FC40476@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jun 2014 10:40:30 -0500, Kumar Gala <galak@codeaurora.org> wrote:
> 
> On Jun 2, 2014, at 10:09 AM, Grant Likely <grant.likely@linaro.org> wrote:
> 
> > On Sat, 31 May 2014 20:41:04 +0200, Arnd Bergmann <arnd@arndb.de> wrote:
> >> On Saturday 31 May 2014 01:36:40 Liviu Dudau wrote:
> >>> We would like to be able to describe PCIe ECAM resources as
> >>> IORESOURCE_MEM blocks while distinguish them from standard
> >>> memory resources. Add an IORESOURCE_BIT entry for this case.
> >>> 
> >>> Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
> >> 
> >> I still don't see any value in this at all. What is the advantage
> >> of doing this opposed to just having a standardized 'reg' property
> >> for a particular compatible string?
> > 
> > I'm inclined to agree. It doesn't seem appropriate to put config space
> > in ranges, and the host controller binding is responsible for
> > identifying how config space is memory mapped.
> > 
> > g.
> 
> I don’t agree when it comes to ECAM, but we can drop this for now
> until someone really does that.

Okay, humor me then. What would a ranges property look like for ECAM? Do
you have an example? I believe there would need to be a separate entry
for each and every PCI device on the bus to get the config spaces to be
contiguous.

> However, what do we do with the 2 cases that exist in upstream that
> are using ranges for cfg space?

Ignore them in the core code? Make the specific host controller handle
them I would think.

g.

