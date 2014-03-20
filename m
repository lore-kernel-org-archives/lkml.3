Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555AbaCTJrL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 05:47:11 -0400
Received: from service87.mimecast.com ([91.220.42.44]:36303 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933605AbaCTJrB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 05:47:01 -0400
Date: Thu, 20 Mar 2014 09:46:54 +0000
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
Message-ID: <20140320094654.GZ6457@e106497-lin.cambridge.arm.com>
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
 <20140319135619.GC6231@localhost>
 <20140319172140.GA16328@e106497-lin.cambridge.arm.com>
 <8312584.jdZZuHGAjg@wuerfel>
MIME-Version: 1.0
In-Reply-To: <8312584.jdZZuHGAjg@wuerfel>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 20 Mar 2014 09:47:08.0732 (UTC) FILETIME=[5C2127C0:01CF4421]
X-MC-Unique: 114032009465808301
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2014 at 06:37:51PM +0000, Arnd Bergmann wrote:
> On Wednesday 19 March 2014 17:21:41 Liviu Dudau wrote:
> > 
> > My ultimate point is that no matter how long we argue about the shape of the functions that
> > I've added into arch/arm64/kernel/pci.c I don't think we can get away without having that
> > file, or at least not in the first phase if we want speedy integration into mainline.
> 
> Let me simplify the discussion here:
> 
> NAK to adding yet another architecture specific implementation.

So what would be your approach for handling pci_address_to_pio() in a non-arch specific way?

unsigned long __weak pci_address_to_pio(phys_addr_t address)
{
#ifdef ARCH_HAS_IOSPACE
	if (address > IO_SPACE_LIMIT)
		return (unsigned long)-1;

	return (unsigned long) address;
#else
	struct ioresource *res;

	list_for_each_entry(res, &io_list, list) {
		if (address >= res->start &&
			address < res->start + res->size) {
			return res->start - address;
		}
	}

	return (unsigned long)-1;
#endif
}


Either that, or you have more magic rabbits than me.

Best regards,
Liviu

> 
> 	Arnd
> 
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

