Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709Ab3IZOmN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 10:42:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41776 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909Ab3IZOmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 10:42:11 -0400
MIME-Version: 1.0
In-Reply-To: <20130926143901.GE16774@dhcp-26-207.brq.redhat.com>
References: <20130918094759.GA2353@dhcp-26-207.brq.redhat.com>
	<20130918142231.GA21650@mtj.dyndns.org>
	<20130918165045.GB2353@dhcp-26-207.brq.redhat.com>
	<20130920082458.GA10507@dhcp-26-207.brq.redhat.com>
	<20130920122736.GD7630@mtj.dyndns.org>
	<20130925180220.GB26273@google.com>
	<20130925205804.GA21737@dhcp-26-207.brq.redhat.com>
	<20130925210016.GA8926@htj.dyndns.org>
	<20130926074646.GA16774@dhcp-26-207.brq.redhat.com>
	<20130926131147.GA31249@mtj.dyndns.org>
	<20130926143901.GE16774@dhcp-26-207.brq.redhat.com>
Date: Thu, 26 Sep 2013 10:42:10 -0400
X-Google-Sender-Auth: f5v9ntJ7C1BKy5tEMGotb96KjS4
Message-ID: <CAOS58YOZ4u7po=wb-v4Ua=oBiaKG==S1LMT70SdGEcNfAOVcOQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/6] PCI/MSI: Factor out pci_get_msi_cap() interface
From: Tejun Heo <tj@kernel.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Jan Beulich <JBeulich@suse.com>, linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Sep 26, 2013 at 10:39 AM, Alexander Gordeev <agordeev@redhat.com> wrote:
> I can imagine a scenario where the first device probes in, requests its

Well, we can imagine a lot of thing but usually have to draw the line somewhere.

> optimal number, acquires that number and exhausts MSIs in pSeries firmware.
> The next few devices possibly end up with single MSI, since no MSIs left
> to satisfy their optimal numbers. If one of those single-MSI'ed devices
> happened to be a high-performance HBA hitting a degraded performance that
> alone would force (IBM) to introduce the quotas. Now, if the same/another
> device happened does not support the legacy interrupt mode and no MSI
> resources have left in the platform firmware at all...

If that happens, that's just the platform code being dumb. Quota is
there to prevent that from happening, right? Let's please do something
simple and worry about problems if they actually exist.

Thanks.

-- 
tejun
