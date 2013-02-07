Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718Ab3BGIUW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 03:20:22 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:52984 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401Ab3BGIUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 03:20:19 -0500
MIME-Version: 1.0
In-Reply-To: <51135F43.4030209@monstr.eu>
References: <1359475380-31512-1-git-send-email-abrodkin@synopsys.com>
	<CACxGe6tjyx3GTgNgMRtvwhrFsTGizkeTqY_N6=2gdQjvMSD8Ug@mail.gmail.com>
	<CAHTX3d+XZ6VJDVYKHhg33Z+O8Koo99Yq--W8qitcSe543dWUuA@mail.gmail.com>
	<11273481.VQZWGoSGBC@wuerfel>
	<511295A8.5070106@monstr.eu>
	<CAMuHMdUia08Upt6p8cVrC7Uazo3KGbSCZEg-mLaNYALdty88bA@mail.gmail.com>
	<CAHTX3dL1THVgfhJkMs9w4wxD3tSgvm=V5i057074pRGxQ1vTOQ@mail.gmail.com>
	<CAMuHMdUtoSr=CuLQgZ0An8f-hriKun-EdkJPfEuUsKVEVNt7SA@mail.gmail.com>
	<51135F43.4030209@monstr.eu>
Date: Thu, 7 Feb 2013 09:20:18 +0100
X-Google-Sender-Auth: 7dUx27ocVi7Gff-uEIqBA1dleoo
Message-ID: <CAMuHMdWWfSaO-BSMjiGpScrrtZmsAHnpSDDOMAAsFOsWEJuSow@mail.gmail.com>
Subject: Re: [PATCH] drivers/block/xsysace - replace in(out)_8/in(out)_be16/in(out)_le16
 with generic iowrite(read)8/16(be)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: monstr@monstr.eu
Cc: Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@secretlab.ca>,
        Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, dahinds@users.sourceforge.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 7, 2013 at 9:01 AM, Michal Simek <monstr@monstr.eu> wrote:
> ok. Can you please confirm with me that the same problem is also for
> iowrite32be
> ioread16be and ioread32be?
>
> This description seems to me correct for BE and LE.
> #define ioread16be(addr)       __be16_to_cpu(__raw_readw(addr))
> #define ioread32be(addr)       __be32_to_cpu(__raw_readl(addr))
>
> #define iowrite16be(v, addr)   __raw_writew(__cpu_to_be16(v), addr)
> #define iowrite32be(v, addr)   __raw_writel(__cpu_to_be32(v), addr)
>
> What do you think?

Looks fine to me. Arnd, Ben?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
