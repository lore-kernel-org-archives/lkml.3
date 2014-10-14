Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932610AbaJNVYE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 17:24:04 -0400
Received: from gloria.sntech.de ([95.129.55.99]:55576 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932569AbaJNVYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 17:24:00 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Doug Anderson <dianders@chromium.org>
Cc: Kever Yang <kever.yang@rock-chips.com>, Sonny Rao <sonnyrao@chromium.org>,
        Addy Ke <addy.ke@rock-chips.com>, Eddie Cai <cf@rock-chips.com>,
        Jianqun Xu <xjq@rock-chips.com>, han jiang <hj@rock-chips.com>,
        Tao Huang <huangtao@rock-chips.com>,
        linux-rockchip@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 4/6] ARM: rockchip: add basic smp support for rk3288
Date: Tue, 14 Oct 2014 23:23:40 +0200
Message-ID: <1453932.GC4UXrUPRz@phil>
User-Agent: KMail/4.11.5 (Linux/3.13-1-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <CAD=FV=WGnE3fBfzLGN_x8dFqq4RV=OnVAyUgRQheMiyG4U7TkQ@mail.gmail.com>
References: <1413231122-1770-1-git-send-email-kever.yang@rock-chips.com> <1413231122-1770-5-git-send-email-kever.yang@rock-chips.com> <CAD=FV=WGnE3fBfzLGN_x8dFqq4RV=OnVAyUgRQheMiyG4U7TkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 14. Oktober 2014, 13:24:03 schrieb Doug Anderson:
> Kever,
> 
> On Mon, Oct 13, 2014 at 1:12 PM, Kever Yang <kever.yang@rock-chips.com> 
wrote:
> > +       /*
> > +        * We need to soft reset the cpu when we turn off the cpu power
> > domain, +        * or else the active processors might be stalled when
> > the individual +        * processor is powered down.
> > +        */
> > +       if (read_cpuid_part_number() != ARM_CPU_PART_CORTEX_A9) {
> 
> I haven't done a full review of this patch, but it seems unlikely that
> your uses of read_cpuid_part_number() and read_cpuid_part() in this
> patch are correct.  You use both functions and in both cases compare
> the results to ARM_CPU_PART_CORTEX_A9.

I think read_cpuid_part() would be the correct one, as it does

	read_cpuid_id() & ARM_CPU_PART_MASK

which in turn should mask the correct parts of the cpuid to match against 
ARM_CPU_PART_CORTEX_A9 [0].



[0] http://lxr.free-electrons.com/source/arch/arm/include/asm/cputype.h#L77
