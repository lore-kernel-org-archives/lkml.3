Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760797AbaEMNfJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 09:35:09 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:59976 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754299AbaEMNfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 09:35:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Jingoo Han <jg1.han@samsung.com>,
        "'Santosh Shilimkar'" <santosh.shilimkar@ti.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-pci@vger.kernel.org, rogerq@ti.com,
        balajitk@ti.com, "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "'Marek Vasut'" <marex@denx.de>
Subject: Re: [PATCH 06/17] pci: host: pcie-designware: Use *base-mask* for configuring the iATU
Date: Tue, 13 May 2014 15:34:53 +0200
Message-ID: <4528185.oZbgyuuFKX@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <202752041.rgamje4etj@wuerfel>
References: <1399383244-14556-1-git-send-email-kishon@ti.com> <53721D7F.9070200@ti.com> <202752041.rgamje4etj@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:dQgW64Ip2QapqtBEsok7gO7kGATJ18xCxz9l0/Zk/SD
 jCDbCF0sqW8whmzfbPGb7wG1ZZ4nwzzBhZKC+8jVx5Ap9nrC/O
 fhYKWnbygWs5ei1/KOwc6ryH1LXzV/hA1MVuUEqjs8a4g7OpWf
 pOfdKxSCo5Yat+v/F2BpNOAwltyXzO0en9QshR81CAS1ZvJpcw
 OnhZqCFQkiwAgMuOaoP3fQakzw+KJhOAB8UEdYJAwj7f+kNAaN
 SzeuK6eojhM6Q+4s/Iz6Pj21/y//53Vk5+gLQ4oNCMh9tu/7eG
 t6sJ8cBkWzAC9IbX+asxnS1j6EuNv1ri8Yv0lwVT3QfuUvSHHT
 aJ8O5JKgZSBRsp6Icr20=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 May 2014 15:27:46 Arnd Bergmann wrote:
> On Tuesday 13 May 2014 18:56:23 Kishon Vijay Abraham I wrote:
> > > If you have a case where the outbound translation is a 256MB (i.e. 28bit)
> > > section of the CPU address space, that could be represented as
> > > 
> > >       ranges = <0x82000000 0 0  0xb0000000  0 0x10000000>;
> > > 
> > > or 
> > > 
> > >       ranges = <0x82000000 0 0xb0000000  0xb0000000  0 0x10000000>;
> > > 
> > > depending on whether you want the BARs to be programmed using a low
> > > address 0x0-0x0fffffff or an address matching the window
> > > 0xb0000000-0xbfffffff.
> > 
> > The problem is, for configuring the window starting at 0xb0000000, the ATU
> > should be programmed 0x0000000 (the cpu address for it will be 0xb0000000 though).
> > 
> 
> Then use the first of the two?
> 

To clarify: using <0x82000000 0 0  0xb0000000  0 0x10000000> will give you 
a mem_offset of 0xb0000000, which should work just fine for this case.

What I don't understand is why the ATU cares about whether the outbound
address is 0x0000000 or 0xb0000000 if it just decodes the lower 28 bit
anyway. Did you mean that we have to program the BARs using low addresses
regardless of what is programmed in the ATU? That would make more sense,
and it also matches what I suggested.

	Arnd
