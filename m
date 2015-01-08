Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255AbbAHQTZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 11:19:25 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:57962 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249AbbAHQTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 11:19:23 -0500
Date: Thu, 8 Jan 2015 16:19:08 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Vince Weaver <vince@deater.net>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Pavel Machek <pavel@ucw.cz>, Marc Zyngier <Marc.Zyngier@arm.com>,
        kernel list <linux-kernel@vger.kernel.org>,
        "vincent.weaver@maine.edu" <vincent.weaver@maine.edu>
Subject: Re: [PATCH] Revert 9fc2105aeaaf56b0cf75296a84702d0f9e64437b to fix
 pyaudio (and probably more)
Message-ID: <20150108161908.GA17290@e104818-lin.cambridge.arm.com>
References: <alpine.LFD.2.11.1501042343240.18844@knanqh.ubzr>
 <CAHkRjk6Vg_AR8rFNYzPcnPwfKZqaVuaCoG67CEVPRgp1-bDetA@mail.gmail.com>
 <CA+55aFypmZExpCvD699TQOs1NDK_mT-_rR3UWOdxdzkOKvbdoA@mail.gmail.com>
 <alpine.LFD.2.11.1501071354130.1322@knanqh.ubzr>
 <CA+55aFw70ZvHKH+8_aS7E7FZZuuWQA++zGQuSmuvDE3DWU+x3A@mail.gmail.com>
 <alpine.LFD.2.11.1501071446460.1322@knanqh.ubzr>
 <20150107205346.GO12302@n2100.arm.linux.org.uk>
 <CAHkRjk6FT+WJ3u9qhfB-EMcqhOHGQSe4dW4MpZF6vE97B0vD0A@mail.gmail.com>
 <20150108103911.GQ12302@n2100.arm.linux.org.uk>
 <alpine.DEB.2.10.1501081044470.26196@pianoman.cluster.toy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1501081044470.26196@pianoman.cluster.toy>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2015 at 03:44:53PM +0000, Vince Weaver wrote:
> On Thu, 8 Jan 2015, Russell King - ARM Linux wrote:
> 
> > It's not a regression - yet.  No one has shown that userspace has broken
> > according to the definition of the first quote above, and that's the
> > whole point.
> 
> How much does one have to regress before it is a problem?  I have two 
> projects I've worked on that "broke" due to this issue.  

With the revert in place, now you get the bogomips value. Just don't
assume anything about it.

> They were minor breakages though.
> 
> The "linux_logo" userspace sysinfo tool broke to the extent that it 
> was parsing for the bogomips string in /proc/cpuinfo and printed poorly 
> formatted and/or corrupted text info to screen when it couldn't find it.

We now have the bogomips string back, so this problem is solved.

> The "PAPI" library had some really ancient (and poorly 
> thought-out) fallback code that would try to estimate MHz from bogomips 
> if a MHz value was not available via the traditional methods.  This
> failed after the change too, but not many people use PAPI on ARM so it 
> wasn't that big an issue.
> 
> I noticed these problems early, even before the change hit mainline.
> But when I complained I was told in no uncertain terms that the ARM
> maintainers were tired of hearing about bogomips issues and nothing
> could be done to stop the change from getting in.

There were many complaints, from marketing people to some Linux users
who had a "feeling" that their platform just got much slower after the
delay loop change. Since this patch didn't gain much traction:

https://lkml.org/lkml/2013/5/3/405

we decided to remove it completely so that we stop complaints that
bogomips does not match the CPU frequency. Unfortunately, we broke the
ABI.

Now the bogomips is back, but we are going to ignore anyone asking about
its value as it can be either the speed of a busy delay loop or the
generic timer frequency (completely independent; which one depends on
kernel version and SoC).

I really think we should stop this thread. User ABI breakage fixed now.

-- 
Catalin
