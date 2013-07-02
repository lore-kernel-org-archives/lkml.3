Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932073Ab3GBVMm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 17:12:42 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:55419 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754428Ab3GBVMk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 17:12:40 -0400
MIME-Version: 1.0
In-Reply-To: <1372758414-21513-1-git-send-email-vincent.stehle@freescale.com>
References: <1372758414-21513-1-git-send-email-vincent.stehle@freescale.com>
Date: Tue, 2 Jul 2013 14:12:39 -0700
Message-ID: <CAGa+x859XVrV3r_XAMREkUgQEdjNJ5Z+0E8ZQfPqfb+1e3SLaw@mail.gmail.com>
Subject: Re: [PATCH linux-next] i2c-designware: use div_u64 to fix link
From: Kevin Hilman <khilman@linaro.org>
To: =?ISO-8859-1?Q?Vincent_Stehl=E9?= <vincent.stehle@freescale.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-i2c@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        Christian Ruppert <christian.ruppert@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 2, 2013 at 2:46 AM, Vincent Stehlé
<vincent.stehle@freescale.com> wrote:
> This fixes the following link error:
>
>   drivers/built-in.o: In function `dw_i2c_probe':
>   of_iommu.c:(.text+0x18c8f0): undefined reference to `__aeabi_uldivmod'
>   make: *** [vmlinux] Error 1
>
> Signed-off-by: Vincent Stehlé <vincent.stehle@freescale.com>
> Cc: Wolfram Sang <wsa@the-dreams.de>
> Cc: Christian Ruppert <christian.ruppert@abilis.com>
> Cc: Pierrick Hascoet <pierrick.hascoet@abilis.com>
> ---
>
>
> Hi,
>
> Linux next-20130702 link broke for ARM config multi_v7_defconfig. This is with
> gcc 4.7.2 but I am not sure it matters much here.
>
> This patch repairs the link.
>
> It did not break anything for me on i.MX6 sabre sd, but it does'nt have a
> designware i2c, so more reviewing/testing is welcome.

This also broke a handful of other ARM defconfigs (notably spear*_defconfig,)

I build tested this on top of next-20130702 for multi_v7_defconfig as
well as all 3 spear defconfigs, and confirm that linux-next is back to
building for those platforms.

Tested-by: Kevin Hilman <khilman@linaro.org.

Kevin
