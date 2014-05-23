Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751520AbaEWSjK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 14:39:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43831 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbaEWSjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 14:39:08 -0400
Date: Fri, 23 May 2014 20:03:00 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        dri-devel@lists.freedesktop.org, Daniel Vetter <daniel@ffwll.ch>,
        Rob Clark <robdclark@gmail.com>,
        David Herrmann <dh.herrmann@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/7] drm/tegra: Convert to master/component framework
Message-ID: <20140523110300.GA24374@kroah.com>
References: <1399995050-28435-1-git-send-email-thierry.reding@gmail.com>
 <20140522095621.GA11613@ulmo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140522095621.GA11613@ulmo>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2014 at 11:56:23AM +0200, Thierry Reding wrote:
> On Tue, May 13, 2014 at 05:30:43PM +0200, Thierry Reding wrote:
> > From: Thierry Reding <treding@nvidia.com>
> > 
> > Hi,
> > 
> > This series converts the Tegra DRM driver to the master/component
> > framework. The length of the series and the list of people in Cc is
> > mostly due to the fact that Tegra has some special requirements as
> > opposed to other drivers and therefore requires some changes outside
> > of DRM.
> > 
> > Patch 1 introduces a helper function that can be used by new DRM drivers
> > that don't rely on legacy userspace ABIs. It allows them to register DRM
> > devices much more easily and without much of the midlayer that currently
> > exists in the DRM subsystem.
> > 
> > Patches 2 and 3 make some changes to the master/component framework
> > which are necessary to convert Tegra DRM to use it. All current users of
> > the API have been converted as part of this patch. Note that at the same
> > time the drivers are converted to no longer use drm_platform_init() in
> > favour of the drm_set_unique() from patch 1 in conjunction with
> > drm_dev_alloc() and drm_dev_register(). I would've liked to avoid such
> > invasive changes in a single patch, but unfortunately I couldn't think
> > of a way how to do that. I'm open to suggestions.
> > 
> > Patch 4 adds a new interface framework that supplements the master/
> > component framework and can be used in situations where there is no
> > struct device * that a driver can bind to.
> > 
> > The Tegra DRM driver is converted to using the master/component
> > framework in patch 5 using the above four patches.
> > 
> > Finally patches 6 and 7 add some documentation about the new way of
> > registering DRM devices that don't need legacy support.
> > 
> > Each patch has a somewhat more elaborate description of why it is needed
> > or what problem it solves. The patchset applies on top of linux-next.
> > 
> > I welcome any questions or comments you might have.
> > 
> > Thierry
> > 
> > Thierry Reding (7):
> >   drm: Introduce drm_set_unique()
> >   drivers/base: Allow driver-data to be attached to a master
> >   drivers/base: Allow multiple masters per device
> >   drivers/base: Add interface framework
> >   drm/tegra: Convert to master/component framework
> >   drm: Add device registration documentation
> >   drm: Document how to register devices without struct drm_bus
> 
> Greg, Russell,
> 
> Any comments on this? I've been blocking a bunch of patches in the hopes
> of getting this merged since it allows the Tegra DRM driver to be
> cleaned up a great deal, but if nobody's going to look at or comment on
> this I'll abandon this series and keep using the custom solution we've
> had for a while now.

I'd like Russell to comment on this, as he just added some driver core
work to do drm device work that seems to me to be much the same here.

There's also the work that the media developers are working on to handle
power management issues that seem to also be hitting the same area.  Due
to all of that, I really don't want to add yet-another-driver-core
addition for just one drm driver, all of them should be able to use it.

thanks,

greg k-h
