Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284Ab3IZJv6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 05:51:58 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:58663 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab3IZJvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 05:51:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: [PATCH V3] pci: exynos: split into two parts such as Synopsys part and Exynos part
Date: Thu, 26 Sep 2013 11:51:41 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Pratyush Anand <pratyush.anand@st.com>, Jingoo Han <jg1.han@samsung.com>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        Mohit KUMAR DCG <Mohit.KUMAR@st.com>, "'Sean Cross'" <xobs@kosagi.com>,
        "'Thierry Reding'" <thierry.reding@gmail.com>,
        "'SRIKANTH TUMKUR SHIVANAND'" <ts.srikanth@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
References: <000701ce8741$fe47deb0$fad79c10$@samsung.com> <201309242323.55323.arnd@arndb.de> <5243C0E5.7020508@ti.com>
In-Reply-To: <5243C0E5.7020508@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201309261151.42034.arnd@arndb.de>
X-Provags-ID: V02:K0:ZnICICg6227u/QQ+RSpYW5Fw8tHoKm5OaWOkNFxI2e1
 PZf4+SEnKh8xM4G8PmlsEbW7wQLR3irTLDowUfr7T7vZcY2yg+
 2RwSZu1ZPJvGAHh8ibSHKLGpIe6vCJMMxJX65WgOkGrdZbSMND
 dix0LkMVFZvobT2rP+OuyFj3W2dqf2dDN5Fj6HKf4bbOZcRRJz
 rU7h0UMkW32djuwQc9Q+ni66hro4iGwvbXq5BJ80Z7siucm6PF
 6+ixD8LBN2fqlFnBL9HFUZ8cfs3OMhXD42Z8KjWvvLLJyIFFkF
 xmXYb4pXOx2ewaqYSD9XYpgXexbHKJdzSFQ5euu1yGLToBovvg
 AgVbEb/EW5Epzp9BOSHc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 September 2013, Kishon Vijay Abraham I wrote:
> On Wednesday 25 September 2013 02:53 AM, Arnd Bergmann wrote:
> > On Monday 23 September 2013, Kishon Vijay Abraham I wrote:
> >> Btw if we hadn't programmed inbound translation table, the address will go
> >> untranslated (according to the data book). I guess that's how it was working
> >> for Jingoo Han.
> >>
> >> **
> >> 3.10.4
> >> Inbound iATU Operation
> >>
> >> When there is no match, then the address is untranslated
> >> **
> >>
> > 
> > Well, that should work just as well, since you have a 1:1 translation anyway.
> > Do you get the same error without the translation?
> 
> Yes. I get the same non-fatal error interrupt in RC.

Ok, then I guess the translation is actually not at fault here but something
else. I would recommend looking at the IOMMU as the potential culprit. Maybe
having it disabled means that no DMA is going through, rather than all DMA
going through untranslated. Another possibility is that the IOMMU is set up
so that when disabled, it maps DMA address 0 to the start of RAM, rather
than identity mapping DMA address 0x80000000 there. If that's the case,
you either have to use the IOMMU, or set up the mapping in the root
complex to revert it.

	Arnd
