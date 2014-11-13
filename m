Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830AbaKMD7B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 22:59:01 -0500
Received: from mail-qa0-f44.google.com ([209.85.216.44]:62500 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588AbaKMD67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 22:58:59 -0500
MIME-Version: 1.0
In-Reply-To: <CACVXFVN1HmyaiR7fXAxjwkBBJJZdW5bNpujfrPPeWRGZ=8FOig@mail.gmail.com>
References: <1415702040-2790-1-git-send-email-ming.lei@canonical.com>
 <20141111122901.GA4419@red-moon> <CACVXFVNAc9axtESmo1zGZ3GMquTzjzWR3jx-b3tbhhLfQDDRcg@mail.gmail.com>
 <20141111182418.GA5507@red-moon> <CACVXFVPzo2qNGa5DWESS3TXor=u82_SxHb+xzrBCRXtcQxq4Cg@mail.gmail.com>
 <CAErSpo5LELkH=9WAq5MDE6fkVJvPK3miQtqrMnRHY7QyLWigUg@mail.gmail.com> <CACVXFVN1HmyaiR7fXAxjwkBBJJZdW5bNpujfrPPeWRGZ=8FOig@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 12 Nov 2014 20:58:38 -0700
Message-ID: <CAErSpo7qWc8j2OQuEOUqCohndeosC5iDwk2j03Qb-KeDzDKxVw@mail.gmail.com>
Subject: Re: [PATCH] pci: generic host: make it more generic
To: Ming Lei <ming.lei@canonical.com>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        alvise rigo <a.rigo@virtualopensystems.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 1:58 AM, Ming Lei <ming.lei@canonical.com> wrote:
> On Wed, Nov 12, 2014 at 10:47 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> On Tue, Nov 11, 2014 at 7:12 PM, Ming Lei <ming.lei@canonical.com> wrote:
>>> ...
>>> Do you think it is doable to introduce a option(from module
>>> parameter, or device tree, ...) to let the driver and PCI core
>>> ignore/bypass all pcibios handling for the generic bus?
>>
>> No, I don't think so.
>
> Could you explain a bit? In VM world, it might be reasonable to
> claim that there is no pcibios service or pcibios service needn't.
>
> IMO it isn't easy to make a cross-arch PCI generic controller
> driver if pcibios handling has to be involved.

I'm not going to add kernel or module parameters to change the way the
basic code works.  We need a way to factor the differences so the PCI
core code is the same for all arches, and the differences are hidden
in the arch-specific code.

That's basically what the pcibios interfaces do.  I suspect they were
originally named "pcibios" because there's a "PCI BIOS" spec that
tells you how to make BIOS calls to enumerate devices, access config
space, manage interrupts, etc.  But "pcibios" is now just the name of
interfaces to arch-specific functionality.  Most arches don't have a
BIOS, and most pcibios_*() functions don't make BIOS calls.

If you have a new arch that has no "pcibios service" (I don't know
exactly what you mean by that), you can still implement the
pcibios_*() interfaces used by the PCI core.  If some of these
interfaces don't actually do anything on your arch, that's fine; they
can be no-ops.

Bjorn
