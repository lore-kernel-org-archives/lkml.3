Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758230Ab3D2M6X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 08:58:23 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:49353 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757353Ab3D2M6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 08:58:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Bastian Hecht <hechtb@gmail.com>
Subject: Re: [PATCH 03/21] ARM: shmobile: don't call irqchip_init unconditionallyA
Date: Mon, 29 Apr 2013 14:58:16 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: Simon Horman <horms@verge.net.au>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org, Bastian Hecht <hechtb+renesas@gmail.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
References: <1366910944-3033663-1-git-send-email-arnd@arndb.de> <20130426004835.GA20070@verge.net.au> <CABYn4sxjpp3yPkjDM9XhX6fyT-g_OoCjcnD1u=5oyb+Y6y=Nmw@mail.gmail.com>
In-Reply-To: <CABYn4sxjpp3yPkjDM9XhX6fyT-g_OoCjcnD1u=5oyb+Y6y=Nmw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304291458.16634.arnd@arndb.de>
X-Provags-ID: V02:K0:R1VLuPUqj42VE+gCwjdPh0Va0NDGzozZ+cHNEI/CMB1
 1dDxyligkw9+unAgMnjI3lBW4mEVT+JSKCOJZC8wecQlLT5rsw
 lMGT7Cf1NTBSIpy/gq9tfvKcl25O0Tmv6tyVMNjQ8bgf2LCWIU
 bYFbuGR0DMpWlMuCT6TNz/HUwLcRJitbESd7Kn4zIkls5YW133
 bUgaP+0W1YU4X+A2WyUMr6isR/anDJZl5adQp7DIoFy3nGpvG8
 A0qOeYku7l/6snCH7WhprRt7dQ8JurFe/Y2Jm0TGER7dPfe95y
 NRNJxuZnCWY8gjavwDWq3CZ3ObF6lMhOvxJtaaFvHXnPOEo29W
 pwsrvcH8d2c8hqenbkV8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 April 2013, Bastian Hecht wrote:
> > This one seems broken as the armadillo800eva board currently uses
> > it to initialise GIC even if CONFIG_ATAGS is not defined.
> >
> > I did test the above change on the armadillo800eva board
> > with the above change and CONFIG_ATAGS disabled, the result was
> > a boot failure. With the change reverted booting seems fine.
> 
> CONFIG_ATAGS and CONFIG_ARM_APPENDED_DTB are two ways to pass the
> device tree information, right?

No, the two are methods alternative methods for booting from a legacy
boot loader. CONFIG_ATAGS is the old boot method without a DT, using
a board file and a MACHINE_START() macro. ARM_APPENDED_DTB means you
have a DT linked into the kernel but pass ATAGS to the kernel which
uses the passed data to modify the DT.

> So we run into trouble when we use the later but disable the first.
> Is there a reason why you wanted to avoid using two times just "if
> (!IS_ENABLED(CONFIG_OF))", Arnd?

I incorrectly assumed that the second one was only used without DT,
since it uses hardcoded MMIO locations rather than using of_iomap().

	Arnd
