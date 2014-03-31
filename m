Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190AbaCaNw3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 09:52:29 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:47674 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753375AbaCaNwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 09:52:25 -0400
MIME-Version: 1.0
In-Reply-To: <CACxGe6vbEMgZf6LvpHqsW353rcGVZ9iGFVuir4eP5qreC_eXpQ@mail.gmail.com>
References: <1393594976-16728-1-git-send-email-m.szyprowski@samsung.com> <CACxGe6vbEMgZf6LvpHqsW353rcGVZ9iGFVuir4eP5qreC_eXpQ@mail.gmail.com>
From: Grant Likely <grant.likely@linaro.org>
Date: Mon, 31 Mar 2014 06:52:04 -0700
X-Google-Sender-Auth: Hmd8A8AX_kycJkA2jm0U15CGppE
Message-ID: <CACxGe6snm_D=X0cm3OYkX6gLhpKcu120mikuLX8_vVkNxdrhmA@mail.gmail.com>
Subject: Re: [PATCH v6 00/11] reserved-memory regions/CMA in devicetree, again
To: Marek Szyprowski <m.szyprowski@samsung.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        linuxppc-dev <linuxppc-dev@ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2014 at 10:37 AM, Grant Likely <grant.likely@linaro.org> wrote:
> Hi Ben, Russell and Catalin,
>
> I've got this series queued up, and I'd like to be ready to merge it
> in the next merge window. I'm going to queue it up in linux-next. If
> you have any concerns, please shout and it can be removed. I won't ask
> Linus to pull it without you giving the okay.

Hi Ben and Russell.

Any feedback on this? The arch/powerpc and arch/arm patches are a
single line change each and are easy to revert if they cause problems.
I'm going to send Linus a pull request tomorrow morning if I don't
hear anything before then.

g.

