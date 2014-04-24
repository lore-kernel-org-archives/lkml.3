Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453AbaDXHU2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 03:20:28 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:48529 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbaDXHU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 03:20:27 -0400
Date: Thu, 24 Apr 2014 09:20:21 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Stephane Eranian <eranian@google.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Aaron Lu <aaron.lu@intel.com>,
        Linux PCI <linux-pci@vger.kernel.org>, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Zheng Z Yan <zheng.z.yan@intel.com>, Dave Jones <davej@redhat.com>,
        Rui Zhang <rui.zhang@intel.com>, Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 2] PNP: Work around BIOS defects in Intel MCH area
 reporting
Message-ID: <20140424072021.GA3396@gmail.com>
References: <20140421221721.26308.1891.stgit@bhelgaas-glaptop.roam.corp.google.com>
 <CABPqkBRVfajbeWeaZRmv6SSWcX7DAuGCxfmrHGiUTPkbfxVMWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBRVfajbeWeaZRmv6SSWcX7DAuGCxfmrHGiUTPkbfxVMWg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephane Eranian <eranian@google.com> wrote:

> On Tue, Apr 22, 2014 at 12:17 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> > Work around BIOSes that don't report the entire Intel MCH area.
> >
> > MCHBAR is not an architected PCI BAR, so MCH space is usually reported as a
> > PNP0C02 resource.  The MCH space was once 16KB, but is 32KB in newer parts.
> > Some BIOSes still report a PNP0C02 resource that is only 16KB, which means
> > the rest of the MCH space is consumed but unreported.
> >
> > This can cause resource map sanity check warnings or (theoretically) a
> > device conflict if we assigned the unreported space to another device.
> >
> > The Intel perf event uncore driver tripped over this when it claimed the
> > MCH region:
> >
> >   resource map sanity check conflict: 0xfed10000 0xfed15fff 0xfed10000 0xfed13fff pnp 00:01
> >   Info: mapping multiple BARs. Your kernel is fine.
> >
> > To prevent this, if we find a PNP0C02 resource that covers part of the MCH
> > space, extend it to cover the entire space.
> >
> Works for me on my Levono IvyBridge laptop.
> Thanks for fixing this, Bjorn.
> Acked-by: Stephane Eranian <eranian@google.com>

Just curious, what problems triggered on your laptop: only the 
warnings, or did something get mapped to the undeclared area,
causing other misbehavor?

Thanks,

	Ingo
