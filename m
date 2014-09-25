Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211AbaIYSKi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 14:10:38 -0400
Received: from cube.luon.net ([37.72.100.20]:57560 "EHLO cube.luon.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753013AbaIYSKg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 14:10:36 -0400
Message-ID: <1411668631.24948.9.camel@luon.net>
Subject: Re: [5/5] ARM: tegra: jetson-tk1: enable GK20A GPU
From: Sjoerd Simons <sjoerd@luon.net>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Ben Skeggs <bskeggs@redhat.com>, nouveau@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, gnurou@gmail.com
Date: Thu, 25 Sep 2014 20:10:31 +0200
In-Reply-To: <20140925164109.GA30382@ulmo>
References: <1400491450-19223-6-git-send-email-acourbot@nvidia.com>
	 <20140925132717.GA13579@dusk.luon.net> <54243931.6050804@wwwdotorg.org>
	 <20140925164109.GA30382@ulmo>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.12.6-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-09-25 at 18:41 +0200, Thierry Reding wrote:
> On Thu, Sep 25, 2014 at 09:48:01AM -0600, Stephen Warren wrote:
> > On 09/25/2014 07:27 AM, Sjoerd Simons wrote:
> > >Playing a bit with todays linux-next on my jetson, it seems this patch is
> > >still required for enabling the GPU. Is there anything blocking it (firmware
> > >not available yet in liux-firmware?)
> > 
> > I think initially I was waiting for the DRM patch "drm/nouvea: support for
> > probing platform devices" to be applied, but it looks like that's been
> > applied already, so only patches 4 and 5 in this series are still
> > outstanding.
> > 
> > Alex, wasn't there also some issue where the VPR register had to be
> > programmed, and if it wasn't there'd be a hang when the GPU registers were
> > touched? If we've added code to Nouveau/tegradrm to detect that and avoid
> > the problem, then I guess we can commit these last two patches for 3.19. A
> > resend after the 3.18 merge window might help.
> 
> A patch that programs VPR was merged into U-Boot (though I don't think
> it's made it into master yet).

Assuming you're talking about "ARM: tegra: Disable VPR",that has landed
in u-boot master and released as part of v2014.10-rc2 [0]

>  I'm not sure we can reasonably check for
> that in Nouveau, given that the register is somewhere completely
> unrelated. In fact I think the U-Boot patch was triggered by some
> discussion about how to solve this and it was decided that it shouldn't
> be done in the kernel, but U-Boot should set it up.
> 
> That said, perhaps one solution would be to make U-Boot enable the gk20a
> device if it's set up the VPR and disable it otherwise?

I guess in that case the vdd-supply should still be added to the dts
with u-boot toggling the status field of the node?


0: http://git.denx.de/?p=u-boot.git;a=commit;h=df3443dfa449ad02bef8ddf6e2c90a6fd9394fc9
-- 
Sjoerd Simons <sjoerd@luon.net>
