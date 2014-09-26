Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386AbaIZPHP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 11:07:15 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:46140 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755455AbaIZPHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 11:07:12 -0400
MIME-Version: 1.0
X-Originating-IP: [2a01:e35:2434:4600:aca4:bf5e:39c6:55e8]
In-Reply-To: <1411513877.24563.62.camel@ul30vt.home>
References: <1411483586-29304-1-git-send-email-a.motakis@virtualopensystems.com>
 <1411483586-29304-14-git-send-email-a.motakis@virtualopensystems.com> <1411513877.24563.62.camel@ul30vt.home>
From: Antonios Motakis <a.motakis@virtualopensystems.com>
Date: Fri, 26 Sep 2014 17:06:52 +0200
Message-ID: <CAG8rG2xgXZsNMC-UrnjTmxAisO1gmboZXHMq1bi5Fm+VpZH-Ag@mail.gmail.com>
Subject: Re: [PATCHv7 13/26] vfio: amba: add the VFIO for AMBA devices module
 to Kconfig
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm-arm <kvmarm@lists.cs.columbia.edu>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        VirtualOpenSystems Technical Team <tech@virtualopensystems.com>,
        KVM devel mailing list <kvm@vger.kernel.org>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        Kim Phillips <kim.phillips@freescale.com>,
        Eric Auger <eric.auger@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 1:11 AM, Alex Williamson
<alex.williamson@redhat.com> wrote:
> On Tue, 2014-09-23 at 16:46 +0200, Antonios Motakis wrote:
>> Enable building the VFIO AMBA driver. VFIO_AMBA depends on VFIO_PLATFORM,
>> since it is sharing a portion of the code, and it is essentially implemented
>> as a platform device whose resources are discovered via AMBA specific APIs
>> in the kernel.
>>
>> Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
>> ---
>>  drivers/vfio/platform/Kconfig  | 10 ++++++++++
>>  drivers/vfio/platform/Makefile |  4 ++++
>>  2 files changed, 14 insertions(+)
>>
>> diff --git a/drivers/vfio/platform/Kconfig b/drivers/vfio/platform/Kconfig
>> index c51af17..8b97786 100644
>> --- a/drivers/vfio/platform/Kconfig
>> +++ b/drivers/vfio/platform/Kconfig
>> @@ -7,3 +7,13 @@ config VFIO_PLATFORM
>>         framework.
>>
>>         If you don't know what to do here, say N.
>> +
>> +config VFIO_AMBA
>> +     tristate "VFIO support for AMBA devices"
>> +     depends on VFIO && VFIO_PLATFORM && EVENTFD && ARM_AMBA
>
> nit, VFIO_PLATFORM already depends on VFIO && EVENTFD

Ack

>
>> +     help
>> +       Support for ARM AMBA devices with VFIO. This is required to make
>> +       use of ARM AMBA devices present on the system using the VFIO
>> +       framework.
>> +
>> +       If you don't know what to do here, say N.
>> diff --git a/drivers/vfio/platform/Makefile b/drivers/vfio/platform/Makefile
>> index 279862b..1957170 100644
>> --- a/drivers/vfio/platform/Makefile
>> +++ b/drivers/vfio/platform/Makefile
>> @@ -2,3 +2,7 @@
>>  vfio-platform-y := vfio_platform.o vfio_platform_common.o
>>
>>  obj-$(CONFIG_VFIO_PLATFORM) += vfio-platform.o
>> +
>> +vfio-amba-y := vfio_amba.o
>> +
>> +obj-$(CONFIG_VFIO_AMBA) += vfio-amba.o
>
>
>



-- 
Antonios Motakis
Virtual Open Systems
