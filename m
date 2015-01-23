Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020AbbAWNF1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 08:05:27 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:64298 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbbAWNFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 08:05:24 -0500
MIME-Version: 1.0
In-Reply-To: <1822066.pI6QN22RDx@wuerfel>
References: <1414148076-12685-1-git-send-email-daniel.thompson@linaro.org>
	<1822066.pI6QN22RDx@wuerfel>
Date: Fri, 23 Jan 2015 14:05:22 +0100
X-Google-Sender-Auth: l4xFexpxLjQPTDCAfMHwjbVtP0k
Message-ID: <CAMuHMdUpNtL+K28DdC8xJ3vUPZGmviWcYGOVUNuhKQoobdL00Q@mail.gmail.com>
Subject: Re: [PATCH v12 00/15] arm: Fix DEBUG_LL for multi-platform kernels
 (without PL01X)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Paul Bolle <pebolle@tiscali.nl>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        "patches@linaro.org" <patches@linaro.org>, spear-devel@list.st.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Fri, Oct 24, 2014 at 5:46 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> There is still a related bug that we should also fix, but I'd say let's
> take your current patches first and then add whatever is missing
> on top. Specifically, a snippet like this
>
>         default 0xd4017000 if DEBUG_MMP_UART2
>         default 0xd4018000 if DEBUG_MMP_UART3
>         default 0xe0000000 if ARCH_SPEAR13XX
>         default 0xe4007000 if DEBUG_HIP04_UART
>         default 0xf0000be0 if ARCH_EBSA110
>
> still means you get the wrong default when you build a multiplatform
> kernel that you want to boot on HIP04 and you set DEBUG_HIP04_UART
> but you happen to also have ARCH_SPEAR13XX enabled.
>
> I have a patch that I use locally for randconfig builds that tries
> to fix this. It has some overlaps with your work but most parts are
> distinct. See below.

This is still desperately needed for anyone who wants to enable DEBUG_LL
on other platforms using multi_v7_defconfig.

Can you please upstream it?

Thanks!


Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
