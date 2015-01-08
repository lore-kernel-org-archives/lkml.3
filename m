Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133AbbAHQcm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 11:32:42 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:52683 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753998AbbAHQcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 11:32:41 -0500
Date: Thu, 8 Jan 2015 16:32:24 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Vince Weaver <vince@deater.net>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Pavel Machek <pavel@ucw.cz>, Marc Zyngier <marc.zyngier@arm.com>,
        kernel list <linux-kernel@vger.kernel.org>, vincent.weaver@maine.edu
Subject: Re: [PATCH] Revert 9fc2105aeaaf56b0cf75296a84702d0f9e64437b to fix
 pyaudio (and probably more)
Message-ID: <20150108163224.GU12302@n2100.arm.linux.org.uk>
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
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.DEB.2.10.1501081044470.26196@pianoman.cluster.toy>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2015 at 10:44:53AM -0500, Vince Weaver wrote:
> On Thu, 8 Jan 2015, Russell King - ARM Linux wrote:
> 
> > It's not a regression - yet.  No one has shown that userspace has broken
> > according to the definition of the first quote above, and that's the
> > whole point.
> 
> How much does one have to regress before it is a problem?  I have two 
> projects I've worked on that "broke" due to this issue.  

If it's something which worked before and fails after, that's enough.

> They were minor breakages though.
> 
> The "linux_logo" userspace sysinfo tool broke to the extent that it 
> was parsing for the bogomips string in /proc/cpuinfo and printed poorly 
> formatted and/or corrupted text info to screen when it couldn't find it.
> 
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

Sorry about that.

However, I'm having a hard time finding your report.  Do you have a
message id for the report?

For the record, I have no knowledge of this report having been made.

My linux-arm-kernel web archives bring up nothing either.

My mailbox record going back to the start of 2013 (which includes all
linux-arm-kernel mailing list traffic and any traffic to _this_ address,
and covers six months before the commit happened), I only have messages
with these subject lines authored by you:

2013:
Subject: Re: [Ksummit-2013-discuss] [ARM ATTEND] catching up on exploit mitigations
Subject: Re: NSA310 + DT
2014:
Subject: Re: CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS and bcm2835_defconfig
Subject: Re: CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS and bcm2835_defconfig
Subject: Re: CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS and bcm2835_defconfig
Subject: [bisected] broken make-kpkg kernel build in 3.15-rc1
Subject: Re: [bisected] broken make-kpkg kernel build in 3.15-rc1
Subject: Re: [bisected] broken make-kpkg kernel build in 3.15-rc1
Subject: Re: [bisected] broken make-kpkg kernel build in 3.15-rc1
Subject: Re: [bisected] broken make-kpkg kernel build in 3.15-rc1
Subject: Re: [bisected] broken make-kpkg kernel build in 3.15-rc1
Subject: [tip:perf/core] perf/ARM: Use common PMU interrupt disabled code

For the thread where the offending patch was posted in 2013, my mailbox
gives me:

4963     Jun 20 Will Deacon     (  36) [PATCH v2 0/2] ARM: Remove any correlatio
4964     Jun 20 Will Deacon     (  67) ├─>[PATCH v2 1/2] ARM: delay: don't bothe
4965     Jun 20 Will Deacon     (  50) ├─>[PATCH v2 2/2] init: calibrate: don't
4966     Jun 20 Nicolas Pitre   (  27) ├─>Re: [PATCH v2 0/2] ARM: Remove any cor
4967     Jun 21 Will Deacon     (  29) │ └─>
4968     Jun 21 Marc Zyngier    (  27) └─>

Did you copy linux-arm-kernel with your report?

-- 
FTTC broadband for 0.8mile line: currently at 10.5Mbps down 400kbps up
according to speedtest.net.
