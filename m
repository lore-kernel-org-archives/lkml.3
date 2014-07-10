Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280AbaGJWgd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 18:36:33 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:60412 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030AbaGJWgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 18:36:31 -0400
MIME-Version: 1.0
In-Reply-To: <20140710094758.GA6501@e106497-lin.cambridge.arm.com>
References: <1404240214-9804-1-git-send-email-Liviu.Dudau@arm.com>
 <1404240214-9804-7-git-send-email-Liviu.Dudau@arm.com> <20140708005954.GC22939@google.com>
 <20140708104655.GC6501@e106497-lin.cambridge.arm.com> <CAErSpo75ovmGoeSHKJN0nckGDy-0gpn8kLPfHQ79CtcXxhPydw@mail.gmail.com>
 <20140708224847.GC4980@e106497-lin.cambridge.arm.com> <CAErSpo5rBt0iF2HGeDD-UH6_sPCoC647VCw0Q1v_0Rdpvcir-w@mail.gmail.com>
 <20140710094758.GA6501@e106497-lin.cambridge.arm.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 10 Jul 2014 16:36:10 -0600
Message-ID: <CAErSpo5ZNCY31NztT0cLFbRVsBZqMsZ0LbTFNOTQCZUU3F7qJA@mail.gmail.com>
Subject: Re: [PATCH v8 6/9] pci: Introduce a domain number for pci_host_bridge.
To: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: linux-pci <linux-pci@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
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

On Thu, Jul 10, 2014 at 3:47 AM, Liviu Dudau <Liviu.Dudau@arm.com> wrote:

> I don't see a way out of adding new PCI interfaces if we want to have support in
> the PCI framework for unifying existing architectures. Of course, there is the painful
> alternative of changing the existing APIs and fixing arches in one go, but like you've
> said is going to be messy. I don't think I (or the people and companies wanting PCIe
> on arm64) should cop out and pick a quick fix that adds sysdata structure into arm64
> just to avoid new APIs, as this is not going to help anyone in long term. What I can
> do is to create a set of parallel APIs for pci_{scan,create}_root_bus() that take
> a pci_host_bridge pointer and start converting architectures one by one to that API
> while deprecating the existing one. That way we can add arm64 easily as it would be
> the first architecture to use new code without breaking things *and* we provide a
> migration path.

A lot of the v7 discussion was about pci_register_io_range().  I
apologize, because I think I really derailed things there and it was
unwarranted.  Arnd was right that migrating other arches should be a
separate effort.  I *think* I was probably thinking about the proposal
of adding pci_create_root_bus_in_domain(), and my reservations about
that got transferred to the pci_register_io_range() discussion.  In
any case, I'm completely fine with pci_register_io_range() now.

Most of the rest of the v7 discussion was about "Introduce a domain
number for pci_host_bridge."  I think we should add arm64 using the
existing pci_scan_root_bus() and keep the domain number in the arm64
sysdata structure like every other arch does.  Isn't that feasible?
We can worry about domain unification later.

I haven't followed closely enough to know what other objections people had.

Bjorn
