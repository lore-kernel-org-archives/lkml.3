Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517AbaCEJzy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 04:55:54 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:45135 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358AbaCEJzt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 04:55:49 -0500
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Subject: Re: [PATCH 2/3] soc: keystone: add QMSS driver
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <53169036.9060808@ti.com>
Date: Wed, 5 Mar 2014 03:55:43 -0600
Cc: Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Nair, Sandeep" <sandeep_n@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>, Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <0817AD72-FBD0-4DB0-86C7-6C8EAC84BAA2@codeaurora.org>
References: <1393629520-12713-1-git-send-email-santosh.shilimkar@ti.com> <1393629520-12713-3-git-send-email-santosh.shilimkar@ti.com> <AAE2808F-A2C8-4031-BFA4-1A20B182EA69@codeaurora.org> <53169036.9060808@ti.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
X-Mailer: Apple Mail (2.1874)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 4, 2014, at 8:47 PM, Santosh Shilimkar <santosh.shilimkar@ti.com> wrote:

> On Wednesday 05 March 2014 01:59 AM, Kumar Gala wrote:
>> 
>> On Feb 28, 2014, at 5:18 PM, Santosh Shilimkar <santosh.shilimkar@ti.com> wrote:
>> 
>>> From: Sandeep Nair <sandeep_n@ti.com>
>>> 
>>> The QMSS (Queue Manager Sub System) found on Keystone SOCs is one of
>>> the main hardware sub system which forms the backbone of the Keystone
>>> Multi-core Navigator. QMSS consist of queue managers, packed-data structure
>>> processors(PDSP), linking RAM, descriptor pools and infrastructure
>>> Packet DMA.
>>> 
>>> The Queue Manager is a hardware module that is responsible for accelerating
>>> management of the packet queues. Packets are queued/de-queued by writing or
>>> reading descriptor address to a particular memory mapped location. The PDSPs
>>> perform QMSS related functions like accumulation, QoS, or event management.
>>> Linking RAM registers are used to link the descriptors which are stored in
>>> descriptor RAM. Descriptor RAM is configurable as internal or external memory.
>>> 
>>> The QMSS driver manages the PDSP setups, linking RAM regions,
>>> queue pool management (allocation, push, pop and notify) and descriptor
>>> pool management. The specifics on the device tree bindings for
>>> QMSS can be found in:
>>>       Documentation/devicetree/bindings/soc/keystone-qmss.txt
>>> 
>>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>> Cc: Kumar Gala <galak@codeaurora.org>
>>> Cc: Olof Johansson <olof@lixom.net>
>>> Cc: Arnd Bergmann <arnd@arndb.de>
>>> Cc: Grant Likely <grant.likely@linaro.org>
>>> Cc: Rob Herring <robh+dt@kernel.org>
>>> Cc: Mark Rutland <mark.rutland@arm.com>
>>> Signed-off-by: Sandeep Nair <sandeep_n@ti.com>
>>> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
>>> ---
>>> .../devicetree/bindings/soc/keystone-qmss.txt      |  209 +++
>>> drivers/Kconfig                                    |    2 +
>>> drivers/Makefile                                   |    3 +
>>> drivers/soc/Kconfig                                |    2 +
>>> drivers/soc/Makefile                               |    5 +
>>> drivers/soc/keystone/Kconfig                       |   15 +
>>> drivers/soc/keystone/Makefile                      |    5 +
>>> drivers/soc/keystone/qmss_acc.c                    |  591 ++++++++
>>> drivers/soc/keystone/qmss_queue.c                  | 1533 ++++++++++++++++++++
>>> drivers/soc/keystone/qmss_queue.h                  |  236 +++
>>> include/linux/soc/keystone_qmss.h                  |  390 +++++
>>> 11 files changed, 2991 insertions(+)
>>> create mode 100644 Documentation/devicetree/bindings/soc/keystone-qmss.txt
>>> create mode 100644 drivers/soc/Makefile
>>> create mode 100644 drivers/soc/keystone/Kconfig
>>> create mode 100644 drivers/soc/keystone/Makefile
>>> create mode 100644 drivers/soc/keystone/qmss_acc.c
>>> create mode 100644 drivers/soc/keystone/qmss_queue.c
>>> create mode 100644 drivers/soc/keystone/qmss_queue.h
>>> create mode 100644 include/linux/soc/keystone_qmss.h
>> 
>> Do you see qmss being able to provide HW support for a qdisc or doing processor to processor communication over something like rpmsg?
>> 
>> I ask because I do wondering if we should be looking at a drivers/hwqueue as other vendors have similar hardware.
>> 
> QMSS just provides the programming interfaces so that certain queues can be configured to achieve QOS tree. The actual qdisc should be
> part of the network driver as such. The queues are such a generic hardware that it can be used for wide variety of usecases and 
> supporting that through one driver will be really hard. We did talk of hwqueue last year but looks like the usecase variety is
> too much because of generic nature of them.
> 
> QMSS isn't used as such for message passing but queue hardware can be used as done by APM hardware which Arnd pointed me on the other
> thread. As Arnd recommended, the processor to processor communication related drivers should go under drivers/mailbox. One example,
> was the APM QMTM patchset [1]
> 
> From first look the QMSS(APM) and QMTM(APM) looked very similar but they actually differ largely the way it works. Thanks to Arnd
> for useful discussion here at connect, I better understood how the QMTM works.
> 
> If you know any other hardware, which needs similar interfaces as QMSS, we can surely think of another subsystem. QMSS is
> largely network usecase dominated but not limited to only those usecases. It is also used by pure drivers/crypto/ or
> can also be used for data movement for video etc. 
> 
> Regards,
> Santosh
> 
> [1] https://lkml.org/lkml/2014/2/14/703

The Freescale QorIQ Devices have a Queue Manager (QMan) as part of their Data Path Architecture (DPAA).  I haven’t looked at the QMTM from APM, but not sure if mailbox is the best place for these things.  They seem so much more involved than what I’m guessing most people are thinking with mailbox.

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

