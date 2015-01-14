Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227AbbANL3u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 06:29:50 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:3677 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751211AbbANL3t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 06:29:49 -0500
X-IronPort-AV: E=Sophos;i="5.07,755,1413244800"; 
   d="scan'208";a="216613663"
Date: Wed, 14 Jan 2015 11:29:41 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: "Luis R. Rodriguez" <mcgrof@suse.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, <hpa@zytor.com>,
        <josh@joshtriplett.org>, <sam@ravnborg.org>,
        Michal Marek <mmarek@suse.cz>, Randy Dunlap <rdunlap@infradead.org>,
        Ian Campbell <Ian.Campbell@citrix.com>, <kvm@vger.kernel.org>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <mtosatti@redhat.com>, Pekka Enberg <penberg@kernel.org>,
        <fengguang.wu@intel.com>, <levinsasha928@gmail.com>,
        David Rientjes <rientjes@google.com>, <xen-devel@lists.xenproject.org>,
        Borislav Petkov <bp@suse.de>, David Vrabel <david.vrabel@citrix.com>,
        <bpoirier@suse.de>
Subject: Re: [Xen-devel] [PATCH v2 2/2] x86, arm, platform, xen, kconfig:
 add xen defconfig helper
In-Reply-To: <20150113192617.GC27566@wotan.suse.de>
Message-ID: <alpine.DEB.2.02.1501141119340.28492@kaball.uk.xensource.com>
References: <1418168138-6425-1-git-send-email-mcgrof@do-not-panic.com> <1418168138-6425-3-git-send-email-mcgrof@do-not-panic.com> <alpine.DEB.2.02.1412151441360.30971@kaball.uk.xensource.com> <20150113192617.GC27566@wotan.suse.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jan 2015, Luis R. Rodriguez wrote:
> On Mon, Dec 15, 2014 at 02:58:26PM +0000, Stefano Stabellini wrote:
> > On Tue, 9 Dec 2014, Luis R. Rodriguez wrote:
> > > From: "Luis R. Rodriguez" <mcgrof@suse.com>
> > > 
> > > This lets you build a kernel which can support xen dom0
> > > or xen guests by just using:
> > > 
> > >    make xenconfig
> > > 
> > > on both x86 and arm64 kernels. This also splits out the
> > > options which are available currently to be built with x86
> > > and 'make ARCH=arm64' under a shared config.
> > > 
> > > Technically xen supports a dom0 kernel and also a guest
> > > kernel configuration but upon review with the xen team
> > > since we don't have many dom0 options its best to just
> > > combine these two into one.
> > > 
> > > Cc: Josh Triplett <josh@joshtriplett.org>
> > > Cc: Borislav Petkov <bp@suse.de>
> > > Cc: Pekka Enberg <penberg@kernel.org>
> > > Cc: David Rientjes <rientjes@google.com>
> > > Cc: Michal Marek <mmarek@suse.cz>
> > > Cc: Randy Dunlap <rdunlap@infradead.org>
> > > Cc: penberg@kernel.org
> > > Cc: levinsasha928@gmail.com
> > > Cc: mtosatti@redhat.com
> > > Cc: fengguang.wu@intel.com
> > > Cc: David Vrabel <david.vrabel@citrix.com>
> > > Cc: Ian Campbell <Ian.Campbell@citrix.com>
> > > Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > > Cc: xen-devel@lists.xenproject.org
> > > Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> > > Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
> > > ---
> > >  arch/x86/configs/xen.config |  7 +++++++
> > >  kernel/configs/xen.config   | 30 ++++++++++++++++++++++++++++++
> > >  scripts/kconfig/Makefile    |  5 +++++
> > >  3 files changed, 42 insertions(+)
> > >  create mode 100644 arch/x86/configs/xen.config
> > >  create mode 100644 kernel/configs/xen.config
> > > 
> > > diff --git a/arch/x86/configs/xen.config b/arch/x86/configs/xen.config
> > > new file mode 100644
> > > index 0000000..92b8587f
> > > --- /dev/null
> > > +++ b/arch/x86/configs/xen.config
> > > @@ -0,0 +1,7 @@
> > > +# x86 xen specific config options
> > > +CONFIG_XEN_PVHVM=y
> > > +CONFIG_XEN_MAX_DOMAIN_MEMORY=500
> > > +CONFIG_XEN_SAVE_RESTORE=y
> > > +# CONFIG_XEN_DEBUG_FS is not set
> > > +CONFIG_XEN_PVH=y
> > > +CONFIG_XEN_MCE_LOG=y
> > > diff --git a/kernel/configs/xen.config b/kernel/configs/xen.config
> > > new file mode 100644
> > > index 0000000..d2ec010
> > > --- /dev/null
> > > +++ b/kernel/configs/xen.config
> > > @@ -0,0 +1,30 @@
> > > +# generic config
> > > +CONFIG_XEN=y
> > > +CONFIG_XEN_DOM0=y
> > > +CONFIG_PCI_XEN=y
> > 
> > This shouldn't be here
> 
> If PCI is not supported on the arch this won't be selected as kconfig would not
> allow for it, what would be the issue of keeping it here?

It looks wrong to me to have an arch specific option here. Moreover many
ARM boards don't even have PCI, so it looks even worse.
CONFIG_PCI_XEN is certainly not a generic config option for Xen.


> What xen instances
> would we not want to have this enabled for and can we instead manage that
> through Kconfig magic by negating PCI_XEN for it?

Everything can be fixed via Kconfig magic, the point of this exercise is
to try to avoid it.

Are there any cases on x86 where you don't actually want CONFIG_PCI_XEN?
If not, then why don't just enable it automatically and silently if
CONFIG_PCI is selected? If we did that, we could avoid specifying it
here.

In any case, given that CONFIG_PCI_XEN is only defined on x86, I think
it should be in arch/x86/configs/xen.config.
