Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751695AbaEBJ6u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 05:58:50 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:59809 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbaEBJ6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 05:58:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Grant Likely <grant.likely@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH v3 4/7] of: configure the platform device dma parameters
Date: Fri, 02 May 2014 11:58:30 +0200
Message-ID: <5279118.J5305KQNjB@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140501131210.CCC13C409DA@trevor.secretlab.ca>
References: <1398353407-2345-1-git-send-email-santosh.shilimkar@ti.com> <53610663.7070305@ti.com> <20140501131210.CCC13C409DA@trevor.secretlab.ca>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:YJ/e5+YLrqLdjvJyHuFfOLUCc4ahRrH96/Nv00WQ5rp
 FyqTYYTlttVXDohm/BmtPu/GLzUHvJd+Z2Bvw6HXMwsXYojYdn
 4KY9xx7D8DiKSNsONY2745jHhQ12MCXve9KXy0Ij1cszb5FjPQ
 cRPwod6cUrxQfORkdEMPDhPYsEJRWFuMayFdffRnByLMw673YT
 yPdb25VwbLjoRxawX/Ym6yXeNChWekxUZJGRSborInptdnmbgb
 3NzdNP7vw0soObSzCBZgE+ueeKpEVdlof3B4H56hk/pRyVhkSZ
 t7l4yB1jajxKhLKjG4slRlQ+gS0QPDIVuY6CWToiLdCZpA5keF
 uOqOJ3Un535J06Foqmc4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 May 2014 14:12:10 Grant Likely wrote:
> > > I've got two concerns here. of_dma_get_range() retrieves only the first
> > > tuple from the dma-ranges property, but it is perfectly valid for
> > > dma-ranges to contain multiple tuples. How should we handle it if a
> > > device has multiple ranges it can DMA from?
> > > 
> > 
> > We've not found any cases in current Linux where more than one dma-ranges
> > would be used. Moreover, The MM (definitely for ARM) isn't supported such
> > cases at all (if i understand everything right).
> > - there are only one arm_dma_pfn_limit
> > - there is only one MM zone is used for ARM
> > - some arches like x86,mips can support 2 zones (per arch - not per device or bus)
> >   DMA & DMA32, but they configured once and forever per arch.
> 
> Okay. If anyone ever does implement multiple ranges then this code will
> need to be revisited.

I wonder if it's needed for platforms implementing the standard "ARM memory map" [1].
The document only talks about addresses as seen from the CPU, and I can see
two logical interpretations how the RAM is supposed to be visible from a device:
either all RAM would be visible contiguously at DMA address zero, or everything
would be visible at the same physical address as the CPU sees it.

If anyone picks the first interpretation, we will have to implement that
in Linux. We can of course hope that all hardware designs follow the second
interpretation, which would be more convenient for us here.

	Arnd

[1] http://infocenter.arm.com/help/topic/com.arm.doc.den0001c/DEN0001C_principles_of_arm_memory_maps.pdf
