Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172Ab3C1P0B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 11:26:01 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:49691 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754526Ab3C1P0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 11:26:00 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH 1/2] ARM: irq: Call irqchit_init if no init_irq function is specified
Date: Thu, 28 Mar 2013 15:25:42 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-13-generic; KDE/4.3.2; x86_64; ; )
Cc: Rob Herring <robherring2@gmail.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Olof Johansson <olof@lixom.net>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <1364463704-13692-1-git-send-email-maxime.ripard@free-electrons.com> <51545832.1050504@gmail.com> <20130328145155.GB3368@n2100.arm.linux.org.uk>
In-Reply-To: <20130328145155.GB3368@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303281525.42334.arnd@arndb.de>
X-Provags-ID: V02:K0:ZFpRidj5xFDeHRoaI5TxXnsnhx4AX5vqxhsvClc7k1c
 iwT03SJc1wAxx6p4/3p4ZylwCT0pzFOzlAkzoJvy7ZfGNeJ2Fc
 2XQN+DwM7G+rJzu842/1UjwpUc/27C9LfhRGyGndBSZknFuI/s
 DWuPMD1y/I+hmsEJOHwhFgUNvpDyxkFziLLNNO6/Flo0ZZbvww
 nOTOg9nfSzd9Et2AQmrOGMehhBeyUwgEXu0HwtHTXiq0dRFhlf
 udGSwSYDvOZpKEpyXPge6T6wtP1/h2O3XVp5Im3uJmV/QZAKWe
 NlKVGC2eZzcl2Xt2D1Uq2J+JmhD+yNZzMGwmUCT4VX91WXPOin
 rj2AfTLqB2Ibh+qUJ4rU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 March 2013, Russell King - ARM Linux wrote:
> Better:
> 
> #ifdef CONFIG_OF
>         if (!machine_desc->init_irq)
>                 irqchip_init();
>         else
> #endif
>                 machine_desc->init_irq();
> 
> which means we don't even get the test if !OF, and if someone mistakenly
> sets this to NULL for a !OF platform, they get to know about it.

Right. With the new IS_DEFINED() macro, we could even turn this into

	if (IS_DEFINED(CONFIG_OF) && !machine_desc->init_irq)
		irqchip_init();
	else
		machine_desc->init_irq();

to the same effect.

	Arnd
