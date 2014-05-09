Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461AbaEIG7n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 02:59:43 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:55984 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbaEIG7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 02:59:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Magnus Damm <damm@opensource.se>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH] pci: rcar host needs OF
Date: Fri, 09 May 2014 08:59:12 +0200
Message-ID: <13437915.HeCZ0zGaLk@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <9614403.Lyniq7F3TJ@wuerfel>
References: <1399560433-1402630-1-git-send-email-arnd@arndb.de> <CAMuHMdWBzBneDqyDxK5HU3Bt_5CyRfTM_f_6YGJHokG_v17_sw@mail.gmail.com> <9614403.Lyniq7F3TJ@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:e+EJ/P5SStl549vNv1H7LI2ekBvMOBmaRiIRBznNyI6
 kq3sSp6zNDIdcnLeJHlpyECKHA79Rm+l/oJY013L8UtwOY92Si
 UH/7W9oBdF0Og3EztqQ+6W0zNptEnCSXqZeyOqVDrQQ+T76h3j
 jlEk8R79zlLXlGROEK1o1ls8PXRmvTsOOWqytvqkwIOi2z81P/
 jHR/bvDAK5F075yIx/ZeST9C60oJ7Lkn/FFWmslpNqy26q6obN
 FJJSAp+LuJrlwEsL5f7kTNWGUa5v1Y06m8CZXYAwoLAeKlQwnu
 4CS/Tey9wMyDBfv5K1jVXzTLAwE6B6TE5MlBE4mSC9ymXBewjD
 rCjoxqcMhMRiAfKnXREA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 May 2014 17:21:54 Arnd Bergmann wrote:
> On Thursday 08 May 2014 17:16:32 Geert Uytterhoeven wrote:
> > On Thu, May 8, 2014 at 5:06 PM, Ben Dooks <ben.dooks@codethink.co.uk> wrote:
> > >> @@ -27,7 +27,7 @@ config PCI_TEGRA
> > >>
> > >>   config PCI_RCAR_GEN2
> > >>         bool "Renesas R-Car Gen2 Internal PCI controller"
> > >> -       depends on ARCH_SHMOBILE || (ARM && COMPILE_TEST)
> > >> +       depends on ARCH_SHMOBILE || (ARM && OF && COMPILE_TEST)
> > >>         help
> > >>           Say Y here if you want internal PCI support on R-Car Gen2 SoC.
> > >>           There are 3 internal PCI controllers available with a single
> > >>
> > >
> > > This driver /should/ be able to be built for just the platform case
> > > so it sounds like f8f2fe7355fb stopped this but no-one has yet to
> > > notice.
> > 
> > You mean include/linux/of_pci.h should provide a dummy version of
> > of_irq_parse_and_map_pci() returning 0 in case OF=n?
> 
> Good idea, I'll give this patch some testing in the randconfig builder,
> replacing the one above.

The first version was flawed, I submitted a new patch "[PATCH] of/irq:
provide int of_irq_parse_and_map_pci wrapper" now.

	Arnd
