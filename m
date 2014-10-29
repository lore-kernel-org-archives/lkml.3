Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757509AbaJ2Vei (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 17:34:38 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:29124 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756291AbaJ2Veg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 17:34:36 -0400
Date: Wed, 29 Oct 2014 21:34:31 +0000
From: James Hogan <james.hogan@imgtec.com>
To: Andrew Bresticker <abrestic@chromium.org>
CC: Ralf Baechle <ralf@linux-mips.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        John Crispin <blogic@openwrt.org>, David Daney <ddaney.cavm@gmail.com>,
        Qais Yousef <qais.yousef@imgtec.com>,
        Linux-MIPS <linux-mips@linux-mips.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul <Paul.Burton@imgtec.com>
Subject: Re: [PATCH V3 2/4] of: Add binding document for MIPS GIC
Message-ID: <20141029213431.GF30260@jhogan-linux.le.imgtec.org>
References: <1414541562-10076-1-git-send-email-abrestic@chromium.org>
 <1414541562-10076-3-git-send-email-abrestic@chromium.org>
 <5450B1B1.5070301@imgtec.com>
 <CAL1qeaFeoKFbea7eiiXaw87PYUWO1JmP5xxdLLpW2RrFCprtZg@mail.gmail.com>
 <5451201C.9090106@imgtec.com>
 <CAL1qeaEOifj-R2vcWzzh2i5S3ogBf3eZ4X8PbVa1j_BtsgFCwA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <CAL1qeaEOifj-R2vcWzzh2i5S3ogBf3eZ4X8PbVa1j_BtsgFCwA@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-Originating-IP: [192.168.154.101]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Wed, Oct 29, 2014 at 10:25:27AM -0700, Andrew Bresticker wrote:
> On Wed, Oct 29, 2014 at 10:13 AM, James Hogan <james.hogan@imgtec.com> wrote:
> > On 29/10/14 16:55, Andrew Bresticker wrote:
> >> On Wed, Oct 29, 2014 at 2:21 AM, James Hogan <james.hogan@imgtec.com> wrote:
> >>> Please lets not do this unless it's actually necessary (which AFAICT it
> >>> really isn't).
> >>
> >> The point of this was to future-proof these bindings and I though that
> >> CPU type was the best way to indicate version in the compatible
> >> string.  This is also how it's done for the ARM GIC and arch timers.
> >> Perhaps the best thing to do is to require both a core-specific
> >> ("mti,interaptiv-gic") and generic ("mti,gic") compatible string and
> >> just match on the generic one for now until there's a need to use the
> >> core-specific one.  Thoughts?
> >
> > FPGA boards like Malta are something else to consider (when it is
> > eventually converted to DT - Paul on CC knows more than me). You might
> > load an interAptiv, or a proAptiv, or a P5600 bitstream, and the gic
> > setup will be pretty much the same I think, since e.g. the address
> > depends on where it is convenient to put it in the address space of the
> > platform.
> 
> Ah, I didn't realize that the CPU bitstream could be changed
> independently of the GIC.

To clarify, the GIC is still closely bound to the CPU and contained
within the FPGA bitstream. The register interface should I believe
always comply with some version of the GIC architecture specification,
and I don't think anybody wants per-bitstream DT files / kernels, so in
practice the way the GIC is set up for Malta (how interrupt lines are
connected up and where in address space GIC can go) is unlikely to
become incompatible.

Cheers
James
