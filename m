Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541AbaBSAUr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 19:20:47 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:42223 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbaBSAUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 19:20:45 -0500
Date: Tue, 18 Feb 2014 16:20:43 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: Borislav Petkov <bp@alien8.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        Mark Rutland <Mark.Rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v5 2/4] devicetree: bindings: Document Krait CPU/L1 EDAC
Message-ID: <20140219002043.GE14769@codeaurora.org>
References: <1389735034-21430-1-git-send-email-sboyd@codeaurora.org>
 <1389735034-21430-3-git-send-email-sboyd@codeaurora.org>
 <20140115102701.GA27314@e102568-lin.cambridge.arm.com>
 <20140115165623.GJ14405@codeaurora.org>
 <20140116013840.GA674@codeaurora.org>
 <20140116113332.GC25540@e102568-lin.cambridge.arm.com>
 <20140116180505.GA30925@codeaurora.org>
 <20140116183326.GG25540@e102568-lin.cambridge.arm.com>
 <20140116192617.GA13785@codeaurora.org>
 <20140117102109.GA22544@e102568-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140117102109.GA22544@e102568-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Sorry, this discussion stalled due to merge window + life events)

On 01/17, Lorenzo Pieralisi wrote:
> On Thu, Jan 16, 2014 at 07:26:17PM +0000, Stephen Boyd wrote:
> > On 01/16, Lorenzo Pieralisi wrote:
> > > On Thu, Jan 16, 2014 at 06:05:05PM +0000, Stephen Boyd wrote:
> > > > On 01/16, Lorenzo Pieralisi wrote:
> > > > > Do we really want to do that ? I am not sure. A cpus node is supposed to
> > > > > be a container node, we should not define this binding just because we
> > > > > know the kernel creates a platform device for it then.
> > > > 
> > > > This is just copying more of the ePAPR spec into this document.
> > > > It just so happens that having a compatible field here allows a
> > > > platform device to be created. I don't see why that's a problem.
> > > 
> > > I do not see why you cannot define a node like pmu or arch-timer and stick
> > > a compatible property in there. cpus node does not represent a device, and
> > > must not be created as a platform device, that's my opinion.
> > > 
> > 
> > I had what you're suggesting before in the original revision of
> > this patch. Please take a look at the original patch series[1]. I
> > suppose it could be tweaked slightly to still have a cache node
> > for the L2 interrupt and the next-level-cache pointer from the
> > CPUs.
> 
> Ok, sorry, we are running around in circles here, basically you moved
> the node to cpus according to reviews. I still think that treating cpus
> as a device is not a great idea, even though I am in the same
> position with C-states and probably will add C-state tables in the cpus
> node.
> 
> http://comments.gmane.org/gmane.linux.power-management.general/41012
> 
> I just would like to see under cpus nodes and properties that apply to
> all ARM systems, and avoid defining properties (eg interrupts) that
> have different meanings for different ARM cores.
> 
> The question related to why the kernel should create a platform device
> out of cpus is still open. I really do not want to block your series
> for these simple issues but we have to make a decision and stick to that,
> I am fine either way if we have a plan.
> 

Do you just want a backup plan in case we don't make a platform
device out of the cpus node? I believe we can always add code
somewhere to create a platform device at runtime if we detect the
cpus node has a compatible string equal to "qcom,krait". We could
probably change this driver's module_init() to scan the DT for
such a compatible string and create the platform device right
there. If we get more than one interrupt in the cpus node we can
add interrupt-names and then have software look for interrupts by
name instead of number.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
