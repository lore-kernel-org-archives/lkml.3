Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751453AbaGKAoL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 20:44:11 -0400
Received: from exprod5og106.obsmtp.com ([64.18.0.182]:52099 "HELO
	exprod5og106.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750896AbaGKAoJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 20:44:09 -0400
MIME-Version: 1.0
In-Reply-To: <20140708171828.GM6501@e106497-lin.cambridge.arm.com>
References: <1404240214-9804-1-git-send-email-Liviu.Dudau@arm.com>
	<CAL_JsqK_CfagmiFOpOXVYGry22nGnCZL0ZXeJhYxb9zp=P2fsQ@mail.gmail.com>
	<20140708171828.GM6501@e106497-lin.cambridge.arm.com>
Date: Thu, 10 Jul 2014 17:44:07 -0700
Message-ID: <CACoXjcn3b7otcbxdr+RAVNHHjHyVsvw0QcmK5jd-QBF8SQX5iw@mail.gmail.com>
Subject: Re: [PATCH v8 0/9] Support for creating generic PCI host bridges from DT
From: Tanmay Inamdar <tinamdar@apm.com>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: Rob Herring <robherring2@gmail.com>, linux-pci <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Arnd Bergmann <arnd@arndb.de>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jul 8, 2014 at 10:18 AM, Liviu Dudau <Liviu.Dudau@arm.com> wrote:
> On Sun, Jul 06, 2014 at 04:23:43PM +0100, Rob Herring wrote:
>> On Tue, Jul 1, 2014 at 1:43 PM, Liviu Dudau <Liviu.Dudau@arm.com> wrote:
>> > This is my resurected attempt at adding support for generic PCI host
>> > bridge controllers that make use of device tree information to
>> > configure themselves. I've tagged it as v8 although the patches
>> > have now been reshuffled in order to ease adoption so referring to
>> > the older versions might be a bit of a hoop jumping exercise.
>> >
>> > Changes from v7:
>> >   - Reordered the patches so that fixes and non-controversial patches
>> >     from v7 can be accepted more easily. If agreed I can split the
>> >     series again into patches that can be upstreamed easily and ones
>> >     that still need discussion.
>> >   - Moved the of_create_host_bridge() function to drivers/of/of_pci.c
>> >     to better reflect its target use.
>> >   - Added the function to remap the bus I/O resources that used to be
>> >     provided in my arm64 patch series and (re)named it pci_remap_iospace()
>> >   - Removed error code checking from parsing and mapping of IRQ from DT
>> >     in recognition that some PCI devices will not have legacy IRQ mappings.
>> >
>> > v7 thread here with all the historic information: https://lkml.org/lkml/2014/3/14/279
>>
>> Can you publish a branch for this series please.
>>
>> Rob
>>
>
> Hi Rob,
>
> I have pushed a brach that matches my v8 patchset +1 obvious missing header include
> here: http://www.linux-arm.org/git?p=linux-ld.git;a=shortlog;h=refs/heads/for-upstream/pci_v8
>

I was still getting following compilation error after applying arm64
pci headers. Please let me know if I am missing something.

linux-git/drivers/of/of_pci.c: In function ‘pci_host_bridge_of_get_ranges’:
linux-git/drivers/of/of_pci.c:114:22: error: storage size of ‘range’ isn’t known
  struct of_pci_range range;
                      ^
linux-git/drivers/of/of_pci.c:115:29: error: storage size of ‘parser’
isn’t known
  struct of_pci_range_parser parser;
                             ^
linux-git/drivers/of/of_pci.c:121:2: error: implicit declaration of
function ‘of_pci_range_parser_init’
[-Werror=implicit-function-declaration]
  err = of_pci_range_parser_init(&parser, dev);


Below patch fixes the errors.

diff --git a/drivers/of/of_pci.c b/drivers/of/of_pci.c
index 55d8320..da88dac 100644
--- a/drivers/of/of_pci.c
+++ b/drivers/of/of_pci.c
@@ -2,6 +2,7 @@
 #include <linux/export.h>
 #include <linux/of.h>
 #include <linux/of_pci.h>
+#include <linux/of_address.h>

 static inline int __of_pci_pci_compare(struct device_node *node,
                                       unsigned int data)


> Best regards,
> Liviu
>
>
> --
> ====================
> | I would like to |
> | fix the world,  |
> | but they're not |
> | giving me the   |
>  \ source code!  /
>   ---------------
>     ¯\_(ツ)_/¯
>
