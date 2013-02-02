Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757081Ab3BBABN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 19:01:13 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:51279 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755892Ab3BBABH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 19:01:07 -0500
MIME-Version: 1.0
In-Reply-To: <510B81D1.5070302@huawei.com>
References: <1359562210-26536-1-git-send-email-jiang.liu@huawei.com>
	<1359562210-26536-2-git-send-email-jiang.liu@huawei.com>
	<CAE9FiQU2LvEjTpbjs+LUb=vU7XDC_76OEo5irR_Bn_DjvfgQ0w@mail.gmail.com>
	<510A8F9C.5090306@gmail.com>
	<CAE9FiQXBOj7wCJkXPoBDPiVNH7K0iQPExfrWhAuzwVcyrN+ZZQ@mail.gmail.com>
	<510B81D1.5070302@huawei.com>
Date: Fri, 1 Feb 2013 16:01:06 -0800
X-Google-Sender-Auth: T9PMSrcJ6aT-O3G2WoN4QepRHSc
Message-ID: <CAE9FiQVH=0H+YPDKSO3t5Mdi-KndZtFXBit826HCNXQ_X3USyA@mail.gmail.com>
Subject: Re: [PATCH 2/2] acpiphp: remove dead code for PCI host bridge hotplug
From: Yinghai Lu <yinghai@kernel.org>
To: Yijing Wang <wangyijing@huawei.com>
Cc: Jiang Liu <liuj97@gmail.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>, Jiang Liu <jiang.liu@huawei.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 1, 2013 at 12:50 AM, Yijing Wang <wangyijing@huawei.com> wrote:
> On 2013/1/31 23:59, Yinghai Lu wrote:
>> On Thu, Jan 31, 2013 at 7:37 AM, Jiang Liu <liuj97@gmail.com> wrote:
>>>
>>> So I think the code in handle_hotplug_event_bridge() to handle P2P hot-addition
>>> is dead. Yijing has helped to test the code by faking ACPI CUSTOM_METHOD, and it
>>> does work as expected.
>>
>> ok, then.
>>
>> It would be better if you can append some print out from Yijing's test
>> in the changelog.
>>
>
> Hi Yinghai,
>    I used custom_method module to make root port device 0000:00:07.0 support acpi hotplug (by adding _EJ0 method),
> This root port device also connected to a slot which support hotplug. I tested to hot plug root port device 0000:00:07.0,
> and test steps and info as bellow, if there are somethings missing during test, please let me know.
> Thanks very much!
>
> linux-ha2:/sys/bus/pci/slots # lspci -tv
>  \-[0000:00]-+-00.0  Intel Corporation 5520/5500/X58 I/O Hub to ESI Port
>              +-01.0-[0000:01]--+-00.0  Intel Corporation 82576 Gigabit Network Connection
>              |                 \-00.1  Intel Corporation 82576 Gigabit Network Connection
>              +-03.0-[0000:02]----00.0  LSI Logic / Symbios Logic SAS1064ET PCI-Express Fusion-MPT SAS
>              +-04.0-[0000:03]--
>              +-05.0-[0000:04]--
>              +-07.0-[0000:05]--+-00.0  nVidia Corporation GT218 [GeForce G210]
>              |                 \-00.1  nVidia Corporation High Definition Audio Controller
>              +-0d.0  Intel Corporation Device 343a
> linux-ha2:/sys/bus/pci/slots # ls
> 0  0-1  1  3  5  7
> linux-ha2:/sys/bus/pci/slots # cat 1/address
> 0000:00:07
> linux-ha2:/sys/bus/pci/slots # cd 1
> linux-ha2:/sys/bus/pci/slots/1 # ls
> adapter  address  attention  cur_bus_speed  latch  max_bus_speed  module  power
> linux-ha2:/sys/bus/pci/slots/1 # cat power
> 1
> linux-ha2:/sys/bus/pci/slots/1 # echo "\_SB_.NOD0.PCI0.MRP7 3" > /sys/kernel/debug/acpi/sci_notify
> linux-ha2:/sys/bus/pci/slots/1 # cat power
> 0
> linux-ha2:/sys/bus/pci/slots/1 # lspci -tv
>  \-[0000:00]-+-00.0  Intel Corporation 5520/5500/X58 I/O Hub to ESI Port
>              +-01.0-[0000:01]--+-00.0  Intel Corporation 82576 Gigabit Network Connection
>              |                 \-00.1  Intel Corporation 82576 Gigabit Network Connection
>              +-03.0-[0000:02]----00.0  LSI Logic / Symbios Logic SAS1064ET PCI-Express Fusion-MPT SAS
>              +-04.0-[0000:03]--
>              +-05.0-[0000:04]--
>              +-0d.0  Intel Corporation Device 343a
> linux-ha2:/sys/bus/pci/slots/1 # echo "\_SB_.NOD0.PCI0.MRP7 1" > /sys/kernel/debug/acpi/sci_notify
> linux-ha2:/sys/bus/pci/slots/1 # cat power
> 1
> linux-ha2:/sys/bus/pci/slots/1 # lspci -tv
>  \-[0000:00]-+-00.0  Intel Corporation 5520/5500/X58 I/O Hub to ESI Port
>              +-01.0-[0000:01]--+-00.0  Intel Corporation 82576 Gigabit Network Connection
>              |                 \-00.1  Intel Corporation 82576 Gigabit Network Connection
>              +-03.0-[0000:02]----00.0  LSI Logic / Symbios Logic SAS1064ET PCI-Express Fusion-MPT SAS
>              +-04.0-[0000:03]--
>              +-05.0-[0000:04]--
>              +-07.0-[0000:05]--+-00.0  nVidia Corporation GT218 [GeForce G210]
>              |                 \-00.1  nVidia Corporation High Definition Audio Controller
>              +-0d.0  Intel Corporation Device 343a

looks good.

Thanks
