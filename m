Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591AbbAMTDw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 14:03:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44044 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752492AbbAMTDv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 14:03:51 -0500
Date: Tue, 13 Jan 2015 20:03:47 +0100
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Julien Grall <julien.grall@linaro.org>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, hpa@zytor.com,
        josh@joshtriplett.org, sam@ravnborg.org, Michal Marek <mmarek@suse.cz>,
        Randy Dunlap <rdunlap@infradead.org>,
        Ian Campbell <Ian.Campbell@citrix.com>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org, mtosatti@redhat.com,
        Pekka Enberg <penberg@kernel.org>, fengguang.wu@intel.com,
        levinsasha928@gmail.com, David Rientjes <rientjes@google.com>,
        xen-devel@lists.xenproject.org, Borislav Petkov <bp@suse.de>,
        David Vrabel <david.vrabel@citrix.com>, bpoirier@suse.de
Subject: Re: [Xen-devel] [PATCH v2 2/2] x86, arm, platform, xen, kconfig:
	add xen defconfig helper
Message-ID: <20150113190346.GB27566@wotan.suse.de>
References: <1418168138-6425-1-git-send-email-mcgrof@do-not-panic.com> <1418168138-6425-3-git-send-email-mcgrof@do-not-panic.com> <548ECCEA.5040500@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <548ECCEA.5040500@linaro.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2014 at 11:58:34AM +0000, Julien Grall wrote:
> Hello Luis,
> 
> On 09/12/14 23:35, Luis R. Rodriguez wrote:
> > From: "Luis R. Rodriguez" <mcgrof@suse.com>
> > 
> > This lets you build a kernel which can support xen dom0
> > or xen guests by just using:
> > 
> >    make xenconfig
> > 
> > on both x86 and arm64 kernels. This also splits out the
> > options which are available currently to be built with x86
> > and 'make ARCH=arm64' under a shared config.
> 
> I guess this is also working for arm (32bits)?

Yeap!

> 
> > diff --git a/kernel/configs/xen.config b/kernel/configs/xen.config
> > new file mode 100644
> > index 0000000..d2ec010
> > --- /dev/null
> > +++ b/kernel/configs/xen.config
> > @@ -0,0 +1,30 @@
> > +# generic config
> > +CONFIG_XEN=y
> > +CONFIG_XEN_DOM0=y
> > +CONFIG_PCI_XEN=y
> > +CONFIG_XEN_PCIDEV_FRONTEND=m
> > +CONFIG_XEN_BLKDEV_FRONTEND=m
> > +CONFIG_XEN_BLKDEV_BACKEND=m
> > +CONFIG_XEN_NETDEV_FRONTEND=m
> > +CONFIG_XEN_NETDEV_BACKEND=m
> > +CONFIG_INPUT_XEN_KBDDEV_FRONTEND=y
> > +CONFIG_HVC_XEN=y
> > +CONFIG_HVC_XEN_FRONTEND=y
> > +CONFIG_TCG_XEN=m
> > +CONFIG_XEN_WDT=m
> > +CONFIG_XEN_FBDEV_FRONTEND=y
> > +CONFIG_XEN_BALLOON=y
> > +CONFIG_XEN_BALLOON_MEMORY_HOTPLUG=y
> > +CONFIG_XEN_SCRUB_PAGES=y
> > +CONFIG_XEN_DEV_EVTCHN=m
> > +CONFIG_XEN_BACKEND=y
> > +CONFIG_XENFS=m
> > +CONFIG_XEN_COMPAT_XENFS=y
> > +CONFIG_XEN_SYS_HYPERVISOR=y
> > +CONFIG_XEN_XENBUS_FRONTEND=y
> > +CONFIG_XEN_GNTDEV=m
> > +CONFIG_XEN_GRANT_DEV_ALLOC=m
> > +CONFIG_SWIOTLB_XEN=y
> > +CONFIG_XEN_PCIDEV_BACKEND=m
> > +CONFIG_XEN_PRIVCMD=m
> > +CONFIG_XEN_ACPI_PROCESSOR=m
> 
> The common fragment config looks good for both ARM32 and ARM64:
> 
> Acked-by: Julien Grall <julien.grall@linaro.org>

Can someone apply this? Who should this go through?

  Luis
