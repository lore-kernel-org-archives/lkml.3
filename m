Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289Ab3HQTCw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 15:02:52 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:51317 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754213Ab3HQTCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 15:02:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [RFC v1 3/5] ARM: mvebu: add Armada 150 uart to lowlevel debug
Date: Sat, 17 Aug 2013 21:01:51 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1376682098-10580-1-git-send-email-sebastian.hesselbarth@gmail.com> <1376682098-10580-4-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1376682098-10580-4-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201308172101.51537.arnd@arndb.de>
X-Provags-ID: V02:K0:nHiBD/mLKLe8HyCUCjuMypaRgjHDg12P+lnFVQvGqTU
 jSbQWs97t3EQs36TAqqiBcqdz+soiiC+xI845+SdheNhsxdIJD
 f4qwtOxG53Rwjz2M+93NB4AtuZQFxE3YPBj7c4p73/li0658CN
 3R69FCZsH9XfMRQZx2XV5rKLs906150BVq/LguggG4VCz5ZcUA
 Zj/ymoRseuvesGi3keGD7zPvNoRZVYx5hNrR6zwcW4W6hdol9m
 e4L0dvB53pyAsWyWoW89TudFWTNJnGwMfXeq+hGvfk08TgC0im
 y9sKpy5roQpckKA8q1L90JDHQ11FfJG0RYni5xG48ZRY1V7rUt
 BB1vKRrfD5onNb6ZIKSM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 August 2013, Sebastian Hesselbarth wrote:
> 
> -#ifdef CONFIG_DEBUG_MVEBU_UART_ALTERNATE
> -#define ARMADA_370_XP_REGS_PHYS_BASE   0xf1000000
> -#else
> -#define ARMADA_370_XP_REGS_PHYS_BASE   0xd0000000
> +#if defined(CONFIG_MACH_ARMADA_1500)
> +#define MVEBU_REGS_PHYS_BASE   0xf7f80000
> +#define MVEBU_REGS_VIRT_BASE   0xf7f80000
> +#define MVEBU_UART0_OFFSET     0x00049000
> +#elif defined(CONFIG_DEBUG_MVEBU_UART)
> +#define MVEBU_REGS_PHYS_BASE   0xd0000000
> +#define MVEBU_REGS_VIRT_BASE   0xfec00000
> +#define MVEBU_UART0_OFFSET     0x00012000
> +#else /* CONFIG_DEBUG_MVEBU_UART_ALTERNATE */

It seems wrong to base this on CONFIG_MACH_ARMADA_1500. I think you need to
add a new config option just like we have for all other platforms. The above
makes it impossible to build a multiplatform kernel and select 
CONFIG_DEBUG_MVEBU_UART for debugging while keeping CONFIG_MACH_ARMADA_1500
enabled.

	Arnd
