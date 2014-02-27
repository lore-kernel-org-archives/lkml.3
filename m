Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879AbaB0XAq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 18:00:46 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:53884 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbaB0XAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 18:00:43 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Bastian Hecht <hechtb@gmail.com>, Mark Brown <broonie@kernel.org>,
        Takashi Yoshii <takasi-y@ops.dti.ne.jp>,
        Magnus Damm <magnus.damm@gmail.com>,
        linux-spi <linux-spi@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2 3/6] spi: sh-msiof: Add support for R-Car H2 and M2
Date: Fri, 28 Feb 2014 00:02:04 +0100
Message-ID: <10401513.fZZM0mLxSj@avalon>
User-Agent: KMail/4.11.5 (Linux/3.10.25-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAMuHMdU6R_Wubsx2KCAXVBynzqquJekDNDZ-Sq1sKYEOM1RtTw@mail.gmail.com>
References: <1393323673-2751-1-git-send-email-geert@linux-m68k.org> <1462634.UcxrmdxVtK@avalon> <CAMuHMdU6R_Wubsx2KCAXVBynzqquJekDNDZ-Sq1sKYEOM1RtTw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

On Thursday 27 February 2014 12:09:52 Geert Uytterhoeven wrote:
> On Thu, Feb 27, 2014 at 11:41 AM, Laurent Pinchart wrote:
> >> >> -- compatible           : "renesas,sh-msiof" for SuperH, or
> >> >> +- compatible           : "renesas,msiof-<soctype>" for SoCs,
> >> >> +                      "renesas,sh-msiof" for SuperH, or
> >> >>                        "renesas,sh-mobile-msiof" for SH Mobile series.
> >> >> +                      Examples with soctypes are:
> >> >> +                      "renesas,msiof-sh7724" (SH)
> >> > 
> >> > Given that the driver doesn't handle the "renesas,msiof-sh7724"
> >> > compatible string this might not be a good example. Furthermore SuperH
> >> > doesn't have DT support. I would thus drop the "renesas,sh-msiof"
> >> > compatible string from patch 1/6 and wouldn't mention sh7724 here. I
> >> > very much doubt that someone would have developed DT support for SuperH
> >> > on the side and shipped products that would be broken by this change
> >> > :-)
> >> 
> >> Upon reading your comment again: do you suggest to also remove the plain
> >> "renesas,sh-msiof"? That one was present before, since DT support was
> >> added to the driver in
> >> 
> >> commit cf9c86efecf9510e62388fd174cf607671c59fa3
> >> Author: Bastian Hecht <hechtb@gmail.com>
> >> Date:   Wed Dec 12 12:54:48 2012 +0100
> >> 
> >>     spi/sh-msiof: Add device tree parsing to driver
> >>     
> >>     This adds the capability to retrieve setup data from the device tree
> >>     node. The usage of platform data is still available.
> >>     
> >>     Signed-off-by: Bastian Hecht <hechtb+renesas@gmail.com>
> >>     Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> >> 
> >> So I prefer not to remove any pre-existing compatible values.
> >> Do you agree?
> > 
> > I'd like to remove it (in a separate patch) if we can. The reason is that
> > keeping the DT ABI both forward- and backward-compatible is pretty painful
> > enough without having to care about compatibility strings that have no
> > user. I'd rather work on adding DT support for SuperH MSIOF later when
> > we'll have a platform we can test it on, instead of trying to guess now
> > what the needs will be, get users later and realize even later on that we
> > made a mistake that we can't fix because those users will have DT
> > binaries in the wild. Every unneeded bit of DT bindings that we keep in
> > the kernel is one potential problem for future binary compatibility.
> 
> I agree about the complexity of keeping the DT ABI forward- and
> backward-compatible.
> 
> However, in this case I don't think it hurts that much to just keep it:
>   - DT compatible values and platform device names are kept in sync
>     through a pointer to the same struct sh_msiof_chipdata, so there's
>     not much maintenance needed.
>   - DT compatible "renesas,sh-msiof" means exactly the same as
>     the "spi_sh_msiof" platform device name, which is currently in use.
> 
> So even if SuperH never moves to DT, we have to keep support for that
> specific MSIOF implementation, unless we drop the platform device version,
> too (Hmm, maybe that's what you're alluding to ;-)

Of course, I'm not trying to get support for SuperH dropped, I'm sure someone 
would realize and complain before the end of the century ;-)

> And if we remove "renesas,sh-msiof", we should probably remove
> "renesas,sh-mobile-msiof", too, as there are no current users, and it also
> assumes the same MSIOF implementation?

I'm not too familiar with the MSIOF hardware, can "renesas,sh-mobile-msiof" be 
used as a fallback for the currently support ARM SoCs ?

> Bastian: What was your real plan with "renesas,sh-msiof" and
> "renesas,sh-mobile-msiof"?

-- 
Regards,

Laurent Pinchart

