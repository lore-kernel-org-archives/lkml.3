Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab3DLII7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 04:08:59 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:53791 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523Ab3DLIIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 04:08:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] MFD: ab8500: pass AB8500 IRQ to debugfs code by resource
Date: Fri, 12 Apr 2013 10:08:51 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Anmar Oueja <anmar.oueja@linaro.org>, Lee Jones <lee.jones@linaro.org>
References: <1365669779-14953-1-git-send-email-linus.walleij@stericsson.com> <201304111633.54110.arnd@arndb.de> <CACRpkdaUMtNjODOGZ2TA+DKnA-T4TsTjhgM4TxaKV7N6fswVaQ@mail.gmail.com>
In-Reply-To: <CACRpkdaUMtNjODOGZ2TA+DKnA-T4TsTjhgM4TxaKV7N6fswVaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304121008.51300.arnd@arndb.de>
X-Provags-ID: V02:K0:auB/Atv/PWT/grILGgA641ld33GUwHV+jo7XURyA+1u
 2+KOKOBU8SZmqDumgYOVHhfM0nmB845GzIj6XzzzcBttyKxz/8
 pDJxX5mL6DwVODv808bT7ENOXfuhVDjpFQ3u0ppUOwOYGTV6gc
 b3uYIkxi7M06dMdhFMA9y93+l4k26thaVs92d3rEkMDQBbjwMA
 bIqST3l26c9hVdFBe2lK6JmT3n+XvDmuz8E5wCHLyfQE/EKIbo
 R1Yi6OBM9zJQy1auwxRGbop6i8Ftoy5zMwvPnPxp42tdiC89BX
 cGCau4Y/tg0q4hDRbPLKLk/c7V0nuML1qt6F92AQ+EAjTOzKCc
 6xBAb2mcqaZt1ufo3nxA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 12 April 2013, Linus Walleij wrote:
> >
> > I think this won't work because the interrupts in ab8500_debug_resources
> > are now local numbers relative to the ab8500->domain irq_domain,
> > while IRQ_DB8500_AB8500 is an global interrupt number.
> 
> Actually, well, this one IRQ (the one I start to pass) is already
> domain-mapped to the global IRQ numberspace, so that one will
> be correct.

I don't know if we're talking about the same thing here.

My point was that passing a domain-mapped IRQ number into mfd_add_devices
with another domain will result in the attempt to map that number into
another domain, which does not work.

> However the debug driver patch, i.e. the entire debugfs driver,
> is completely irqdomain-unaware and has been broken for
> device tree since forever and broken for non-dt builds since
> the IRQ numbers were made local.
> 
> I guess I'll just have to cook a second patch to fix this up...

The debug driver should not need to worry about domains, as long
as the ab8500->domain passed into mfd_add_devices is correctly
set up.

	Arnd
