Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319AbaETRRr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 13:17:47 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:59547 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbaETRRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 13:17:45 -0400
MIME-Version: 1.0
In-Reply-To: <4769015.Y4xoyoQxYb@wuerfel>
References: <1400169692-9677-1-git-send-email-m-karicheri2@ti.com>
 <5671513.YgJm44AVLV@wuerfel> <537A735A.9070607@ti.com> <4769015.Y4xoyoQxYb@wuerfel>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 20 May 2014 11:17:25 -0600
Message-ID: <CAErSpo5iehwoDAuETCxCEHHj1_0jHCJUnn+wj1OUAn6PpxbtyQ@mail.gmail.com>
Subject: Re: [PATCH v1 5/5] pci: keystone: add pcie driver based on designware
 core driver
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm <linux-arm-kernel@lists.infradead.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        "Strashko, Grygorii" <grygorii.strashko@ti.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Jingoo Han <jg1.han@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        Mohit Kumar <mohit.kumar@st.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 1:55 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Monday 19 May 2014 17:10:50 Murali Karicheri wrote:

>> On ARM, by default pci_bus_config seems to be set to 0
>> (PCIE_BUS_TUNE_OFF). So the code doesn't get
>> executed for this default. But for PCIE_BUS_SAFE, it doesn't change the
>> mrrs at the EP and is not
>> good for our platform w.r.t mrrs settings. For PCIE_BUS_PERFORMANCE, it
>> seems to increase the payload
>> size as well and Keystone Payload size is limited to 128 bytes. So it is
>> not safe to increase the payload
>> size to 256 based on the log.
>>
>> On other platforms, Why the PCI core try to set the payload size equal
>> to mrrs? Is this explained in any
>> PCI spec?  Looks like this is done for performance? Let me know if you
>> want me to send a patch for
>> review to add the pcie_bus_configure_settings() code to
>> arch/arm/kernel/bios32.c
>>
>> For the Keystone PCI driver, I believe. it is safe to have the quirk so
>> that controller can handle the
>> read requests properly. Let me know if the quirk code above looks good
>> to go.
>
> I don't know enough about these to give you a definite answer, but
> I'd still prefer to handle this in generic code. A quirk seems to
> be the wrong answer here. If this isn't something we can do in generic
> fashion, can you do it in the add_bus() callback perhaps?

I definitely prefer a more generic approach than a quirk.
Unfortunately the MPS management was implemented originally just for
x86, not because there's anything arch-specific about it, but because
the author was only concerned about x86.  Making that more generic has
been an open issue all along.

Bjorn
