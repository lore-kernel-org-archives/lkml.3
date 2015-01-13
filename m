Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440AbbAMT0X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 14:26:23 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44863 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753256AbbAMT0U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 14:26:20 -0500
Date: Tue, 13 Jan 2015 20:26:17 +0100
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
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
Message-ID: <20150113192617.GC27566@wotan.suse.de>
References: <1418168138-6425-1-git-send-email-mcgrof@do-not-panic.com> <1418168138-6425-3-git-send-email-mcgrof@do-not-panic.com> <alpine.DEB.2.02.1412151441360.30971@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1412151441360.30971@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2014 at 02:58:26PM +0000, Stefano Stabellini wrote:
> On Tue, 9 Dec 2014, Luis R. Rodriguez wrote:
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
> > 
> > Technically xen supports a dom0 kernel and also a guest
> > kernel configuration but upon review with the xen team
> > since we don't have many dom0 options its best to just
> > combine these two into one.
> > 
> > Cc: Josh Triplett <josh@joshtriplett.org>
> > Cc: Borislav Petkov <bp@suse.de>
> > Cc: Pekka Enberg <penberg@kernel.org>
> > Cc: David Rientjes <rientjes@google.com>
> > Cc: Michal Marek <mmarek@suse.cz>
> > Cc: Randy Dunlap <rdunlap@infradead.org>
> > Cc: penberg@kernel.org
> > Cc: levinsasha928@gmail.com
> > Cc: mtosatti@redhat.com
> > Cc: fengguang.wu@intel.com
> > Cc: David Vrabel <david.vrabel@citrix.com>
> > Cc: Ian Campbell <Ian.Campbell@citrix.com>
> > Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > Cc: xen-devel@lists.xenproject.org
> > Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> > Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
> > ---
> >  arch/x86/configs/xen.config |  7 +++++++
> >  kernel/configs/xen.config   | 30 ++++++++++++++++++++++++++++++
> >  scripts/kconfig/Makefile    |  5 +++++
> >  3 files changed, 42 insertions(+)
> >  create mode 100644 arch/x86/configs/xen.config
> >  create mode 100644 kernel/configs/xen.config
> > 
> > diff --git a/arch/x86/configs/xen.config b/arch/x86/configs/xen.config
> > new file mode 100644
> > index 0000000..92b8587f
> > --- /dev/null
> > +++ b/arch/x86/configs/xen.config
> > @@ -0,0 +1,7 @@
> > +# x86 xen specific config options
> > +CONFIG_XEN_PVHVM=y
> > +CONFIG_XEN_MAX_DOMAIN_MEMORY=500
> > +CONFIG_XEN_SAVE_RESTORE=y
> > +# CONFIG_XEN_DEBUG_FS is not set
> > +CONFIG_XEN_PVH=y
> > +CONFIG_XEN_MCE_LOG=y
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
> 
> This shouldn't be here

If PCI is not supported on the arch this won't be selected as kconfig would not
allow for it, what would be the issue of keeping it here? What xen instances
would we not want to have this enabled for and can we instead manage that
through Kconfig magic by negating PCI_XEN for it?

> > +CONFIG_XEN_PCIDEV_FRONTEND=m
> > +CONFIG_XEN_BLKDEV_FRONTEND=m
> > +CONFIG_XEN_BLKDEV_BACKEND=m
> > +CONFIG_XEN_NETDEV_FRONTEND=m
> > +CONFIG_XEN_NETDEV_BACKEND=m
> > +CONFIG_INPUT_XEN_KBDDEV_FRONTEND=y
> > +CONFIG_HVC_XEN=y
> > +CONFIG_HVC_XEN_FRONTEND=y
> > +CONFIG_TCG_XEN=m
> 
> neither should this

OK!

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
> and this

OK!

  Luis
