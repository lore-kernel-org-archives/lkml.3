Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933566AbaEMN22 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 09:28:28 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:53777 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360AbaEMN20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 09:28:26 -0400
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
Date: Tue, 13 May 2014 15:27:46 +0200
Message-ID: <202752041.rgamje4etj@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53721D7F.9070200@ti.com>
References: <1399383244-14556-1-git-send-email-kishon@ti.com> <10531498.kYV5eO1J1m@wuerfel> <53721D7F.9070200@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:5HW5PGUCJcL3Zn5+soFbdhGwi0o6V8UYeEB5hL7FfdM
 7fAIZRyFSJnevw91v20xt0l9uqWiiIls411RM/8ec1DVt8v3xC
 Q4apWI8nFOYwKTSyt2hPtDwvWAhyUW55iavzWnDptmOKraWSSE
 cqsI5f54CG9WLRROhL4CS0szNILzaoh0BQBA84yJfA/nhJsMCu
 hlN9gceDUHKkD2yJTRXdkZ1hcfSaeyMBqlvZKnSaECcC6NjBWL
 Kn3eOe/w8tST+hg9/JT96U8mTumRn+zMo5pWQNoPezzQAMa0es
 aJHdrPQwAWodr+hCGLJ7MJ0Uzm1qjKYZaWMrxhiEbgZokzQB8z
 T/BjpP3Vw0saeJYAceYk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 May 2014 18:56:23 Kishon Vijay Abraham I wrote:
> > If you have a case where the outbound translation is a 256MB (i.e. 28bit)
> > section of the CPU address space, that could be represented as
> > 
> >       ranges = <0x82000000 0 0  0xb0000000  0 0x10000000>;
> > 
> > or 
> > 
> >       ranges = <0x82000000 0 0xb0000000  0xb0000000  0 0x10000000>;
> > 
> > depending on whether you want the BARs to be programmed using a low
> > address 0x0-0x0fffffff or an address matching the window
> > 0xb0000000-0xbfffffff.
> 
> The problem is, for configuring the window starting at 0xb0000000, the ATU
> should be programmed 0x0000000 (the cpu address for it will be 0xb0000000 though).
> 

Then use the first of the two?

	Arnd
