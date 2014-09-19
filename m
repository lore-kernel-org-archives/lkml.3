Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913AbaISAW0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 20:22:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30335 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751429AbaISAWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 20:22:23 -0400
Message-ID: <541B770A.8070502@redhat.com>
Date: Thu, 18 Sep 2014 20:21:30 -0400
From: Jon Masters <jcm@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>,
        Tanmay Inamdar <tinamdar@apm.com>
CC: Liviu Dudau <Liviu.Dudau@arm.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Rob Landley <rob@landley.net>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@apm.com" <patches@apm.com>
Subject: Re: [PATCH v8 1/4] pci:host: APM X-Gene PCIe host controller driver
References: <1410476266-29426-1-git-send-email-tinamdar@apm.com> <1410476266-29426-2-git-send-email-tinamdar@apm.com> <20140912091816.GU27864@e106497-lin.cambridge.arm.com> <CACoXjckWYhe=PpWE+xYSC9Q72FyAq__3uUh2gGeGtgpC5SrpzQ@mail.gmail.com> <20140917160337.GA15261@e104818-lin.cambridge.arm.com>
In-Reply-To: <20140917160337.GA15261@e104818-lin.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2014 12:03 PM, Catalin Marinas wrote:

> So for arm64 currently we have some hooks in dma-mapping.c to intercept
> when a device is added to a bus. What I need to do though is check
> recursively whether the parent (bus) had the 'dma-coherent' property
> (pointed out by Jon). I think something like this would do (not tested):

We've got a patch now that I posted internally and we've tested. I've
asked Mark Salter to send it upstream (but hey, you'll probably just
want to switch the default over to recurse up the tree and then simply
add a new notifier register for pci_bus_type). For this stuff to work,
we need v10 of the APM X-Gene patches because (as I noticed earlier when
going through their code and testing on a board with an actual card -
and a modified devicetree node for the PCI root) that's the point they
add a call to setup the root of_nodes correctly via pci_scan_root_bus.
Prior to that the trivially obvious patch for dma-coherent doesn't work.
Today, there are two platform PCIe devices that do it right, plus the
latest APM rev of their driver just posted.

Jon.

