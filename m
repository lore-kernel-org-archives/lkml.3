Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759989Ab3EXDOw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 23:14:52 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:43786 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759888Ab3EXDOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 23:14:50 -0400
Message-ID: <519EDB22.1050509@ozlabs.ru>
Date: Fri, 24 May 2013 13:14:42 +1000
From: Alexey Kardashevskiy <aik@ozlabs.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: linuxppc-dev@lists.ozlabs.org, David Gibson <david@gibson.dropbear.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5 v2] VFIO PPC64: add VFIO support on POWERPC64
References: <1369107191-28547-1-git-send-email-aik@ozlabs.ru> <1369320984.2646.135.camel@ul30vt.home>
In-Reply-To: <1369320984.2646.135.camel@ul30vt.home>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2013 12:56 AM, Alex Williamson wrote:
> On Tue, 2013-05-21 at 13:33 +1000, Alexey Kardashevskiy wrote:
>> The series adds support for VFIO on POWERPC in user space (such as QEMU).
>> The in-kernel real mode IOMMU support is added by another series posted
>> separately.
>>
>> As the first and main aim of this series is the POWERNV platform support,
>> the "Enable on POWERNV platform" patch goes first and introduces an API
>> to be used by the VFIO IOMMU driver. The "Enable on pSeries platform" patch
>> simply registers PHBs in the IOMMU subsystem and expects the API to be present,
>> it enables VFIO support in fully emulated QEMU guests.
>>
>> The main change is that this series was changed and tested against v3.10-rc1.
>> It also contains some bugfixes which are mentioned (if any) in the patch messages.
>>
>> Alexey Kardashevskiy (3):
>>   powerpc/vfio: Enable on POWERNV platform
>>   powerpc/vfio: Implement IOMMU driver for VFIO
>>   powerpc/vfio: Enable on pSeries platform
>>
>>  Documentation/vfio.txt                      |   63 +++++
>>  arch/powerpc/include/asm/iommu.h            |   26 ++
>>  arch/powerpc/kernel/iommu.c                 |  323 +++++++++++++++++++++++
>>  arch/powerpc/platforms/powernv/pci-ioda.c   |    1 +
>>  arch/powerpc/platforms/powernv/pci-p5ioc2.c |    5 +-
>>  arch/powerpc/platforms/powernv/pci.c        |    2 +
>>  arch/powerpc/platforms/pseries/iommu.c      |    4 +
>>  drivers/iommu/Kconfig                       |    8 +
>>  drivers/vfio/Kconfig                        |    6 +
>>  drivers/vfio/Makefile                       |    1 +
>>  drivers/vfio/vfio.c                         |    1 +
>>  drivers/vfio/vfio_iommu_spapr_tce.c         |  377 +++++++++++++++++++++++++++
>>  include/uapi/linux/vfio.h                   |   34 +++
>>  13 files changed, 850 insertions(+), 1 deletion(-)
>>  create mode 100644 drivers/vfio/vfio_iommu_spapr_tce.c
>>
> 
> These look ok to me, how do you want to integrate them?  Should I
> provide Acks on patches 2 & 3 and let them get pushed through the ppc
> tree or should I wait for patch 1 then push 2 & 3 through my tree?

Please ack on 2 & 3 and Ben will merge all three into his tree. Thanks!



-- 
Alexey
