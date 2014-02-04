Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557AbaBDQug (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 11:50:36 -0500
Received: from order.stressinduktion.org ([87.106.68.36]:57625 "EHLO
	order.stressinduktion.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357AbaBDQue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 11:50:34 -0500
Date: Tue, 4 Feb 2014 17:50:33 +0100
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: Stephan Mueller <smueller@chronox.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        "Maciej W. Rozycki" <macro@linux-mips.org>,
        Ralf Baechle <ralf@linux-mips.org>, dave.taht@gmail.com,
        John Crispin <blogic@openwrt.org>, andrewmcgr@gmail.com,
        Thorsten Glaser <tg@mirbsd.de>, sandyinchina@gmail.com
Subject: Re: [PATCH 2/5] CPU Jitter RNG: Enable compilation
Message-ID: <20140204165033.GB13928@order.stressinduktion.org>
Mail-Followup-To: Stephan Mueller <smueller@chronox.de>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Theodore Ts'o <tytso@mit.edu>,
	=?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	"Maciej W. Rozycki" <macro@linux-mips.org>,
	Ralf Baechle <ralf@linux-mips.org>, dave.taht@gmail.com,
	John Crispin <blogic@openwrt.org>, andrewmcgr@gmail.com,
	Thorsten Glaser <tg@mirbsd.de>, sandyinchina@gmail.com
References: <2039634.jSmQAS6tdi@myon.chronox.de> <3180926.X9oRPa7ARL@myon.chronox.de> <CAMuHMdUpgifUHOYbYLDiLfDdTQ74PBUjjEJWGopg3BwD+qWR6g@mail.gmail.com> <3579180.ti4z33qfDe@tauon> <20140204163957.GA13928@order.stressinduktion.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140204163957.GA13928@order.stressinduktion.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 04, 2014 at 05:39:57PM +0100, Hannes Frederic Sowa wrote:
> On Tue, Feb 04, 2014 at 05:19:52PM +0100, Stephan Mueller wrote:
> > Also, I consider the execution speed of the entropy collection is not 
> > really an issue because the RNG delivers random numbers at a 
> > comparatively high rate. Any other noise source feeding into random.c 
> > delivers data with far less speed.
> 
> Compiling the kernel with -O0 could add some other problems, like
> e.g. not doing enough constant folding which could result in linking
> errors. I guess it is not a problem currently though, but some of the
> compile time checks depend on this (compiletime_assert and such).
> 
> Have you looked into adding compiler barriers into relevant places in the
> loops to stop the compiler from optimizing and spill out the values from the
> registers to their memory locations?

Quick follow-up:

Maybe you can get some ideas how to stop the compiler from optimizing code
from commit fe8c8a126806fe ("crypto: more robust crypto_memneq"). Maybe also
volatile could be helpful and OPTIMIZER_HIDE_VAR seems to be a good candidate
to use here, too.

Greetings,

  Hannes

