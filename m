Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758807Ab3CIOtW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 09:49:22 -0500
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:50180 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757854Ab3CIOtU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 09:49:20 -0500
From: Xiangliang Yu <yuxiangl@marvell.com>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: yxlraid <yxlraid@gmail.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sat, 9 Mar 2013 06:49:12 -0800
Subject: RE: [PATCH 2/2] PCI: fix system hang issue of Marvell SATA host
 controller
Thread-Topic: [PATCH 2/2] PCI: fix system hang issue of Marvell SATA host
 controller
Thread-Index: Ac4cHpNjzaC/NN+oRiWlWP1lxeJfvAAs0ETQ
Message-ID: <F766E4F80769BD478052FB6533FA745D25F440A477@SC-VEXCH4.marvell.com>
References: <1362666556-10036-1-git-send-email-yxlraid@gmail.com>
 <CAErSpo7feQK7pXD=moA_hf=Y-j82oZZKwfDNzfo2Ea7i9VPxtA@mail.gmail.com>
 <F766E4F80769BD478052FB6533FA745D25F436856A@SC-VEXCH4.marvell.com>
 <CAErSpo6RDC+QyyN4kwt7-kU5d8b1iu+zCQZTGZPxCJU2UicTCA@mail.gmail.com>
 <F766E4F80769BD478052FB6533FA745D25F436861C@SC-VEXCH4.marvell.com>
 <CAErSpo6ascpN=bBUUzkk5W3-Wee_1ZztAyTwnKd-tq=L_9Q3mw@mail.gmail.com>
In-Reply-To: <CAErSpo6ascpN=bBUUzkk5W3-Wee_1ZztAyTwnKd-tq=L_9Q3mw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Bjorn

>> >> > Fix system hang issue: if first accessed resource file of BAR0 ~ 
>> >> > BAR4, system will hang after executing lspci command
>> >>
>> >> This needs more explanation.  We've already read the BARs by the 
>> >> time header quirks are run, so apparently it's not just the mere 
>> >> act of accessing a BAR that causes a hang.
>> >>
>> >> We need to know exactly what's going on here.  For example, do 
>> >> BARs
>> >> 0-4 exist?  Does the device decode accesses to the regions 
>> >> described by the BARs?  The PCI core has to know what resources 
>> >> the device uses, so if the device decodes accesses, we can't just 
>> >> throw away the start/end information.
>> > The BARs 0-4 is exist and the PCI device is enable IO space, but 
>> > user access
>> the regions file by udevadm command with info parameter, the system will hang.
>> > Like this: udevadmin info --attribut-walk
>> --path=/sys/device/pci-device/000:*.
>> > Because the device is just AHCI host controller, don't need the 
>> > BAR0 ~ 4 region
>> file.
>> > Is my explanation ok for the patch?
>>
>> No, I still don't know what causes the hang; I only know that udevadm 
>> can trigger it.  I don't want to just paper over the problem until we 
>> know what the root cause is.
>>
>> Does "lspci -H1 -vv" also cause a hang?  What about "setpci -s<dev> 
>> BASE_ADDRESS_0"?  "setpci -H1 -s<dev> BASE_ADDRESS_0"?
> The commands are ok because the commands can't find the device after accessing IO port.
> The root cause is that accessing of IO port will make the chip go bad. So, the point of the patch is don't export capability of the IO accessing.

>Ah, so the problem is not with accessing the BAR in config space.  The problem is with accessing the I/O port space mapped by the BAR.  Is that right?

Yes...

>Does "udevadm info --attribute-walk" really access the device address space mapped by the BARs?  

The older version maybe will access the space, I just got the info from HP. And I simplify the issue by executing following command:
Cat /sys/devices/pci-device/**/resourceX

I want to set the resources of BAR0 ~ 4 to 0 to avoid the IO accessing by user.

Any question? Thanks!


