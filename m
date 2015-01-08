Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306AbbAHPpR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 10:45:17 -0500
Received: from smtpauth13.mfg.siteprotect.com ([64.26.60.145]:48935 "EHLO
	smtpauth03.mfg.siteprotect.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753877AbbAHPpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 10:45:15 -0500
Date: Thu, 8 Jan 2015 10:44:53 -0500 (EST)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Catalin Marinas <catalin.marinas@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Pavel Machek <pavel@ucw.cz>, Marc Zyngier <marc.zyngier@arm.com>,
        kernel list <linux-kernel@vger.kernel.org>, vincent.weaver@maine.edu
Subject: Re: [PATCH] Revert 9fc2105aeaaf56b0cf75296a84702d0f9e64437b to fix
 pyaudio (and probably more)
In-Reply-To: <20150108103911.GQ12302@n2100.arm.linux.org.uk>
Message-ID: <alpine.DEB.2.10.1501081044470.26196@pianoman.cluster.toy>
References: <alpine.LFD.2.11.1501041609290.18844@knanqh.ubzr> <20150104212659.GC12302@n2100.arm.linux.org.uk> <alpine.LFD.2.11.1501042343240.18844@knanqh.ubzr> <CAHkRjk6Vg_AR8rFNYzPcnPwfKZqaVuaCoG67CEVPRgp1-bDetA@mail.gmail.com>
 <CA+55aFypmZExpCvD699TQOs1NDK_mT-_rR3UWOdxdzkOKvbdoA@mail.gmail.com> <alpine.LFD.2.11.1501071354130.1322@knanqh.ubzr> <CA+55aFw70ZvHKH+8_aS7E7FZZuuWQA++zGQuSmuvDE3DWU+x3A@mail.gmail.com> <alpine.LFD.2.11.1501071446460.1322@knanqh.ubzr>
 <20150107205346.GO12302@n2100.arm.linux.org.uk> <CAHkRjk6FT+WJ3u9qhfB-EMcqhOHGQSe4dW4MpZF6vE97B0vD0A@mail.gmail.com> <20150108103911.GQ12302@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-CTCH-Spam: Unknown
X-CTCH-RefID: str=0001.0A020205.54AEA612.0375,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Jan 2015, Russell King - ARM Linux wrote:

> It's not a regression - yet.  No one has shown that userspace has broken
> according to the definition of the first quote above, and that's the
> whole point.

How much does one have to regress before it is a problem?  I have two 
projects I've worked on that "broke" due to this issue.  

They were minor breakages though.

The "linux_logo" userspace sysinfo tool broke to the extent that it 
was parsing for the bogomips string in /proc/cpuinfo and printed poorly 
formatted and/or corrupted text info to screen when it couldn't find it.

The "PAPI" library had some really ancient (and poorly 
thought-out) fallback code that would try to estimate MHz from bogomips 
if a MHz value was not available via the traditional methods.  This
failed after the change too, but not many people use PAPI on ARM so it 
wasn't that big an issue.

I noticed these problems early, even before the change hit mainline.
But when I complained I was told in no uncertain terms that the ARM
maintainers were tired of hearing about bogomips issues and nothing
could be done to stop the change from getting in.

Vince
