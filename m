Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069AbaGKJMI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 05:12:08 -0400
Received: from service87.mimecast.com ([91.220.42.44]:50993 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752888AbaGKJLn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 05:11:43 -0400
Date: Fri, 11 Jul 2014 10:11:39 +0100
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Tanmay Inamdar'" <tinamdar@apm.com>,
        "'Rob Herring'" <robherring2@gmail.com>,
        "'linux-pci'" <linux-pci@vger.kernel.org>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "'Benjamin Herrenschmidt'" <benh@kernel.crashing.org>,
        "'Arnd Bergmann'" <arnd@arndb.de>,
        "'linaro-kernel'" <linaro-kernel@lists.linaro.org>,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Sinan Kaya'" <okaya@codeaurora.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Suravee Suthikulanit'" <suravee.suthikulpanit@amd.com>,
        "'Device Tree ML'" <devicetree@vger.kernel.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        "'LAKML'" <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v8 0/9] Support for creating generic PCI host bridges
 from DT
Message-ID: <20140711091139.GM6501@e106497-lin.cambridge.arm.com>
References: <1404240214-9804-1-git-send-email-Liviu.Dudau@arm.com>
 <CAL_JsqK_CfagmiFOpOXVYGry22nGnCZL0ZXeJhYxb9zp=P2fsQ@mail.gmail.com>
 <20140708171828.GM6501@e106497-lin.cambridge.arm.com>
 <CACoXjcn3b7otcbxdr+RAVNHHjHyVsvw0QcmK5jd-QBF8SQX5iw@mail.gmail.com>
 <004501cf9cda$65703610$3050a230$%han@samsung.com>
MIME-Version: 1.0
In-Reply-To: <004501cf9cda$65703610$3050a230$%han@samsung.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 11 Jul 2014 09:11:40.0228 (UTC) FILETIME=[201EF840:01CF9CE8]
X-MC-Unique: 114071110114102701
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 08:33:23AM +0100, Jingoo Han wrote:
> On Friday, July 11, 2014 9:44 AM, Tanmay Inamdar wrote:
> > On Tue, Jul 8, 2014 at 10:18 AM, Liviu Dudau <Liviu.Dudau@arm.com> wrote:
> > > On Sun, Jul 06, 2014 at 04:23:43PM +0100, Rob Herring wrote:
> > >> On Tue, Jul 1, 2014 at 1:43 PM, Liviu Dudau <Liviu.Dudau@arm.com> wrote:
> > >> > This is my resurected attempt at adding support for generic PCI host
> > >> > bridge controllers that make use of device tree information to
> > >> > configure themselves. I've tagged it as v8 although the patches
> > >> > have now been reshuffled in order to ease adoption so referring to
> > >> > the older versions might be a bit of a hoop jumping exercise.
> > >> >
> > >> > Changes from v7:
> > >> >   - Reordered the patches so that fixes and non-controversial patches
> > >> >     from v7 can be accepted more easily. If agreed I can split the
> > >> >     series again into patches that can be upstreamed easily and ones
> > >> >     that still need discussion.
> > >> >   - Moved the of_create_host_bridge() function to drivers/of/of_pci.c
> > >> >     to better reflect its target use.
> > >> >   - Added the function to remap the bus I/O resources that used to be
> > >> >     provided in my arm64 patch series and (re)named it pci_remap_iospace()
> > >> >   - Removed error code checking from parsing and mapping of IRQ from DT
> > >> >     in recognition that some PCI devices will not have legacy IRQ mappings.
> > >> >
> > >> > v7 thread here with all the historic information: https://lkml.org/lkml/2014/3/14/279
> > >>
> > >> Can you publish a branch for this series please.
> > >>
> > >> Rob
> > >>
> > >
> > > Hi Rob,
> > >
> > > I have pushed a brach that matches my v8 patchset +1 obvious missing header include
> > > here: http://www.linux-arm.org/git?p=linux-ld.git;a=shortlog;h=refs/heads/for-upstream/pci_v8
> > >
> > 
> > I was still getting following compilation error after applying arm64
> > pci headers. Please let me know if I am missing something.
> > 
> > linux-git/drivers/of/of_pci.c: In function ‘pci_host_bridge_of_get_ranges’:
> > linux-git/drivers/of/of_pci.c:114:22: error: storage size of ‘range’ isn’t known
> >   struct of_pci_range range;
> >                       ^
> > linux-git/drivers/of/of_pci.c:115:29: error: storage size of ‘parser’
> > isn’t known
> >   struct of_pci_range_parser parser;
> >                              ^
> > linux-git/drivers/of/of_pci.c:121:2: error: implicit declaration of
> > function ‘of_pci_range_parser_init’
> > [-Werror=implicit-function-declaration]
> >   err = of_pci_range_parser_init(&parser, dev);
> > 
> > 
> > Below patch fixes the errors.
> > 
> > diff --git a/drivers/of/of_pci.c b/drivers/of/of_pci.c
> > index 55d8320..da88dac 100644
> > --- a/drivers/of/of_pci.c
> > +++ b/drivers/of/of_pci.c
> > @@ -2,6 +2,7 @@
> >  #include <linux/export.h>
> >  #include <linux/of.h>
> >  #include <linux/of_pci.h>
> > +#include <linux/of_address.h>
> 
> Yes, right. I also found the build errors as above mentioned.
> "of_address.h" should be included, in order to fix the build errors.
> However, for readability, the following would be better.
> 
>  #include <linux/of.h>
> +#include <linux/of_address.h>
>  #include <linux/of_pci.h>
> 
> Best regards,
> Jingoo Han


Thanks, guys! Like I've said, it was not my day when I've submitted v8 series.
I've cherry picked the patches into a clean branch but forgot to be thorough
and was compiling in the old working directory.

Sorry,
Liviu

> 
> > 
> >  static inline int __of_pci_pci_compare(struct device_node *node,
> >                                        unsigned int data)
> > 
> > 
> > > Best regards,
> > > Liviu

-- 
====================
| I would like to |
| fix the world,  |
| but they're not |
| giving me the   |
 \ source code!  /
  ---------------
    ¯\_(ツ)_/¯

