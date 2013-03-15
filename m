Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529Ab3COWQO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 18:16:14 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:63014 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755089Ab3COWQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 18:16:13 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [GIT PULL] at91: framebuffer enhancements for 3.10
Date: Fri, 15 Mar 2013 22:13:30 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-8-generic; KDE/4.3.2; x86_64; ; )
Cc: Olof Johansson <olof@lixom.net>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
        Johan Hovold <jhovold@gmail.com>,
        "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org
References: <5142F3DE.1060209@atmel.com>
In-Reply-To: <5142F3DE.1060209@atmel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303152213.31100.arnd@arndb.de>
X-Provags-ID: V02:K0:zPQQZW0DIyRqHvdqcwx0PhZfpdCcJaT686yujnpoERi
 YOVi10KZ+iQO0sUl1GIFTkz9Hp+rIXYwuxJXqYiEFZ9LomIRkH
 SEpKzMRqHznoYGrRMP2oyXFEVMU9Y7gtWsGleOvfXgTwiMmwu+
 SgmLNUazSHMPxL6WAusZqxsLxqaAeU/mRsFYcylIT64cd1fQa+
 IdBwNqgqZ3jj4TRrTKhFH7yoeCHVzIOjHR6CKJ4FutcypLVpee
 9qRMySznRqvQu59jtmN0nqo1ubwJTbzJLAfSGCAOUs3nF+ot1n
 Yr+MptJxouVlTBv03RCf49T+OkiYITDkRz9A0MYYIgdfMSbeH7
 BN+pS82Lj0GiH6KkvKxE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 March 2013, Nicolas Ferre wrote:
> Arnd, Olof,
> 
> Following our conversation about these framebuffer patches for
> Atmel LCD driver, here are the remaining three patches that can be
> pushed for 3.10. As suggested by Arnd, I have kept them on top of last
> commit concerning this topic that have already been merged in arm-soc 3.9
> fixes branch.
> Thanks a lot for taking care of these modifications.

I think it's reasonable to take the patches through the arm-soc tree here,
because you did not manage to get any feedback on them from Florian
and he also didn't pull them into his framebuffer tree.

However, if you are bypassing a maintainer, you should not do that silently,
and you should note that I don't have any intention of taking all framebuffer
patches in the future.

I've taken Florian and the linux-fbdev list on Cc. If there are any objections
to me taking these through the arm-soc tree, please let us know and we can
revert them to find a better way.

I have applied them to the next/drivers branch in the arm-soc tree now.

	Arnd


> The following changes since commit 67cf9c0a00bd88443adb7d6c3efa8b18d03f97c5:
> 
>   ARM: at91: fix LCD-wiring mode (2013-03-13 11:05:04 +0100)
> 
> are available in the git repository at:
> 
>   git://github.com/at91linux/linux-at91.git tags/at91-driversLCD
> 
> for you to fetch changes up to bbd44f6bd9d1aa735b180b29b5719d63a8e87b55:
> 
>   ARM: at91/avr32/atmel_lcdfb: add platform device-id table (2013-03-13 11:05:12 +0100)
> 
> ----------------------------------------------------------------
> Some Atmel framebuffer driver enhancements with modification
> of configuration data in ARM/AT91 and AVR32/AP7 trees.
> A merge of these modifications seems easier through arm-soc
> git tree nowadays.
> 
> ----------------------------------------------------------------
> Johan Hovold (3):
>       ARM: at91/avr32/atmel_lcdfb: add bus-clock entry
>       atmel_lcdfb: move lcdcon2 register access to compute_hozval
>       ARM: at91/avr32/atmel_lcdfb: add platform device-id table
> 
>  arch/arm/mach-at91/at91sam9261.c         |   2 +
>  arch/arm/mach-at91/at91sam9261_devices.c |   6 +-
>  arch/arm/mach-at91/at91sam9263.c         |   1 +
>  arch/arm/mach-at91/at91sam9263_devices.c |   2 +-
>  arch/arm/mach-at91/at91sam9g45.c         |   2 +
>  arch/arm/mach-at91/at91sam9g45_devices.c |   6 +-
>  arch/arm/mach-at91/at91sam9rl.c          |   1 +
>  arch/arm/mach-at91/at91sam9rl_devices.c  |   2 +-
>  arch/avr32/mach-at32ap/at32ap700x.c      |   6 +-
>  drivers/video/atmel_lcdfb.c              | 120 +++++++++++++++++++++++++++--------
>  include/video/atmel_lcdc.h               |   4 +-
>  11 files changed, 117 insertions(+), 35 deletions(-)
> 

