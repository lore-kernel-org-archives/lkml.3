Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766AbaIDKLK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 06:11:10 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:55252 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387AbaIDKLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 06:11:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Andrew Pinski <apinski@cavium.com>, linux-kernel@vger.kernel.org,
        pinskia@gmail.com
Subject: Re: [PATCH 08/24] Allow a 32bit ABI to use the naming of the 64bit ABI syscalls to avoid confusion of not splitting the registers
Date: Thu, 04 Sep 2014 12:11:04 +0200
Message-ID: <3318813.yqP9pCQtAB@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1409779158-30963-9-git-send-email-apinski@cavium.com>
References: <1409779158-30963-1-git-send-email-apinski@cavium.com> <1409779158-30963-9-git-send-email-apinski@cavium.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:V/2CjRBc5f0IMVR53dk49WgjlfFpVDj6+OfUbvwcmOG
 tY8wIwo8wAL2hr1Pf3m23lW3KFhh9YrNZmMKBKagZEcbgroSYf
 lakSvMU25s2eYfWZJpksqxyzI0bbNcz1oXsScP6OnimxZIw4VR
 F/CUmUw8DODUbd4K/r3+K580NQHu4YZU1e5z9gsMcNqap+BDb6
 kRiiaf5qRkuvkUllhnpBkl/GgIGpo0wEP3hDNPLF2Gj+aOKvUp
 IqejbOeW/9AF5yezzCaLhOHTleUW1kpaDg4sIBpkLLTYpQ13hY
 xl7zZHEtNAHG+SmTGpmqSFddo+3C0MCWAas6zavTIG3MpZJ0aW
 NHjEIm2AQD3IYx3JgnmE=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 September 2014 14:19:02 Andrew Pinski wrote:
> + * For 32bit abis where 64bit can be passed via one
> + * register, use the same naming as the 64bit ones
> + * as they will only have a 64 bit off_t.
>   */
> -#if __BITS_PER_LONG == 64 && !defined(__SYSCALL_COMPAT)
> +#if (__BITS_PER_LONG == 64 && !defined(__SYSCALL_COMPAT)) || \
> +       defined(__ARCH_WANT_64BIT_SYSCALLS)
> 

I'm not sure if __ARCH_WANT_64BIT_SYSCALLS is the best name for
this, since it's really only about off_t. It took me a while
to understand what you are doing here.

	Arnd
