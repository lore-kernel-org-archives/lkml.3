Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758805Ab3EGNWI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:22:08 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:56338 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757991Ab3EGNWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:22:05 -0400
Date: Tue, 7 May 2013 15:21:59 +0200
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: Li Zefan <lizefan@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Marek <mmarek@suse.cz>,
        Weng Meiling <wengmeiling.weng@huawei.com>,
        Libo Chen <clbchenlibo.chen@huawei.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH] menuconfig: fix NULL pointer dereference when searching
 a symbol
Message-ID: <20130507132159.GA15137@free.fr>
References: <518869BB.2020808@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <518869BB.2020808@huawei.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li, All,

On Tue, May 07, 2013 at 10:40:59AM +0800, Li Zefan wrote:
> Searching PPC_EFIKA results segmentation fault, and it's because
> get_symbol_prop() returns NULL.
> 
> In this case CONFIG_PPC_EFIKA is defined in arch/powerpc/platforms/
> 52xx/Kconfig, so it won't be parsed if ARCH!=PPC, but menuconfig
> knows this symbol when it parses sound/soc/fsl/Kconfig:
> 
> config SND_MPC52xx_SOC_EFIKA
>         tristate "SoC AC97 Audio support for bbplan Efika and STAC9766"
>         depends on PPC_EFIKA
> 
> This bug was introduced by commit bcdedcc1afd6 ("menuconfig: print more
> info for symbol without prompts").
> 
> Reported-by: Borislav Petkov <bp@alien8.de>
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Reviewed-by: "Yann E. MORIN" <yann.morin.1998@free.fr>

Michal, I'll get this in my tree, and will send a pull-request to you
later (I may have a few other smallish fixes shortly).

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