> On Fri, Feb 28, 2014 at 1:42 PM, Marek Szyprowski
> <m.szyprowski@samsung.com> wrote:
>> Hello again!
>>
>> Here is another update of the support for reserved memory regions in
>> device tree. I've fixes a few more minor issues pointed by Grant. See
>> changelog for more details.
>>
>> The initial code for this feature were posted here [1], merged as commit
>> 9d8eab7af79cb4ce2de5de39f82c455b1f796963 ("drivers: of: add
>> initialization code for dma reserved memory") and later reverted by
>> commit 1931ee143b0ab72924944bc06e363d837ba05063. For more information,
>> see [2]. Finally a new bindings has been proposed [3] and Josh
>> Cartwright a few days ago prepared some code which implements those
>> bindings [4]. This finally pushed me again to find some time to finish
>> this task and review the code. Josh agreed to give me the ownership of
>> this series to continue preparing them for mainline inclusion.
>>
>> For more information please refer to the changlelog and links below.
>>
>> [1]: http://lkml.kernel.org/g/1377527959-5080-1-git-send-email-m.szyprowski@samsung.com
>> [2]: http://lkml.kernel.org/g/1381476448-14548-1-git-send-email-m.szyprowski@samsung.com
>> [3]: http://lkml.kernel.org/g/20131030134702.19B57C402A0@trevor.secretlab.ca
>> [4]: http://thread.gmane.org/gmane.linux.documentation/19579
>>
>> Changelog:
>>
>> v6:
>> - removed the need for "#memory-region-cells" property
>> - fixed compilation issues on some systems
>> - some other minor code cleanups
>>
>> v5: https://lkml.org/lkml/2014/2/21/147
>> - sliced main patch into several smaller patches on Grant's request
>> - fixed coding style issues pointed by Grant
>> - use node->phandle value directly instead of parsing properties manually
>>
>> v4: https://lkml.org/lkml/2014/2/20/150
>> - dynamic allocations are processed after all static reservations has been
>>   done
>> - moved code for handling static reservations to drivers/of/fdt.c
>> - removed node matching by string comparison, now phandle values are used
>>   directly
>> - moved code for DMA and CMA handling directly to
>>   drivers/base/dma-{coherent,contiguous}.c
>> - added checks for proper #size-cells, #address-cells, ranges properties
>>   in /reserved-memory node
>> - even more code cleanup
>> - added init code for ARM64 and PowerPC
>>
>> v3: http://article.gmane.org/gmane.linux.documentation/20169/
>> - refactored memory reservation code, created common code to parse reg, size,
>>   align, alloc-ranges properties
>> - added support for multiple tuples in 'reg' property
>> - memory is reserved regardless of presence of the driver for its compatible
>> - prepared arch specific hooks for memory reservation (defaults use memblock
>>   calls)
>> - removed node matching by string during device initialization
>> - CMA init code: added checks for required region alignment
>> - more code cleanup here and there
>>
>> v2: http://thread.gmane.org/gmane.linux.documentation/19870/
>> - removed copying of the node name
>> - split shared-dma-pool handling into separate files (one for CMA and one
>>   for dma_declare_coherent based implementations) for making the code easier
>>   to understand
>> - added support for AMBA devices, changed prototypes to use struct decice
>>   instead of struct platform_device
>> - renamed some functions to better match other names used in drivers/of/
>> - restructured the rest of the code a bit for better readability
>> - added 'reusable' property to exmaple linux,cma node in documentation
>> - exclusive dma (dma_coherent) is used for only handling 'shared-dma-pool'
>>   regions without 'reusable' property and CMA is used only for handling
>>   'shared-dma-pool' regions with 'reusable' property.
>>
>> v1: http://thread.gmane.org/gmane.linux.documentation/19579
>> - initial version prepared by Josh Cartwright
>>
>> Summary:
>>
>> Grant Likely (1):
>>   of: document bindings for reserved-memory nodes
>>
>> Marek Szyprowski (10):
>>   drivers: of: add initialization code for static reserved memory
>>   drivers: of: add initialization code for dynamic reserved memory
>>   drivers: of: add support for custom reserved memory drivers
>>   drivers: of: add automated assignment of reserved regions to client
>>     devices
>>   drivers: of: initialize and assign reserved memory to newly created
>>     devices
>>   drivers: dma-coherent: add initialization from device tree
>>   drivers: dma-contiguous: add initialization from device tree
>>   arm: add support for reserved memory defined by device tree
>>   arm64: add support for reserved memory defined by device tree
>>   powerpc: add support for reserved memory defined by device tree
>>
>>  .../bindings/reserved-memory/reserved-memory.txt   |  136 ++++++++++
>>  arch/arm/Kconfig                                   |    1 +
>>  arch/arm/mm/init.c                                 |    2 +
>>  arch/arm64/Kconfig                                 |    1 +
>>  arch/arm64/mm/init.c                               |    1 +
>>  arch/powerpc/Kconfig                               |    1 +
>>  arch/powerpc/kernel/prom.c                         |    3 +
>>  drivers/base/dma-coherent.c                        |   40 +++
>>  drivers/base/dma-contiguous.c                      |  129 +++++++--
>>  drivers/of/Kconfig                                 |    6 +
>>  drivers/of/Makefile                                |    1 +
>>  drivers/of/fdt.c                                   |  140 ++++++++++
>>  drivers/of/of_reserved_mem.c                       |  287 ++++++++++++++++++++
>>  drivers/of/platform.c                              |    7 +
>>  include/asm-generic/vmlinux.lds.h                  |   11 +
>>  include/linux/of_fdt.h                             |    3 +
>>  include/linux/of_reserved_mem.h                    |   60 ++++
>>  17 files changed, 807 insertions(+), 22 deletions(-)
>>  create mode 100644 Documentation/devicetree/bindings/reserved-memory/reserved-memory.txt
>>  create mode 100644 drivers/of/of_reserved_mem.c
>>  create mode 100644 include/linux/of_reserved_mem.h
>>
>> --
>> 1.7.9.5
>>
