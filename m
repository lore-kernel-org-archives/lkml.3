Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595AbaEHJTX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 05:19:23 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:65517 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbaEHJTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 05:19:19 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Kishon Vijay Abraham I'" <kishon@ti.com>,
        "'Santosh Shilimkar'" <santosh.shilimkar@ti.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-pci@vger.kernel.org, rogerq@ti.com,
        balajitk@ti.com, "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "'Marek Vasut'" <marex@denx.de>
Subject: Re: [PATCH 06/17] pci: host: pcie-designware: Use *base-mask* for configuring the iATU
Date: Thu, 08 May 2014 11:18:29 +0200
Message-ID: <6882241.amuhzvbd8n@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <000201cf6a9c$9dd295e0$d977c1a0$%han@samsung.com>
References: <1399383244-14556-1-git-send-email-kishon@ti.com> <4764413.ZAEU5S5p0p@wuerfel> <000201cf6a9c$9dd295e0$d977c1a0$%han@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:CtYNY7luccRwgC9dhZeD3TKqC3YLTg0D0UGoXUs0M+I
 geNAjB2hCTRX5PX2Q43kFlzv0XKKEirS51QT8thyeXQPLaXN2H
 t7RRakUnx1t0aj8kNR4aHFlk324ktiFOmk8RckfKFfFdxn19K4
 TWXprtmS5eoW1rIxeF5BZYB0wugrL56dVKA+ziXmxuKzjIT2sK
 CAWbB+RAr0T2Qlk+eIjTk9WfeLpc2dUeJ3sjd//NO7xoCDl8nl
 vAjAdBi2ijFS/vb5lqU4eQbFig0w2NZxLJbzORSfFooPFqv7Yc
 O4q6IxrOv2kCzSm0MQPYdH12C0Jpzw84JBl37gNQU+OWOwTHUB
 AyUOp6hHmoweXTbWyJ8I=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 May 2014 18:05:11 Jingoo Han wrote:
> On Tuesday, May 06, 2014 10:59 PM, Arnd Bergmann wrote:
> > On Tuesday 06 May 2014 19:03:52 Kishon Vijay Abraham I wrote:
> > > In DRA7, the cpu sees 32bit address, but the pcie controller can see only 28bit
> > > address. So whenever the cpu issues a read/write request, the 4 most
> > > significant bits are used by L3 to determine the target controller.
> > > For example, the cpu reserves 0x2000_0000 - 0x2FFF_FFFF for PCIe controller but
> > > the PCIe controller will see only (0x000_0000 - 0xFFF_FFF). So for programming
> > > the outbound translation window the *base* should be programmed as 0x000_0000.
> > > Whenever we try to write to say 0x2000_0000, it will be translated to whatever
> > > we have programmed in the translation window with base as 0x000_0000.
> > >
> > > Cc: Bjorn Helgaas <bhelgaas@google.com>
> > > Cc: Marek Vasut <marex@denx.de>
> > > Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> > > Acked-by: Jingoo Han <jg1.han@samsung.com>
> > > Acked-by: Mohit Kumar <mohit.kumar@st.com>
> > 
> > Sorry, but NAK.
> > 
> > We have a standard 'dma-ranges' property to handle this, so use it.
> > 
> > See the x-gene PCIe driver patches for an example. Please also talk
> > to Santosh about it, as he is implementing generic support for
> > parsing dma-ranges in platform devices at the moment.
> 
> Hi Arnd,
> 
> Do you mean the following patch?
> http://www.spinics.net/lists/kernel/msg1737725.html
> 

That is the patch Santosh did for platform devices, which is related but not
what I meant here. For the PCI inbound window setup, please have a look
at https://lkml.org/lkml/2014/3/19/607

	Arnd
