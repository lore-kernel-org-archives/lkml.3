Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579Ab3BAIu7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 03:50:59 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:49745 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532Ab3BAIu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 03:50:56 -0500
Message-ID: <510B81D1.5070302@huawei.com>
Date: Fri, 1 Feb 2013 16:50:25 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Jiang Liu <liuj97@gmail.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>, Jiang Liu <jiang.liu@huawei.com>,
        <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 2/2] acpiphp: remove dead code for PCI host bridge hotplug
References: <1359562210-26536-1-git-send-email-jiang.liu@huawei.com> <1359562210-26536-2-git-send-email-jiang.liu@huawei.com> <CAE9FiQU2LvEjTpbjs+LUb=vU7XDC_76OEo5irR_Bn_DjvfgQ0w@mail.gmail.com> <510A8F9C.5090306@gmail.com> <CAE9FiQXBOj7wCJkXPoBDPiVNH7K0iQPExfrWhAuzwVcyrN+ZZQ@mail.gmail.com>
In-Reply-To: <CAE9FiQXBOj7wCJkXPoBDPiVNH7K0iQPExfrWhAuzwVcyrN+ZZQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/1/31 23:59, Yinghai Lu wrote:
> On Thu, Jan 31, 2013 at 7:37 AM, Jiang Liu <liuj97@gmail.com> wrote:
>>
>> So I think the code in handle_hotplug_event_bridge() to handle P2P hot-addition
>> is dead. Yijing has helped to test the code by faking ACPI CUSTOM_METHOD, and it
>> does work as expected.
> 
> ok, then.
> 
> It would be better if you can append some print out from Yijing's test
> in the changelog.
> 

Hi Yinghai,
   I used custom_method module to make root port device 0000:00:07.0 support acpi hotplug (by adding _EJ0 method),
This root port device also connected to a slot which support hotplug. I tested to hot plug root port device 0000:00:07.0,
and test steps and info as bellow, if there are somethings missing during test, please let me know.
Thanks very much!

