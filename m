Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595AbaJKSEx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 14:04:53 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:50442 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751639AbaJKSEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 14:04:52 -0400
Message-ID: <5439713F.1050007@hurleysoftware.com>
Date: Sat, 11 Oct 2014 14:04:47 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Mikael Pettersson <mikpelinux@gmail.com>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, Rabin Vincent <rabin@rab.in>
Subject: Re: [PATCH] arm: Blacklist gcc 4.8.[012] and 4.9.0 with CONFIG_FRAME_POINTER
References: <1412958374-16090-1-git-send-email-peter@hurleysoftware.com>	<20141010163613.GO5182@n2100.arm.linux.org.uk>	<54380F86.10005@hurleysoftware.com> <21561.23527.405747.338285@gargle.gargle.HOWL>
In-Reply-To: <21561.23527.405747.338285@gargle.gargle.HOWL>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2014 12:33 PM, Mikael Pettersson wrote:
> Peter Hurley writes:
>  > On 10/10/2014 12:36 PM, Russell King - ARM Linux wrote:
>  > > On Fri, Oct 10, 2014 at 12:26:14PM -0400, Peter Hurley wrote:
>  > >> gcc versions 4.8.[012] and 4.9.0 generates code that prematurely
>  > >> adjusts the stack pointer such that still-to-be-referenced locals
>  > >> are below the stack pointer, which allows them to be overwritten
>  > >> by interrupts.
>  > > 
>  > > I would much rather do this in asm-offsets.c, along side the other ARM
>  > > specific buggy compiler test(s).  I'm presently putting together such
>  > > a patch.
>  > > 
>  > > The information in the thread on linux-omap says only GCC 4.8.1 and
>  > > GCC 4.8.2.  Where do you get the other versions from?
>  > 
>  > The gcc PR linked in the commit message; see the "Known to fail" field.
> 
> The 4.8.0 release is broken, but the 4.9.0 one is not.  It's unfortunate,
> but "4.9.0" may refer to "the 4.9.0 release" or to "some point after trunk
> forked 4.8 branch up to and including the 4.9.0 release point".  In this
> case, it's the latter -- this can be inferred from the fact that the
> fix went into trunk in October 2013 while 4.9.0 was branched and released
> during the first half of 2014.

Is there a reasonably quick way to determine if a particular commit is
in a particular release of gcc?

Starting from the mainline viewcvs revision page for this fix here,
https://gcc.gnu.org/viewcvs/gcc?view=revision&revision=204203
(which is the link from the PR for the fix), navigation to anywhere
else in the gcc tree is impossible. I can't even look at the Changelog.

Same with the backport.

Inferring by date seems error-prone.

Regards,
Peter Hurley


