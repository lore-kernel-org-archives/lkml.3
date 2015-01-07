Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272AbbAGKyr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 05:54:47 -0500
Received: from service87.mimecast.com ([91.220.42.44]:43235 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbbAGKyp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 05:54:45 -0500
Date: Wed, 7 Jan 2015 10:54:38 +0000
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Rob Herring <robherring2@gmail.com>
Cc: Mathieu Poirier <mathieu.poirier@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: vexpress: bindings: Add generic PD awareness to the
 spc controller
Message-ID: <20150107105438.GA7256@e102568-lin.cambridge.arm.com>
References: <1420562732-4353-1-git-send-email-mathieu.poirier@linaro.org>
 <CAL_JsqJwauxNNojhAaYEr7oQTm6fwYwtByv_s6-tHiXYA214AQ@mail.gmail.com>
 <CANLsYkz_tx0MAnssO1JmgGzeaj12oU64FJjiKKyEOyXuUKk8jQ@mail.gmail.com>
 <CAL_JsqLv8Q4eS_bwuLbEOBSxjU7uff4__KcSi3qwAvgmjhQKHw@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAL_JsqLv8Q4eS_bwuLbEOBSxjU7uff4__KcSi3qwAvgmjhQKHw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 07 Jan 2015 10:54:42.0028 (UTC) FILETIME=[571DCAC0:01D02A68]
X-MC-Unique: 115010710544304301
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 10:01:03PM +0000, Rob Herring wrote:
> On Tue, Jan 6, 2015 at 12:36 PM, Mathieu Poirier
> <mathieu.poirier@linaro.org> wrote:
> > On 6 January 2015 at 10:02, Rob Herring <robherring2@gmail.com> wrote:
> >> On Tue, Jan 6, 2015 at 10:45 AM,  <mathieu.poirier@linaro.org> wrote:
> >>> From: Mathieu Poirier <mathieu.poirier@linaro.org>
> >>>
> >>> Among other things, the serial power controller (SPC) controls power to
> >>> the A7 and A15 clusters.  Theses clusters also happen to contains the

"These clusters also happen to contain"

> >>> coresight tracers used for HW assisted tracing.
> >>>
> >>> By modellling these to power domains in a way that is comprehensible to
               ^ too many l

> >>> the generic power domain sub-system and using the runtime PM API in the
> >>> coresight drivers, we can prevent power to the domains from being
> >>> turned off while tracing related operations are still pending.
> >>>
> >>> Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
> >>> ---
> >>>  .../bindings/arm/vexpress-power-controller.txt     | 54 ++++++++++++++++++++++
> >>>  1 file changed, 54 insertions(+)
> >>>  create mode 100644 Documentation/devicetree/bindings/arm/vexpress-power-controller.txt
> >>>
> >>> diff --git a/Documentation/devicetree/bindings/arm/vexpress-power-controller.txt b/Documentation/devicetree/bindings/arm/vexpress-power-controller.txt
> >>> new file mode 100644
> >>> index 000000000000..3af5624dc5cb
> >>> --- /dev/null
> >>> +++ b/Documentation/devicetree/bindings/arm/vexpress-power-controller.txt
> >>> @@ -0,0 +1,54 @@
> >>> +ARM Versatile Express Power Controller
> >>> +--------------------------------------
> >>> +
> >>> +This binding models the serial power controller (SPC) in a way that is
> >>> +intelligible to the generic power domain subsystem and in accordance
> >>> +with the guidelines from:
> >>> +
> >>> +Documentation/devicetree/bindings/power/power_domain.txt
> >>> +
> >>> +The binding doesn't have a '<reg>' property as the base address for HW
> >>> +access is provided by the vexpress-scc sub-system.
> >>> +
> >>> +Required node properties:
> >>> +- compatible value : = "arm,vexpress-power-controller";
> >>> +- #power-domain-cells : = Number of cells in a PM domain specifier, as
> >>> +  specified in "power_domain.txt" referenced above.
> >>> +
> >>> +Example:
> >>> +       A7_A15_cluster_pd: A7-A15-cluster-pd {
> >>
> >> This is more a description of the power domain than the power
> >> controller IP block.
> >
> > This one is a little tricky - the controller itself (SPC) is accessed
> > via registers mapped by another driver (SCC) and have two completely
> > separate files.  The SPC driver itself is not DT'ed, simply because it
> > doesn't have too,  hence writing things the way I did.
> >
> > I will ask the vexpress maintainers where they want to see this code
> > going.  Would you accept this binding as part of the existing
> > "arm,vexpress-sysreg" [1] or even "arm,vexpress-scc" [2]?

We are not CC'ed :). [2] is my answer, see below.

> > [1]. Documentation/devicetree/bindings/arm/vexpress-sysreg.txt
> > [2]. Documentation/devicetree/bindings/arm/vexpress-scc.txt
> 
> Yes, that makes sense. I think either you could have sub node for the
> SPC or just use the sysreg node phandle directly. Given the
> simplicity, I'd probably go for the latter, but I haven't looked
> closely at these drivers and will defer to VExpress maintainers.

There is no such a thing as "vexpress-power-controller", SCC (and SPC)
are testchip specific, adding the bindings to [2] is what I would like to
see, with a compatible string that is testchip specific, please refer
to the bindings for details (ie arm,vexpress-scc,v2p-ca15_a7).

> 
> >
> >>
> >>> +               compatible = "arm,vexpress-power-controller";
> >>> +               #power-domain-cells = <1>;
> >>
> >> You need to define what goes in the cell. That is specific to the
> >> power controller. It could be generic in that N corresponds to power
> >> domain N in the controller if the controller is generic in that way
> >> (i.e. all the register accesses are just indexed).
> >
> > That is exactly how things are - one controller and two power domains.
> > Based on what the generic power domain code does #power-domain-cells
> > is the argument indicating what domain a device should be added to.
> > From what I read this is also how things are (sparsely) explained in
> > "power_domain.txt".  As such I'm not exactly sure of what you'd like
> > to see modified - enlightenment would be appreciated.
> 
> I wasn't sure if there are more domains you didn't add. If what 0 and
> 1 correspond to varies by board, then it's probably fine as it. If
> they are always cluster 0 and cluster 1, then just say that.

It is testchip specific (see above), and it should be documented as
such. You should define what the cell number corresponds to (eg cell == 0 A15
cluster power domain, cell == 1 A7 cluster power domain).

Lorenzo