linux-ha2:/sys/bus/pci/slots # lspci -tv
-+-[0000:40]-+-00.0-[0000:41]--
 |           +-01.0-[0000:42]--+-00.0  Intel Corporation 82576 Gigabit Network Connection
 |           |                 \-00.1  Intel Corporation 82576 Gigabit Network Connection
 |           +-03.0-[0000:43]----00.0  LSI Logic / Symbios Logic SAS1064ET PCI-Express Fusion-MPT SAS
 |           +-04.0-[0000:44]--
 |           +-05.0-[0000:45]--
 |           +-07.0-[0000:46]--
 |           +-0d.0  Intel Corporation Device 343a
 |           +-0d.1  Intel Corporation Device 343b
 |           +-0d.2  Intel Corporation Device 343c
 |           +-0d.3  Intel Corporation Device 343d
 |           +-0d.4  Intel Corporation 5520/5500/X58 Physical Layer Port 0
 |           +-0d.5  Intel Corporation 5520/5500 Physical Layer Port 1
 |           +-0d.6  Intel Corporation Device 341a
 |           +-0d.7  Intel Corporation Device 341b
 |           +-0e.0  Intel Corporation Device 341c
 |           +-0e.1  Intel Corporation Device 341d
 |           +-0e.2  Intel Corporation Device 341e
 |           +-0e.3  Intel Corporation Device 341f
 |           +-0e.4  Intel Corporation Device 3439
 |           +-0f.0  Intel Corporation Device 3424
 |           +-10.0  Intel Corporation 5520/5500/X58 Physical and Link Layer Registers Port 0
 |           +-10.1  Intel Corporation 5520/5500/X58 Routing and Protocol Layer Registers Port 0
 |           +-11.0  Intel Corporation 5520/5500 Physical and Link Layer Registers Port 1
 |           +-11.1  Intel Corporation 5520/5500 Routing & Protocol Layer Register Port 1
 |           +-13.0  Intel Corporation 5520/5500/X58 I/O Hub I/OxAPIC Interrupt Controller
 |           +-14.0  Intel Corporation 5520/5500/X58 I/O Hub System Management Registers
 |           +-14.1  Intel Corporation 5520/5500/X58 I/O Hub GPIO and Scratch Pad Registers
 |           +-14.2  Intel Corporation 5520/5500/X58 I/O Hub Control Status and RAS Registers
 |           +-14.3  Intel Corporation 5520/5500/X58 I/O Hub Throttle Registers
 |           +-15.0  Intel Corporation 5520/5500/X58 Trusted Execution Technology Registers
 |           +-16.0  Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device
 |           +-16.1  Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device
 |           +-16.2  Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device
 |           +-16.3  Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device
 |           +-16.4  Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device
 |           +-16.5  Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device
 |           +-16.6  Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device
 |           \-16.7  Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device
 \-[0000:00]-+-00.0  Intel Corporation 5520/5500/X58 I/O Hub to ESI Port
             +-01.0-[0000:01]--+-00.0  Intel Corporation 82576 Gigabit Network Connection
             |                 \-00.1  Intel Corporation 82576 Gigabit Network Connection
             +-03.0-[0000:02]----00.0  LSI Logic / Symbios Logic SAS1064ET PCI-Express Fusion-MPT SAS
             +-04.0-[0000:03]--
             +-05.0-[0000:04]--
             +-07.0-[0000:05]--+-00.0  nVidia Corporation GT218 [GeForce G210]
             |                 \-00.1  nVidia Corporation High Definition Audio Controller
             +-0d.0  Intel Corporation Device 343a
             +-0d.1  Intel Corporation Device 343b
             +-0d.2  Intel Corporation Device 343c
             +-0d.3  Intel Corporation Device 343d
             +-0d.4  Intel Corporation 5520/5500/X58 Physical Layer Port 0
             +-0d.5  Intel Corporation 5520/5500 Physical Layer Port 1
             +-0d.6  Intel Corporation Device 341a
             +-0d.7  Intel Corporation Device 341b
             +-0e.0  Intel Corporation Device 341c
             +-0e.1  Intel Corporation Device 341d
             +-0e.2  Intel Corporation Device 341e
             +-0e.3  Intel Corporation Device 341f
             +-0e.4  Intel Corporation Device 3439
             +-0f.0  Intel Corporation Device 3424
             +-10.0  Intel Corporation 5520/5500/X58 Physical and Link Layer Registers Port 0
             +-10.1  Intel Corporation 5520/5500/X58 Routing and Protocol Layer Registers Port 0
             +-11.0  Intel Corporation 5520/5500 Physical and Link Layer Registers Port 1
             +-11.1  Intel Corporation 5520/5500 Routing & Protocol Layer Register Port 1
             +-13.0  Intel Corporation 5520/5500/X58 I/O Hub I/OxAPIC Interrupt Controller
             +-14.0  Intel Corporation 5520/5500/X58 I/O Hub System Management Registers
             +-14.1  Intel Corporation 5520/5500/X58 I/O Hub GPIO and Scratch Pad Registers
             +-14.2  Intel Corporation 5520/5500/X58 I/O Hub Control Status and RAS Registers
             +-14.3  Intel Corporation 5520/5500/X58 I/O Hub Throttle Registers
             +-15.0  Intel Corporation 5520/5500/X58 Trusted Execution Technology Registers
             +-16.0  Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device
             +-16.1  Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device
             +-16.2  Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device
             +-16.3  Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device
             +-16.4  Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device
             +-16.5  Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device
             +-16.6  Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device
             +-16.7  Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device
             +-1a.0  Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #4
             +-1a.1  Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #5
             +-1a.2  Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #6
             +-1a.7  Intel Corporation 82801JI (ICH10 Family) USB2 EHCI Controller #2
             +-1c.0-[0000:06]--
             +-1c.1-[0000:07]--
             +-1c.2-[0000:08]--
             +-1c.3-[0000:09]--
             +-1c.4-[0000:0a]----00.0  XGI Technology Inc. (eXtreme Graphics Innovation) Z11/Z11M
             +-1c.5-[0000:0b]--
             +-1d.0  Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #1
             +-1d.1  Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #2
             +-1d.2  Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #3
             +-1d.7  Intel Corporation 82801JI (ICH10 Family) USB2 EHCI Controller #1
             +-1e.0-[0000:0c]--
             +-1f.0  Intel Corporation 82801JIB (ICH10) LPC Interface Controller
             +-1f.2  Intel Corporation 82801JI (ICH10 Family) 4 port SATA IDE Controller #1
             +-1f.3  Intel Corporation 82801JI (ICH10 Family) SMBus Controller
             \-1f.5  Intel Corporation 82801JI (ICH10 Family) 2 port SATA IDE Controller #2
