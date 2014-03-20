Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757424AbaCTMuO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 08:50:14 -0400
Received: from service87.mimecast.com ([91.220.42.44]:47859 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbaCTMuL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 08:50:11 -0400
Date: Thu, 20 Mar 2014 12:50:04 +0000
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        linux-pci <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v7 3/3] arm64: Add architecture support for PCI
Message-ID: <20140320125004.GK6457@e106497-lin.cambridge.arm.com>
Mail-Followup-To: Arnd Bergmann <arnd@arndb.de>,
	Catalin Marinas <Catalin.Marinas@arm.com>,
	linux-pci <linux-pci@vger.kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Will Deacon <Will.Deacon@arm.com>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	linaro-kernel <linaro-kernel@lists.linaro.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	LAKML <linux-arm-kernel@lists.infradead.org>,
	Tanmay Inamdar <tinamdar@apm.com>,
	Grant Likely <grant.likely@secretlab.ca>
References: <1394811258-1500-1-git-send-email-Liviu.Dudau@arm.com>
 <201403201217.22339.arnd@arndb.de>
 <20140320113820.GH6457@e106497-lin.cambridge.arm.com>
 <201403201326.02377.arnd@arndb.de>
MIME-Version: 1.0
In-Reply-To: <201403201326.02377.arnd@arndb.de>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 20 Mar 2014 12:50:18.0732 (UTC) FILETIME=[F2AE12C0:01CF443A]
X-MC-Unique: 114032012500901801
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2014 at 12:26:02PM +0000, Arnd Bergmann wrote:
> On Thursday 20 March 2014, Liviu Dudau wrote:
> > > I don't even understand why you want to create a generic pci_address_to_pio
> > > implementation, when we don't need that for arm64 at all. Unless I'm
> > > missing something important, that function is only called in case of
> > > PCI_PROBE_DEVTREE with pci_of_scan on PowerPC. I don't expect any
> > > architecture to do the same thing, and the only other architecture that
> > > needs something like it (sparc) has a different implementation.
> > 
> > Because in my [v7 2/6]* patch for the generic host bridge support I start
> > using pci_address_to_pio to fix the conversion of PCI ranges to resources.
> > That requires an arm64 (or more correctly, an arch with memory mapped IO
> > specific) version of pci_address_to_pio().
> 
> Yes, but why do you use it there?

I'm parsing the device tree and have reached the PCI IO range for the host bridge.
There is no host bridge created yet for that and hence no mapping. I need to
take the DT range declaration that gives me   CPU start .. SIZE --> BUS start and
convert it into   Logical IO port start .. Logical IO port end. While I could've
come up with (yet) another function that does the conversion from CPU address to
port IO address, I thought it would be nice to use the existing pci_address_to_pio()
function and adapt it to my needs. It has a __weak implementation anyway so I
could overwrite it in the architecture code.

To me it looked like a good plan and we had some discussions around my initial
goofy mistake of using pci_addr as physical address for translation. I never
thought it was considered a bad idea.

Best regards,
Liviu

> 
> 	Arnd
> 

-- 
====================
| I would like to |
| fix the world,  |
| but they're not |
| giving me the   |
 \ source code!  /
  ---------------
    ¯\_(ツ)_/¯

