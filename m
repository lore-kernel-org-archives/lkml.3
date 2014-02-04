Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845AbaBDRPK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 12:15:10 -0500
Received: from order.stressinduktion.org ([87.106.68.36]:57728 "EHLO
	order.stressinduktion.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828AbaBDRPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 12:15:07 -0500
Date: Tue, 4 Feb 2014 18:15:05 +0100
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: Stephan Mueller <smueller@chronox.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, "Theodore Ts'o" <tytso@mit.edu>,
        =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        "Maciej W. Rozycki" <macro@linux-mips.org>,
        Ralf Baechle <ralf@linux-mips.org>, dave.taht@gmail.com,
        John Crispin <blogic@openwrt.org>, andrewmcgr@gmail.com,
        Thorsten Glaser <tg@mirbsd.de>, sandyinchina@gmail.com
Subject: Re: [PATCH 2/5] CPU Jitter RNG: Enable compilation
Message-ID: <20140204171505.GC13928@order.stressinduktion.org>
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
References: <2039634.jSmQAS6tdi@myon.chronox.de> <3579180.ti4z33qfDe@tauon> <20140204163957.GA13928@order.stressinduktion.org> <4270486.pLbfl66a7r@tauon>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4270486.pLbfl66a7r@tauon>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Tue, Feb 04, 2014 at 05:53:39PM +0100, Stephan Mueller wrote:
> Am Dienstag, 4. Februar 2014, 17:39:57 schrieb Hannes Frederic Sowa:
> >On Tue, Feb 04, 2014 at 05:19:52PM +0100, Stephan Mueller wrote:
> >> Also, I consider the execution speed of the entropy collection is not
> >> really an issue because the RNG delivers random numbers at a
> >> comparatively high rate. Any other noise source feeding into random.c
> >> delivers data with far less speed.
> >
> >Compiling the kernel with -O0 could add some other problems, like
> 
> I thought with the given flag, I only compile the respective C file 
> without optimizations, but not the entire kernel. Am I wrong here?

That's correct.

But your file is pretty long and now someone tries to use a static inline
function from one of the included headers which itself does some tests with
compiletime_assert. In some cases compiletime_assert does generate a call to
an external function which does not exist in the kernel but will be folded away
if the compiler can check that the condition in the assert is always true. It
is expected that the linking process fails in case the assert could not be
shown valid.

So in case you add -O0 and you eliminate some optimizations the compiler may
not eliminate those calls to the undefined functions and thus you could always
get a linking error.

If you need to compile something with -O0 try to just put the non-optimizing
code into a seperate file and try to eliminate as much dependencies and
headers as possible.

> >e.g. not doing enough constant folding which could result in linking
> >errors. I guess it is not a problem currently though, but some of the
> >compile time checks depend on this (compiletime_assert and such).
> 
> How do you think that my folding code can cause linking errors?


I thought about the compiler not doing enough constant folding not
you. ;) The kernel is known to not always compile with optimization
levels below -O2.

Greetings,

  Hannes