linux-ha2:/sys/bus/pci/slots # ls
0  0-1  1  3  5  7
linux-ha2:/sys/bus/pci/slots # cat 1/address
0000:00:07
linux-ha2:/sys/bus/pci/slots # cd 1
linux-ha2:/sys/bus/pci/slots/1 # ls
adapter  address  attention  cur_bus_speed  latch  max_bus_speed  module  power
linux-ha2:/sys/bus/pci/slots/1 # cat power
1
linux-ha2:/sys/bus/pci/slots/1 # echo "\_SB_.NOD0.PCI0.MRP7 3" > /sys/kernel/debug/acpi/sci_notify
linux-ha2:/sys/bus/pci/slots/1 # cat power
0
linux-ha2:/sys/bus/pci/slots/1 # lspci -tv
-+-[0000:40]-+-00.0-[0000:41]--
 |           +-01.0-[0000:42]--+-00.0  Intel Corporation 82576 Gigabit Network Connection
 |           |                 \-00.1  Intel Corporation 82576 Gigabit Network Connection
 |           +-03.0-[0000:43]----00.0  LSI Logic / Symbios Logic SAS1064ET PCI-Express Fusion-MPT SAS
 |           +-04.0-[0000:44]--
 |           +-05.0-[0000:45]--
 |           +-07.0-[0000:46]--
 |           +-0d.0  Intel Corporation Device 343a
 |           +-0d.1  Intel Corporation Device 343b
 |           +-0d.2  Intel Corporation Device 343c
 |           +-0d.3  Intel Corporation Device 343d
 |           +-0d.4  Intel Corporation 5520/5500/X58 Physical Layer Port 0
 |           +-0d.5  Intel Corporation 5520/5500 Physical Layer Port 1
 |           +-0d.6  Intel Corporation Device 341a
 |           +-0d.7  Intel Corporation Device 341b
 |           +-0e.0  Intel Corporation Device 341c
 |           +-0e.1  Intel Corporation Device 341d
 |           +-0e.2  Intel Corporation Device 341e
 |           +-0e.3  Intel Corporation Device 341f
 |           +-0e.4  Intel Corporation Device 3439
 |           +-0f.0  Intel Corporation Device 3424
 |           +-10.0  Intel Corporation 5520/5500/X58 Physical and Link Layer Registers Port 0
 |           +-10.1  Intel Corporation 5520/5500/X58 Routing and Protocol Layer Registers Port 0
 |           +-11.0  Intel Corporation 5520/5500 Physical and Link Layer Registers Port 1
 |           +-11.1  Intel Corporation 5520/5500 Routing & Protocol Layer Register Port 1
 |           +-13.0  Intel Corporation 5520/5500/X58 I/O Hub I/OxAPIC Interrupt Controller
 |           +-14.0  Intel Corporation 5520/5500/X58 I/O Hub System Management Registers
 |           +-14.1  Intel Corporation 5520/5500/X58 I/O Hub GPIO and Scratch Pad Registers
 |           +-14.2  Intel Corporation 5520/5500/X58 I/O Hub Control Status and RAS Registers
 |           +-14.3  Intel Corporation 5520/5500/X58 I/O Hub Throttle Registers
 |           +-15.0  Intel Corporation 5520/5500/X58 Trusted Execution Technology Registers
 |           +-16.0  Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device
 |           +-16.1  Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device
 |           +-16.2  Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device
 |           +-16.3  Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device
 |           +-16.4  Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device
 |           +-16.5  Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device
 |           +-16.6  Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device
 |           \-16.7  Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device
 \-[0000:00]-+-00.0  Intel Corporation 5520/5500/X58 I/O Hub to ESI Port
             +-01.0-[0000:01]--+-00.0  Intel Corporation 82576 Gigabit Network Connection
             |                 \-00.1  Intel Corporation 82576 Gigabit Network Connection
             +-03.0-[0000:02]----00.0  LSI Logic / Symbios Logic SAS1064ET PCI-Express Fusion-MPT SAS
             +-04.0-[0000:03]--
             +-05.0-[0000:04]--
             +-0d.0  Intel Corporation Device 343a
             +-0d.1  Intel Corporation Device 343b
             +-0d.2  Intel Corporation Device 343c
             +-0d.3  Intel Corporation Device 343d
             +-0d.4  Intel Corporation 5520/5500/X58 Physical Layer Port 0
             +-0d.5  Intel Corporation 5520/5500 Physical Layer Port 1
             +-0d.6  Intel Corporation Device 341a
             +-0d.7  Intel Corporation Device 341b
             +-0e.0  Intel Corporation Device 341c
             +-0e.1  Intel Corporation Device 341d
             +-0e.2  Intel Corporation Device 341e
             +-0e.3  Intel Corporation Device 341f
             +-0e.4  Intel Corporation Device 3439
             +-0f.0  Intel Corporation Device 3424
             +-10.0  Intel Corporation 5520/5500/X58 Physical and Link Layer Registers Port 0
             +-10.1  Intel Corporation 5520/5500/X58 Routing and Protocol Layer Registers Port 0
             +-11.0  Intel Corporation 5520/5500 Physical and Link Layer Registers Port 1
             +-11.1  Intel Corporation 5520/5500 Routing & Protocol Layer Register Port 1
             +-13.0  Intel Corporation 5520/5500/X58 I/O Hub I/OxAPIC Interrupt Controller
             +-14.0  Intel Corporation 5520/5500/X58 I/O Hub System Management Registers
             +-14.1  Intel Corporation 5520/5500/X58 I/O Hub GPIO and Scratch Pad Registers
             +-14.2  Intel Corporation 5520/5500/X58 I/O Hub Control Status and RAS Registers
             +-14.3  Intel Corporation 5520/5500/X58 I/O Hub Throttle Registers
             +-15.0  Intel Corporation 5520/5500/X58 Trusted Execution Technology Registers
             +-16.0  Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device
             +-16.1  Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device
             +-16.2  Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device
             +-16.3  Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device
             +-16.4  Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device
             +-16.5  Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device
             +-16.6  Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device
             +-16.7  Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device
             +-1a.0  Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #4
             +-1a.1  Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #5
             +-1a.2  Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #6
             +-1a.7  Intel Corporation 82801JI (ICH10 Family) USB2 EHCI Controller #2
             +-1c.0-[0000:06]--
             +-1c.1-[0000:07]--
             +-1c.2-[0000:08]--
             +-1c.3-[0000:09]--
             +-1c.4-[0000:0a]----00.0  XGI Technology Inc. (eXtreme Graphics Innovation) Z11/Z11M
             +-1c.5-[0000:0b]--
             +-1d.0  Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #1
             +-1d.1  Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #2
             +-1d.2  Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #3
             +-1d.7  Intel Corporation 82801JI (ICH10 Family) USB2 EHCI Controller #1
             +-1e.0-[0000:0c]--
             +-1f.0  Intel Corporation 82801JIB (ICH10) LPC Interface Controller
             +-1f.2  Intel Corporation 82801JI (ICH10 Family) 4 port SATA IDE Controller #1
             +-1f.3  Intel Corporation 82801JI (ICH10 Family) SMBus Controller
             \-1f.5  Intel Corporation 82801JI (ICH10 Family) 2 port SATA IDE Controller #2
