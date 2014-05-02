Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302AbaEBOlv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 10:41:51 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:39485 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406AbaEBOlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 10:41:49 -0400
MIME-Version: 1.0
In-Reply-To: <20140501132516.GG26756@n2100.arm.linux.org.uk>
References: <1398353407-2345-1-git-send-email-santosh.shilimkar@ti.com>
	<536249D6.3020008@ti.com>
	<20140501132516.GG26756@n2100.arm.linux.org.uk>
Date: Fri, 2 May 2014 09:41:48 -0500
Message-ID: <CAL_JsqKcQ3eHPVGmz7LwE-s1KdkOAKTiF43XPjD3bVS2ghKLJA@mail.gmail.com>
Subject: Re: [PATCH v3 0/7] of: setup dma parameters using dma-ranges and dma-coherent
From: Rob Herring <robherring2@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 1, 2014 at 8:25 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Thu, May 01, 2014 at 09:19:18AM -0400, Santosh Shilimkar wrote:
>> Rob, Russell,
>>
>> On Thursday 24 April 2014 11:30 AM, Santosh Shilimkar wrote:
>> > Here is an updated v3 of the series. Series introduces support for setting up
>> > dma parameters based on device tree properties like 'dma-ranges' and
>> > 'dma-coherent' and also update to ARM 32 bit port. Earlier version of the
>> > series can be found here [3], [2] and [1].
>> >
>> > The 'dma-ranges' helps to take care of few DMAable system memory restrictions
>> > by use of dma_pfn_offset which we maintain now per device. Arch code then
>> > uses it for dma address translations for such cases. We update the
>> > dma_pfn_offset accordingly during DT the device creation process.The
>> > 'dma-coherent' property is used to setup arch's coherent dma_ops.
>> >
>> > Hopefully with acks, tested-by this version can get into 3.16 queue. I will
>> > post a followup series for Keystone SOC which will use this infrastructure.
>> > Linus W also wants to use this for ARM integrator platform dma offset issue.
>> >
>> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> > Cc: Russell King <linux@arm.linux.org.uk>
>> > Cc: Arnd Bergmann <arnd@arndb.de>
>> > Cc: Olof Johansson <olof@lixom.net>
>> > Cc: Grant Likely <grant.likely@linaro.org>
>> > Cc: Rob Herring <robh+dt@kernel.org>
>> > Cc: Catalin Marinas <catalin.marinas@arm.com>
>> > Cc: Linus Walleij <linus.walleij@linaro.org>
>> > Cc: Grygorii Strashko <grygorii.strashko@ti.com>
>> >
>> > Grygorii Strashko (2):
>> >   of: introduce of_dma_get_range() helper
>> >   ARM: dma: Use dma_pfn_offset for dma address translation
>> >
>> > Santosh Shilimkar (5):
>> >   device: introduce per device dma_pfn_offset
>> >   of: introduce of_dma_is_coherent() helper
>> >   of: configure the platform device dma parameters
>> >   ARM: dma: implement set_arch_dma_coherent_ops()
>> >   ARM: dma: use phys_addr_t in __dma_page_[cpu_to_dev/dev_to_cpu]
>> >
>> >  arch/arm/include/asm/dma-mapping.h |   28 ++++++++++--
>> >  arch/arm/mm/dma-mapping.c          |    4 +-
>> >  drivers/of/address.c               |   87 ++++++++++++++++++++++++++++++++++++
>> >  drivers/of/platform.c              |   71 +++++++++++++++++++++++++++--
>> >  include/linux/device.h             |    2 +
>> >  include/linux/dma-mapping.h        |    7 +++
>> >  include/linux/of_address.h         |    8 ++++
>> >  include/linux/of_platform.h        |    6 +++
>> >  8 files changed, 204 insertions(+), 9 deletions(-)
>> >
>> How do we go about merging this series ? There is a dependency
>> between the patches and hence the question.
>
> I don't know anymore.  People today want to assert exclusive rights over
> parts of the kernel tree, which makes this kind of cross-patching rather
> impossible.

I can take this series or provide an ack for the DT parts. Either way
it does not matter to me.

> The only workable solution I can see is the long winded way to split the
> series up, merge the first set of dependencies in one merge window, and
> hold the rest back for the following merge window.  Not ideal, but it
> stops the arguments.

That should not be necessary. We should be able to sort this out as it
is not a difficult problem.

Rob
