Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485AbaEPUai (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 16:30:38 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:49603 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752975AbaEPUag convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 16:30:36 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
CC: Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Strashko, Grygorii" <grygorii.strashko@ti.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Jingoo Han <jg1.han@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        Mohit Kumar <mohit.kumar@st.com>,
        "Bjorn Helgaas" <bhelgaas@google.com>
Subject: RE: [PATCH v1 5/5] pci: keystone: add pcie driver based on
 designware core driver
Thread-Topic: [PATCH v1 5/5] pci: keystone: add pcie driver based on
 designware core driver
Thread-Index: AQHPcFn7typDCmZvGUCN81SEYe7oaptB+uIA///+dwGAACiNgIAAUEwAgAE3fgA=
Date: Fri, 16 May 2014 20:29:56 +0000
Message-ID: <3E54258959B69E4282D79E01AB1F32B704742133@DFLE11.ent.ti.com>
References: <1400169692-9677-1-git-send-email-m-karicheri2@ti.com>
 <6048322.x3M3sdDEWO@wuerfel> <5374FD24.8000806@ti.com>
 <22200719.Jb5jnJylJH@wuerfel> <20140515183919.GC11650@obsidianresearch.com>
 <53751DDF.40304@ti.com> <20140515205210.GB14722@obsidianresearch.com>
In-Reply-To: <20140515205210.GB14722@obsidianresearch.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [128.247.5.50]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Jason Gunthorpe [mailto:jgunthorpe@obsidianresearch.com]
>Sent: Thursday, May 15, 2014 4:52 PM
>To: Karicheri, Muralidharan
>Cc: Arnd Bergmann; linux-arm-kernel@lists.infradead.org; Strashko, Grygorii; linux-
>pci@vger.kernel.org; Jingoo Han; linux-kernel@vger.kernel.org; Shilimkar, Santosh; Mohit
>Kumar; Bjorn Helgaas
>Subject: Re: [PATCH v1 5/5] pci: keystone: add pcie driver based on designware core
>driver
>
>On Thu, May 15, 2014 at 04:04:47PM -0400, Murali Karicheri wrote:
>
>> Jason What you mean by "The PCI core handles setting the maximum read
>> request size already" I see there is function pcie_write_mrrs() in the
>> drivers/pci/probe.c that reads the mps using pcie_get_mps() and then
>> set mrrs to mps. But this function is called only from
>> pcie_bus_configure_set() that is called by
>> pcie_bus_configure_settings()
>
>Right, that is the common code that correctly sets the MRRS that you should be using
>instead of quirks.
>
>> None of them gets called on ARM platform.
>
>Hmm, a cursory glance tells me the same as well.
>
>That seems to be the root problem here, ARM needs to do the PCIE setup just as much as
>any other arch.
>
>So, I would prefer to see you fix ARM common code to call
>pcie_bus_configure_settings() properly, that seems very simple and is obviously needed for
>any PCI-E host driver on ARM.
>

But pcie_bus_configure_settings just make sure the mrrs for a device is not greater than
the max payload size. But the quirk that I need is to limit the size of mrr to 256 as required
by the keystone PCI controller. So I still need to implement a quirk to enforce this limit.

In my reply to Arnd, I have agreed to move the quirk to keystone driver.

Murali
>Thoughts? Arnd? Bjorn?
>
>Jason
