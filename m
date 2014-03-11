Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440AbaCKR4J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 13:56:09 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:54533 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866AbaCKR4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 13:56:06 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Mark Brown <broonie@kernel.org>, linux-spi <linux-spi@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH 2/3] spi: sh-msiof: Convert to spi core auto_runtime_pm framework
Date: Tue, 11 Mar 2014 18:57:41 +0100
Message-ID: <25839523.lJE8x4ql34@avalon>
User-Agent: KMail/4.11.5 (Linux/3.10.25-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAMuHMdXEOygh0--niiLcXFgnRNPi_b0EGPKVBg2Q6Ws01YmNjw@mail.gmail.com>
References: <1394531952-3905-1-git-send-email-geert@linux-m68k.org> <2274545.CyQ67zvVqo@avalon> <CAMuHMdXEOygh0--niiLcXFgnRNPi_b0EGPKVBg2Q6Ws01YmNjw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

On Tuesday 11 March 2014 18:44:21 Geert Uytterhoeven wrote:
> On Tue, Mar 11, 2014 at 5:32 PM, Laurent Pinchart wrote:
> > On Tuesday 11 March 2014 17:23:37 Geert Uytterhoeven wrote:
> >> On Tue, Mar 11, 2014 at 4:55 PM, Laurent Pinchart wrote:
> >> > Does this require drivers/sh/pm_runtime.c to be compiled in ?
> >> 
> >> Let's check...
> >> 
> >> My koelsch-legacy kernel has drivers/sh/pm_runtime.c compiled in.
> >> My koelsch-reference kernel hasn't.
> >> 
> >> However, under the -reference kernel many MSTP clocks (incl. MSIOF)
> >> seem to be enabled all the time, while under -legacy they are enabled and
> >> disabled on demand.
> > 
> > Is PM_RUNTIME enabled in both cases ?
> 
> Yes it is.
> 
> > There's something fishy in there that we should try to fix without too
> > further much delay. Ben Dooks has pointed out the problem a couple of
> > months ago, but the discussion on the mailing list just died.
> 
> Indeed. I'll look into it next week, unless someone beats me to it.
> 
> Note that I dropped Ben's patch to include drivers/sh, as I can't boot into
> userspace with it.

The patch also had the issue of not being compatible with multiplatform 
kernels, as it resulted in Renesas-specific code being executed for all 
platforms.

If you can find the old mail thread you can just reply to it (CC'ing me) and 
I'll make sure to refresh my memory and explain my concerns again.

-- 
Regards,

Laurent Pinchart

