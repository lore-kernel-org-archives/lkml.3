Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772AbaGKRDT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 13:03:19 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:45929 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754246AbaGKRDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 13:03:17 -0400
MIME-Version: 1.0
In-Reply-To: <20140711141115.GB16321@arm.com>
References: <1404240214-9804-1-git-send-email-Liviu.Dudau@arm.com>
 <1404240214-9804-7-git-send-email-Liviu.Dudau@arm.com> <20140708005954.GC22939@google.com>
 <20140708104655.GC6501@e106497-lin.cambridge.arm.com> <CAErSpo75ovmGoeSHKJN0nckGDy-0gpn8kLPfHQ79CtcXxhPydw@mail.gmail.com>
 <20140708224847.GC4980@e106497-lin.cambridge.arm.com> <CAErSpo5rBt0iF2HGeDD-UH6_sPCoC647VCw0Q1v_0Rdpvcir-w@mail.gmail.com>
 <20140710094758.GA6501@e106497-lin.cambridge.arm.com> <CAErSpo5ZNCY31NztT0cLFbRVsBZqMsZ0LbTFNOTQCZUU3F7qJA@mail.gmail.com>
 <20140711141115.GB16321@arm.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 11 Jul 2014 11:02:56 -0600
Message-ID: <CAErSpo7C8qzmdp+XgVi2ysXj_NcgvVY7RVfBZ2PHimLzrzANMQ@mail.gmail.com>
Subject: Re: [PATCH v8 6/9] pci: Introduce a domain number for pci_host_bridge.
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Liviu Dudau <Liviu.Dudau@arm.com>, linux-pci <linux-pci@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Arnd Bergmann <arnd@arndb.de>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 8:11 AM, Catalin Marinas
<catalin.marinas@arm.com> wrote:
> On Thu, Jul 10, 2014 at 11:36:10PM +0100, Bjorn Helgaas wrote:
>> Most of the rest of the v7 discussion was about "Introduce a domain
>> number for pci_host_bridge."  I think we should add arm64 using the
>> existing pci_scan_root_bus() and keep the domain number in the arm64
>> sysdata structure like every other arch does.  Isn't that feasible?
>> We can worry about domain unification later.
>
> I think that's what we were trying to avoid, adding an arm64-specific
> pci_sys_data structure (and arm64-specific API). IIUC, avoiding this
> would allow the host controller drivers to use the sysdata pointer for
> their own private data structures.
>
> Also since you can specify the domain number via DT (and in Liviu's
> v8 patches read by of_create_pci_host_bridge), I think it would make
> sense to have it stored in some generic data structures (e.g.
> pci_host_bridge) rather than in an arm64 private sysdata.

It would definitely be nice to keep the domain in a generic data
structure rather than an arm64-specific one.  But every other arch
keeps it in an arch-specific structure today, and I think following
that existing pattern is the quickest way forward.

But you mentioned arm64-specific API, too.  What do you have in mind
there?  I know there will be arm64 implementations of various
pcibios_*() functions (just like for every other arch), but it sounds
like there might be something else?

Bjorn
