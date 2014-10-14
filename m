Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838AbaJNXiK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 19:38:10 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:34435 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755519AbaJNXiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 19:38:08 -0400
Date: Wed, 15 Oct 2014 00:37:56 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Kever Yang <kever.yang@rock-chips.com>
Cc: Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Doug Anderson <dianders@chromium.org>,
        Tao Huang <huangtao@rock-chips.com>, Addy Ke <addy.ke@rock-chips.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-rockchip@lists.infradead.org, Jianqun Xu <xjq@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, han jiang <hj@rock-chips.com>,
        Sonny Rao <sonnyrao@chromium.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4 4/6] ARM: rockchip: add basic smp support for rk3288
Message-ID: <20141014233756.GH27405@n2100.arm.linux.org.uk>
References: <1413231122-1770-1-git-send-email-kever.yang@rock-chips.com>
 <1413231122-1770-5-git-send-email-kever.yang@rock-chips.com>
 <CAD=FV=WGnE3fBfzLGN_x8dFqq4RV=OnVAyUgRQheMiyG4U7TkQ@mail.gmail.com>
 <1453932.GC4UXrUPRz@phil>
 <543D9A8F.3040304@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <543D9A8F.3040304@rock-chips.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2014 at 02:50:07PM -0700, Kever Yang wrote:
> Heiko,
> 
> On 10/14/2014 02:23 PM, Heiko Stübner wrote:
> >Am Dienstag, 14. Oktober 2014, 13:24:03 schrieb Doug Anderson:
> >>Kever,
> >>
> >>On Mon, Oct 13, 2014 at 1:12 PM, Kever Yang <kever.yang@rock-chips.com>
> >wrote:
> >>>+       /*
> >>>+        * We need to soft reset the cpu when we turn off the cpu power
> >>>domain, +        * or else the active processors might be stalled when
> >>>the individual +        * processor is powered down.
> >>>+        */
> >>>+       if (read_cpuid_part_number() != ARM_CPU_PART_CORTEX_A9) {
> >>I haven't done a full review of this patch, but it seems unlikely that
> >>your uses of read_cpuid_part_number() and read_cpuid_part() in this
> >>patch are correct.  You use both functions and in both cases compare
> >>the results to ARM_CPU_PART_CORTEX_A9.
> >I think read_cpuid_part() would be the correct one, as it does
> You are right, read_cpuid_part() is correct one on kernel next,
> I mix up 3.14 kernel and next tree, only read_cpuid_part_number() is
> available
> in 3.14 kernel.
> 
> I will correct it in my next version, any other changes needed for new
> version?

You need to at the _very_ _minimum_ build test your code against a
recent kernel, and preferably test it to make sure that it works as
you intend.

Developing on such an old kernel version, and hoping that the code is
going to be correct for later kernels isn't a nice idea.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
