Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259AbaGIGd5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 02:33:57 -0400
Received: from mout.kundenserver.de ([212.227.126.187]:55405 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbaGIGdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 02:33:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Subject: Re: [PATCH v8 3/9] pci: Introduce pci_register_io_range() helper function.
Date: Wed, 9 Jul 2014 08:32:37 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci" <linux-pci@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "linaro-kernel" <linaro-kernel@lists.linaro.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
References: <1404240214-9804-1-git-send-email-Liviu.Dudau@arm.com> <20140708212951.GA4555@google.com> <20140708224529.GB4980@e106497-lin.cambridge.arm.com>
In-Reply-To: <20140708224529.GB4980@e106497-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201407090832.37918.arnd@arndb.de>
X-Provags-ID: V02:K0:xKVFTATeSKfIvxpR+V0IXEMGi6Y8FOSCqy7EIDW5fuq
 CdsT9eK4MbmF2JMpiD0l4Gb0KyRalzVPEAavxVO8VgcfKwNS7I
 p1FR3ibkx1WWEVZhwFI6+pHe+tzFZvv9Dv3ceFJUSSCjAyHXN8
 RdRTlTet+BmVKRy/4cclGghzl++NNsOraG5k4LaAb4n7NiUXqh
 ybYKJHY8zo0L3lZI+0cMWYw8Cmtjfhq4l2tC8RN6nHot89HJTS
 k5RmVY5Dp6kcysJsppjH7pnoN9E0ylUoxKZ/cgqF/RDoRicWDd
 1EgzzKFUAzm4eNM6muWCDbskSOWkidvbI/zMWHxYguyPba9jKe
 Ua8LY7XvK60Od97t0/R6TQeL5ft1n1z3TBIKg2GUh
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 July 2014, Liviu Dudau wrote:
> > Maybe that assumption is guaranteed by OF, but it doesn't hold for ACPI;
> > ACPI can describe several I/O port apertures for a single bridge, each
> > associated with a different CPU physical memory region.
> 
> That is actually a good catch, I've completely missed the fact that
> io_range->pci_addr could be non-zero.

Hmm, that's what I thought in my initial review, but you convinced me
that it's actually correct later on, and I still believe it is. Maybe
now you got confused by your own code?

Please have another look, I think your code in pci_host_bridge_of_get_ranges
sufficiently handles the registration to the PCI code with the correct
io_offset. The only thing that we might want to add is to record the
PCI address along with the bridge->io_base: For the host driver to
set up the mapping window correctly, you either need both of them, or
you assume they are already set up.

	Arnd
