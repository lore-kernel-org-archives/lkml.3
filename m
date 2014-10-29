Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573AbaJ2Rqc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 13:46:32 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:59966 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756100AbaJ2Rq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 13:46:27 -0400
Date: Wed, 29 Oct 2014 17:46:12 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Qais Yousef <qais.yousef@imgtec.com>
Cc: Andrew Bresticker <abrestic@chromium.org>,
        Ralf Baechle <ralf@linux-mips.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        John Crispin <blogic@openwrt.org>, David Daney <ddaney.cavm@gmail.com>,
        Linux-MIPS <linux-mips@linux-mips.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3 2/4] of: Add binding document for MIPS GIC
Message-ID: <20141029174611.GB26471@leverpostej>
References: <1414541562-10076-1-git-send-email-abrestic@chromium.org>
 <1414541562-10076-3-git-send-email-abrestic@chromium.org>
 <5450CAF9.3040902@imgtec.com>
 <CAL1qeaHEE43n6V-y6XECicPaoEAfTBpyfg8bYJZK0e-pSMAJjw@mail.gmail.com>
 <545122AF.303@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <545122AF.303@imgtec.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 05:23:59PM +0000, Qais Yousef wrote:
> On 10/29/2014 05:08 PM, Andrew Bresticker wrote:
> > On Wed, Oct 29, 2014 at 4:09 AM, Qais Yousef <qais.yousef@imgtec.com> wrote:
> >> On 10/29/2014 12:12 AM, Andrew Bresticker wrote:
> >>> +- reg : Base address and length of the GIC registers.
> >>>
> >> Also except for sead3, the base address should be properly reported by the
> >> hardware. The size is fixed (for a specific version of GIC at least - which
> >> is also reported by the hardware). So it would be nice to make this
> >> optional.
> > Even though this is usually probable, I'd prefer to leave this as
> > required, or at least "optional, but recommended".  I don't have a
> > very strong opinion on it though, but perhaps the device-tree folks
> > do?

It boils down to how reliable the values you can read out of the HW are.
If it can always be probed reliably, then the property isn't strictly
necessary. However, the fact that you can probe it now doesn't mean you
can always probe it reliably (e.g. a future CPU's reporting mechanism
might be different, or values might be plain wrong). It depends on what
you expect in future in that regard.

As an example, for a while on ARM we thought we could probe the number
of CPUs present from the HW, but new CPUs and multi-cluster designs
broke our assumptions there. Now we just rely on the /cpus node
containing the appropriate cpu sub-nodes (regardless of whether this
could be probed for a particular CPU/SoC). Luckily we were able to
change that as we were still in the early days of DT conversion.

So consider the possible ways your current probing mechanism is
realistically likely to be broken. If there are clear ways of working
around that, you're probably fine with an optional property. If it looks
like things could change substantially, require the property for now --
you can always ignore it in future if things turn out to be reliably
probeable through other means.

> The biggest advantage I can think of is that it can potentially make GIC 
> DT definition more shareable across for instance multiple revisions of 
> an SoC that might have the GIC at different base addresses.

For the different revisions of an SoC, I would expect that if your
interrupt controller moved other elements would also? A layer or two of
dtsi files can keep all the common stuff common while allowing
per-revision changes.

> I won't insist too much though.

Similarly, I don't really have a strong opinion either way. There's no
single answer on this.

Thanks,
Mark.
