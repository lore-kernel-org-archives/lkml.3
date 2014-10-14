Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709AbaJNXg1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 19:36:27 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:34428 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753707AbaJNXg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 19:36:26 -0400
Date: Wed, 15 Oct 2014 00:36:04 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Cc: Doug Anderson <dianders@chromium.org>,
        Kever Yang <kever.yang@rock-chips.com>,
        Sonny Rao <sonnyrao@chromium.org>, Addy Ke <addy.ke@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, Jianqun Xu <xjq@rock-chips.com>,
        han jiang <hj@rock-chips.com>, Tao Huang <huangtao@rock-chips.com>,
        linux-rockchip@lists.infradead.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 4/6] ARM: rockchip: add basic smp support for rk3288
Message-ID: <20141014233604.GG27405@n2100.arm.linux.org.uk>
References: <1413231122-1770-1-git-send-email-kever.yang@rock-chips.com>
 <1413231122-1770-5-git-send-email-kever.yang@rock-chips.com>
 <CAD=FV=WGnE3fBfzLGN_x8dFqq4RV=OnVAyUgRQheMiyG4U7TkQ@mail.gmail.com>
 <1453932.GC4UXrUPRz@phil>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1453932.GC4UXrUPRz@phil>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2014 at 11:23:40PM +0200, Heiko Stübner wrote:
> Am Dienstag, 14. Oktober 2014, 13:24:03 schrieb Doug Anderson:
> > Kever,
> > 
> > On Mon, Oct 13, 2014 at 1:12 PM, Kever Yang <kever.yang@rock-chips.com> 
> wrote:
> > > +       /*
> > > +        * We need to soft reset the cpu when we turn off the cpu power
> > > domain, +        * or else the active processors might be stalled when
> > > the individual +        * processor is powered down.
> > > +        */
> > > +       if (read_cpuid_part_number() != ARM_CPU_PART_CORTEX_A9) {
> > 
> > I haven't done a full review of this patch, but it seems unlikely that
> > your uses of read_cpuid_part_number() and read_cpuid_part() in this
> > patch are correct.  You use both functions and in both cases compare
> > the results to ARM_CPU_PART_CORTEX_A9.
> 
> I think read_cpuid_part() would be the correct one, as it does
> 
> 	read_cpuid_id() & ARM_CPU_PART_MASK
> 
> which in turn should mask the correct parts of the cpuid to match against 
> ARM_CPU_PART_CORTEX_A9 [0].

The clue is the deprecated message.  Clearly the original author did not
even build test their code, or if they did, they ignored the warnings.
Either way, that's a fairly worrying issue which raises the question:
how well was this code tested in the first place?

Note that the above quoted if() evaluates to always-false.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
