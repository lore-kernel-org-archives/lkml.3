Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751565Ab3FQVem (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 17:34:42 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:49969 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169Ab3FQVel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 17:34:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chao Xie <xiechao.mail@gmail.com>
Subject: Re: [PATCH v2] ARM: mmp: bring up pxa988 with device tree support
Date: Mon, 17 Jun 2013 23:34:05 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Neil Zhang <zhangwm@marvell.com>, Chao Xie <cxie4@marvell.com>,
        "haojian.zhuang@gmail.com" <haojian.zhuang@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>
References: <1369969115-4279-1-git-send-email-zhangwm@marvell.com> <2766142.mFu63TyH69@wuerfel> <CADApbejV3v11jedq=q9Nz7wyVWVAJp-4vYmAifsPb7UsdVj5zg@mail.gmail.com>
In-Reply-To: <CADApbejV3v11jedq=q9Nz7wyVWVAJp-4vYmAifsPb7UsdVj5zg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306172334.05626.arnd@arndb.de>
X-Provags-ID: V02:K0:YLbqoIF3t+2z4UFEcz+KaNiMNTQ1EItVguqEyAQymTZ
 j+kzjPcAE8RaWO1Z7m5Xd/3iicmqrFVF3W8yY0hVm1OzmfB1IV
 aYxX1g5wcIi+d261ya17ydxC7zwvCnzQBLysHoqmuqIG0WcLwZ
 RI7p2dxz9P+yXjd7YhGwcgeEvJYrmTynG+Uk3cQQNMtem+NSNY
 sp6sNQf8cA2MsMrLZ+v0fcVxX4ZuaSM/WSTtdRrJcsnpO5F4Jv
 7eRlH2Vp1GtElUTWT7FNM+U0fqvtznkU66fQqtr1go7d5PDCDR
 ETOB7i/+XJMZwEsHwJKEZ1WKo+brT66e0LoJ2li00ZesqggbXe
 5SyT3DqwrTl7bsIGzBVA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 June 2013, Chao Xie wrote:
> On Fri, Jun 14, 2013 at 8:56 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Friday 14 June 2013 17:15:33 Chao Xie wrote:
> >> On Mon, Jun 10, 2013 at 4:35 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> >
> >> > I guess that is a problem we have on other platforms as well, we should
> >> > find a generic solution for that. It would be nice to reserve a page
> >> > in "fixmap" and have common code map the SCU page into that.
> >> >
> >>
> >> So you mean that reserve a page in arch/arm/asm/include/fixmap.h?
> >
> > Yes.
> >
> >> This reserve will depend on the cpu type beacuse only A9 will have SCU part.
> >
> > I think A5 and ARM11MPCore as well.
> >
> >> I do not know that in fixmap, the #ifdef is acceptable or not.
> >
> > Yes, it is. We don't really use fixmap on ARM for anything other than
> > kmap_atomic at the moment. Please have a look at the powerpc and x86
> > implementations.
> >
> >> For the common code to map the SCU page, where do you suggest to put it?
> >
> > arch/arm/kernel/smp_scu.c.
> >
> I think smp_scu.c may not be good place to put the mapping for SCU page.
> As you know that the fix map will make use of the mapping that set up
> by vector page.
> It will make use of top_pmd, and some APIs only provided under arch/arm/mm/.
> For example
> get_mem_type: for the pgprot for MT_DEVICE
> set_top_pte:
> Is that possible to add a file fixmap.c under arch/arm/mm/? It can
> including all the fix mapping
> except highmem. So SCU is one of it.

It's up to Russell, and he probably has an idea where this should be
going.

Russell, do you think using a fixmap page for the SCU makes sense?
I'm looking for a method to consolidate the various methods of
doing early mappings of the SCU for device tree based platforms.
Where do you think that should be implemented?

	Arnd
