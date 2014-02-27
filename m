Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520AbaB0Kkb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 05:40:31 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:50010 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbaB0Kk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 05:40:29 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Mark Brown <broonie@kernel.org>, Takashi Yoshii <takasi-y@ops.dti.ne.jp>,
        Magnus Damm <magnus.damm@gmail.com>,
        linux-spi <linux-spi@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2 3/6] spi: sh-msiof: Add support for R-Car H2 and M2
Date: Thu, 27 Feb 2014 11:41:46 +0100
Message-ID: <1462634.UcxrmdxVtK@avalon>
User-Agent: KMail/4.11.5 (Linux/3.10.25-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAMuHMdU_ej9cE=qmRL2WqvEW+fNA_5bj7OC2=7B7ZR33FaFUTA@mail.gmail.com>
References: <1393323673-2751-1-git-send-email-geert@linux-m68k.org> <38730952.JbtPf2mapG@avalon> <CAMuHMdU_ej9cE=qmRL2WqvEW+fNA_5bj7OC2=7B7ZR33FaFUTA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

On Thursday 27 February 2014 09:39:54 Geert Uytterhoeven wrote:
> On Wed, Feb 26, 2014 at 11:16 PM, Laurent Pinchart wrote:
> >> diff --git a/Documentation/devicetree/bindings/spi/sh-msiof.txt
> >> b/Documentation/devicetree/bindings/spi/sh-msiof.txt index
> >> eae3c8c9300e..1f0cb33763a1 100644
> >> --- a/Documentation/devicetree/bindings/spi/sh-msiof.txt
> >> +++ b/Documentation/devicetree/bindings/spi/sh-msiof.txt
> >> @@ -1,8 +1,13 @@
> >> 
> >>  Renesas MSIOF spi controller
> >> 
> >>  Required properties:
> >> -- compatible           : "renesas,sh-msiof" for SuperH, or
> >> +- compatible           : "renesas,msiof-<soctype>" for SoCs,
> >> +                      "renesas,sh-msiof" for SuperH, or
> >>                        "renesas,sh-mobile-msiof" for SH Mobile series.
> >> +                      Examples with soctypes are:
> >> +                      "renesas,msiof-sh7724" (SH)
> > 
> > Given that the driver doesn't handle the "renesas,msiof-sh7724" compatible
> > string this might not be a good example. Furthermore SuperH doesn't have
> > DT support. I would thus drop the "renesas,sh-msiof" compatible string
> > from patch 1/6 and wouldn't mention sh7724 here. I very much doubt that
> > someone would have developed DT support for SuperH on the side and
> > shipped products that would be broken by this change :-)
> 
> Upon reading your comment again: do you suggest to also remove the plain
> "renesas,sh-msiof"? That one was present before, since DT support was added
> to the driver in
> 
> commit cf9c86efecf9510e62388fd174cf607671c59fa3
> Author: Bastian Hecht <hechtb@gmail.com>
> Date:   Wed Dec 12 12:54:48 2012 +0100
> 
>     spi/sh-msiof: Add device tree parsing to driver
> 
>     This adds the capability to retrieve setup data from the device tree
>     node. The usage of platform data is still available.
> 
>     Signed-off-by: Bastian Hecht <hechtb+renesas@gmail.com>
>     Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> 
> So I prefer not to remove any pre-existing compatible values.
> Do you agree?

I'd like to remove it (in a separate patch) if we can. The reason is that 
keeping the DT ABI both forward- and backward-compatible is pretty painful 
enough without having to care about compatibility strings that have no user. 
I'd rather work on adding DT support for SuperH MSIOF later when we'll have a 
platform we can test it on, instead of trying to guess now what the needs will 
be, get users later and realize even later on that we made a mistake that we 
can't fix because those users will have DT binaries in the wild. Every 
unneeded bit of DT bindings that we keep in the kernel is one potential 
problem for future binary compatibility.

-- 
Regards,

Laurent Pinchart

