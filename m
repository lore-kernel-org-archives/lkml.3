Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934203AbaFRI5f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 04:57:35 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:9041 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933943AbaFRI53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 04:57:29 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 18 Jun 2014 01:51:48 -0700
Date: Wed, 18 Jun 2014 11:57:25 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Thierry Reding <thierry.reding@gmail.com>
CC: Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "David Airlie" <airlied@linux.ie>,
        Mike Turquette <mturquette@linaro.org>,
        "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Subject: Re: [RFC PATCH 1/4] memory: tegra124-emc: Add EMC driver
Message-ID: <20140618085725.GI3407@tbergstrom-lnx.Nvidia.com>
References: <1402925713-25426-1-git-send-email-tomeu.vizoso@collabora.com>
 <1402925713-25426-2-git-send-email-tomeu.vizoso@collabora.com>
 <539F4D44.3070309@wwwdotorg.org> <53A03186.3040703@collabora.com>
 <20140617223518.GA25309@mithrandir>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140617223518.GA25309@mithrandir>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 12:35:27AM +0200, Thierry Reding wrote:
> * PGP Signed by an unknown key
> 
> On Tue, Jun 17, 2014 at 02:16:06PM +0200, Tomeu Vizoso wrote:
> > On 06/16/2014 10:02 PM, Stephen Warren wrote:
> > >On 06/16/2014 07:35 AM, Tomeu Vizoso wrote:
> > >>+
> > >>+Child device nodes describe the memory settings for different configurations and
> > >>+clock rates.
> > >
> > >How do the child nodes do that? The binding needs to specify the format
> > >of the child node.
> > 
> > Sorry, that file was sent before I had finished removing the bits from
> > downstream that aren't needed yet. There's no current need for any child
> > nodes.
> > 
> > >This binding looks quite anaemic vs.
> > >Documentation/devicetree/bindings/arm/tegra/nvidia,tegra20-emc.txt; I
> > >would expect that this binding needs all the EMC register data from the
> > >tegra20-emc binding too. Can the two bindings be identical?
> > 
> > There's even less stuff needed right now, as all what ultimately the EMC
> > driver does is call clk_set_rate on the EMC clock. As the T124 EMC driver
> > gains more features, they should get more similar.
> > 
> > >Can you explain what the nvidia,mc and nvidia,pmc references are needed
> > >for? Hopefully, this driver isn't going to reach into those devices and
> > >touch their registers directly.
> > 
> > Not really needed, see above.
> 
> I've been working on a prototype driver for the memory controller. Part
> of what I've added is programming of the latency allowance registers (it
> doesn't yet expose an API to do so yet, though). I think that needs to
> eventually take into account the EMC frequency (and needs to be notified
> of changes to the same).
> 
> Without having thought this through very thoroughly, I suspect that
> rather than referencing the MC from the EMC it might be better to have
> the MC register with the EMC for notifications.
> 
> But perhaps there are other services from MC that EMC needs to work?
> 

If the emc frequency change is modelled as a clock, you could use CCF
notifications for this?

Cheers,

Peter.
