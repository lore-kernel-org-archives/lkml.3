Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175AbaCLLYu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 07:24:50 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:59729 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668AbaCLLYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 07:24:47 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Mark Brown <broonie@kernel.org>,
        linux-spi <linux-spi@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: Re: [PATCH 2/3] spi: sh-msiof: Convert to spi core auto_runtime_pm framework
Date: Wed, 12 Mar 2014 12:26:24 +0100
Message-ID: <1972290.yxP8Fj4BuZ@avalon>
User-Agent: KMail/4.11.5 (Linux/3.10.25-gentoo; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CANqRtoRR9Q8Q=ACqhnLBpTavn0K5cD1=dBkjkfZ8kb+H68GuOw@mail.gmail.com>
References: <1394531952-3905-1-git-send-email-geert@linux-m68k.org> <2274545.CyQ67zvVqo@avalon> <CANqRtoRR9Q8Q=ACqhnLBpTavn0K5cD1=dBkjkfZ8kb+H68GuOw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Magnus,

On Wednesday 12 March 2014 10:23:48 Magnus Damm wrote:
> On Wed, Mar 12, 2014 at 1:32 AM, Laurent Pinchart wrote:
> > On Tuesday 11 March 2014 17:23:37 Geert Uytterhoeven wrote:
> >> Hi Laurent,
> >> 
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
> > 
> > There's something fishy in there that we should try to fix without too
> > further much delay. Ben Dooks has pointed out the problem a couple of
> > months ago, but the discussion on the mailing list just died.
> 
> Yes, Runtime PM is not working as expected in the multiplatform case,
> that is true. I propose that we keep Runtime PM disabled in the
> Kconfig for R-Car Gen2 for now to keep things simple.

Isn't it ? I thought it was only broken with regard to clocks, but I might be 
missing something.

> From my side I see it as two separate solutions. The short term fix is
> to temporarily work around drivers that depend on Runtime PM for clock
> control, I propose enabling selected clocks statically using the
> function introduced by this series:
> 
> [PATCH 00/03] ARM: shmobile: Break out and extend clock workaround
> http://www.spinics.net/lists/arm-kernel/msg310278.html
> 
> The long term fix I'm not sure sure about, but I trust Geert to figure
> it out. =)
> 
> Regardless, rushing to fix this "correctly" seems as useful to me as
> dead line driven DT development....

-- 
Regards,

Laurent Pinchart