linux-ha2:/sys/bus/pci/slots/1 # echo "\_SB_.NOD0.PCI0.MRP7 1" > /sys/kernel/debug/acpi/sci_notify
linux-ha2:/sys/bus/pci/slots/1 # cat power
1
linux-ha2:/sys/bus/pci/slots/1 # lspci -tv
-+-[0000:40]-+-00.0-[0000:41]--
 |           +-01.0-[0000:42]--+-00.0  Intel Corporation 82576 Gigabit Network Connection
 |           |                 \-00.1  Intel Corporation 82576 Gigabit Network Connection
 |           +-03.0-[0000:43]----00.0  LSI Logic / Symbios Logic SAS1064ET PCI-Express Fusion-MPT SAS
 |           +-04.0-[0000:44]--
 |           +-05.0-[0000:45]--
 |           +-07.0-[0000:46]--
 |           +-0d.0  Intel Corporation Device 343a
 |           +-0d.1  Intel Corporation Device 343b
 |           +-0d.2  Intel Corporation Device 343c
 |           +-0d.3  Intel Corporation Device 343d
 |           +-0d.4  Intel Corporation 5520/5500/X58 Physical Layer Port 0
 |           +-0d.5  Intel Corporation 5520/5500 Physical Layer Port 1
 |           +-0d.6  Intel Corporation Device 341a
 |           +-0d.7  Intel Corporation Device 341b
 |           +-0e.0  Intel Corporation Device 341c
 |           +-0e.1  Intel Corporation Device 341d
 |           +-0e.2  Intel Corporation Device 341e
 |           +-0e.3  Intel Corporation Device 341f
 |           +-0e.4  Intel Corporation Device 3439
 |           +-0f.0  Intel Corporation Device 3424
 |           +-10.0  Intel Corporation 5520/5500/X58 Physical and Link Layer Registers Port 0
 |           +-10.1  Intel Corporation 5520/5500/X58 Routing and Protocol Layer Registers Port 0
 |           +-11.0  Intel Corporation 5520/5500 Physical and Link Layer Registers Port 1
 |           +-11.1  Intel Corporation 5520/5500 Routing & Protocol Layer Register Port 1
 |           +-13.0  Intel Corporation 5520/5500/X58 I/O Hub I/OxAPIC Interrupt Controller
 |           +-14.0  Intel Corporation 5520/5500/X58 I/O Hub System Management Registers
 |           +-14.1  Intel Corporation 5520/5500/X58 I/O Hub GPIO and Scratch Pad Registers
 |           +-14.2  Intel Corporation 5520/5500/X58 I/O Hub Control Status and RAS Registers
 |           +-14.3  Intel Corporation 5520/5500/X58 I/O Hub Throttle Registers
 |           +-15.0  Intel Corporation 5520/5500/X58 Trusted Execution Technology Registers
 |           +-16.0  Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device
 |           +-16.1  Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device
 |           +-16.2  Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device
 |           +-16.3  Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device
 |           +-16.4  Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device
 |           +-16.5  Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device
 |           +-16.6  Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device
 |           \-16.7  Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device
 \-[0000:00]-+-00.0  Intel Corporation 5520/5500/X58 I/O Hub to ESI Port
             +-01.0-[0000:01]--+-00.0  Intel Corporation 82576 Gigabit Network Connection
             |                 \-00.1  Intel Corporation 82576 Gigabit Network Connection
             +-03.0-[0000:02]----00.0  LSI Logic / Symbios Logic SAS1064ET PCI-Express Fusion-MPT SAS
             +-04.0-[0000:03]--
             +-05.0-[0000:04]--
             +-07.0-[0000:05]--+-00.0  nVidia Corporation GT218 [GeForce G210]
             |                 \-00.1  nVidia Corporation High Definition Audio Controller
             +-0d.0  Intel Corporation Device 343a
             +-0d.1  Intel Corporation Device 343b
             +-0d.2  Intel Corporation Device 343c
             +-0d.3  Intel Corporation Device 343d
             +-0d.4  Intel Corporation 5520/5500/X58 Physical Layer Port 0
             +-0d.5  Intel Corporation 5520/5500 Physical Layer Port 1
             +-0d.6  Intel Corporation Device 341a
             +-0d.7  Intel Corporation Device 341b
             +-0e.0  Intel Corporation Device 341c
             +-0e.1  Intel Corporation Device 341d
             +-0e.2  Intel Corporation Device 341e
             +-0e.3  Intel Corporation Device 341f
             +-0e.4  Intel Corporation Device 3439
             +-0f.0  Intel Corporation Device 3424
             +-10.0  Intel Corporation 5520/5500/X58 Physical and Link Layer Registers Port 0
             +-10.1  Intel Corporation 5520/5500/X58 Routing and Protocol Layer Registers Port 0
             +-11.0  Intel Corporation 5520/5500 Physical and Link Layer Registers Port 1
             +-11.1  Intel Corporation 5520/5500 Routing & Protocol Layer Register Port 1
             +-13.0  Intel Corporation 5520/5500/X58 I/O Hub I/OxAPIC Interrupt Controller
             +-14.0  Intel Corporation 5520/5500/X58 I/O Hub System Management Registers
             +-14.1  Intel Corporation 5520/5500/X58 I/O Hub GPIO and Scratch Pad Registers
             +-14.2  Intel Corporation 5520/5500/X58 I/O Hub Control Status and RAS Registers
             +-14.3  Intel Corporation 5520/5500/X58 I/O Hub Throttle Registers
             +-15.0  Intel Corporation 5520/5500/X58 Trusted Execution Technology Registers
             +-16.0  Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device
             +-16.1  Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device
             +-16.2  Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device
             +-16.3  Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device
             +-16.4  Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device
             +-16.5  Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device
             +-16.6  Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device
             +-16.7  Intel Corporation 5520/5500/X58 Chipset QuickData Technology Device
             +-1a.0  Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #4
             +-1a.1  Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #5
             +-1a.2  Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #6
             +-1a.7  Intel Corporation 82801JI (ICH10 Family) USB2 EHCI Controller #2
             +-1c.0-[0000:06]--
             +-1c.1-[0000:07]--
             +-1c.2-[0000:08]--
             +-1c.3-[0000:09]--
             +-1c.4-[0000:0a]----00.0  XGI Technology Inc. (eXtreme Graphics Innovation) Z11/Z11M
             +-1c.5-[0000:0b]--
             +-1d.0  Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #1
             +-1d.1  Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #2
             +-1d.2  Intel Corporation 82801JI (ICH10 Family) USB UHCI Controller #3
             +-1d.7  Intel Corporation 82801JI (ICH10 Family) USB2 EHCI Controller #1
             +-1e.0-[0000:0c]--
             +-1f.0  Intel Corporation 82801JIB (ICH10) LPC Interface Controller
             +-1f.2  Intel Corporation 82801JI (ICH10 Family) 4 port SATA IDE Controller #1
             +-1f.3  Intel Corporation 82801JI (ICH10 Family) SMBus Controller
             \-1f.5  Intel Corporation 82801JI (ICH10 Family) 2 port SATA IDE Controller #2

> Thanks
> 
> Yinghai
> 
> 


-- 
Thanks!
Yijing

