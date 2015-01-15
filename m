Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740AbbAOKrM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 05:47:12 -0500
Received: from smtp.citrix.com ([66.165.176.89]:60952 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751683AbbAOKrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 05:47:10 -0500
X-IronPort-AV: E=Sophos;i="5.09,402,1418083200"; 
   d="scan'208";a="216448437"
Date: Thu, 15 Jan 2015 10:47:01 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
CC: <hpa@zytor.com>, <josh@joshtriplett.org>, <sam@ravnborg.org>,
        <stefano.stabellini@eu.citrix.com>, <bpoirier@suse.de>,
        <x86@kernel.org>, <kvm@vger.kernel.org>,
        <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>,
        <julien.grall@linaro.org>, <rientjes@google.com>, <mcgrof@suse.com>,
        Borislav Petkov <bp@suse.de>, Pekka Enberg <penberg@kernel.org>,
        Michal Marek <mmarek@suse.cz>, Randy Dunlap <rdunlap@infradead.org>,
        <levinsasha928@gmail.com>, <mtosatti@redhat.com>,
        <fengguang.wu@intel.com>, David Vrabel <david.vrabel@citrix.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH v3 2/2] x86, arm, platform, xen, kconfig: add xen defconfig
 helper
In-Reply-To: <1421264027-10706-3-git-send-email-mcgrof@do-not-panic.com>
Message-ID: <alpine.DEB.2.02.1501151046370.28492@kaball.uk.xensource.com>
References: <1421264027-10706-1-git-send-email-mcgrof@do-not-panic.com> <1421264027-10706-3-git-send-email-mcgrof@do-not-panic.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jan 2015, Luis R. Rodriguez wrote:
> From: "Luis R. Rodriguez" <mcgrof@suse.com>
> 
> This lets you build a kernel which can support xen dom0
> or xen guests by just using:
> 
>    make xenconfig
> 
> on both x86 and arm64 kernels. This also splits out the
> options which are available currently to be built with x86
> and 'make ARCH=arm64' under a shared config.
> 
> Technically xen supports a dom0 kernel and also a guest
> kernel configuration but upon review with the xen team
> since we don't have many dom0 options its best to just
> combine these two into one.
> 
> Cc: Josh Triplett <josh@joshtriplett.org>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Pekka Enberg <penberg@kernel.org>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Michal Marek <mmarek@suse.cz>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Cc: penberg@kernel.org
> Cc: levinsasha928@gmail.com
> Cc: mtosatti@redhat.com
> Cc: fengguang.wu@intel.com
> Cc: David Vrabel <david.vrabel@citrix.com>
> Cc: Ian Campbell <Ian.Campbell@citrix.com>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: xen-devel@lists.xenproject.org
> Acked-by: Julien Grall <julien.grall@linaro.org>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>

Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>


>  arch/x86/configs/xen.config | 10 ++++++++++
>  kernel/configs/xen.config   | 26 ++++++++++++++++++++++++++
>  scripts/kconfig/Makefile    |  5 +++++
>  3 files changed, 41 insertions(+)
>  create mode 100644 arch/x86/configs/xen.config
>  create mode 100644 kernel/configs/xen.config
> 
> diff --git a/arch/x86/configs/xen.config b/arch/x86/configs/xen.config
> new file mode 100644
> index 0000000..fa7d214
> --- /dev/null
> +++ b/arch/x86/configs/xen.config
> @@ -0,0 +1,10 @@
> +# x86 xen specific config options
> +CONFIG_XEN_PVHVM=y
> +CONFIG_XEN_MAX_DOMAIN_MEMORY=500
> +CONFIG_XEN_SAVE_RESTORE=y
> +# CONFIG_XEN_DEBUG_FS is not set
> +CONFIG_XEN_PVH=y
> +CONFIG_XEN_MCE_LOG=y
> +CONFIG_PCI_XEN=y
> +CONFIG_XEN_PCIDEV_FRONTEND=m
> +CONFIG_XEN_ACPI_PROCESSOR=m
> diff --git a/kernel/configs/xen.config b/kernel/configs/xen.config
> new file mode 100644
> index 0000000..476fcf0
> --- /dev/null
> +++ b/kernel/configs/xen.config
> @@ -0,0 +1,26 @@
> +# generic config
> +CONFIG_XEN=y
> +CONFIG_XEN_DOM0=y
> +CONFIG_XEN_BLKDEV_FRONTEND=m
> +CONFIG_XEN_BLKDEV_BACKEND=m
> +CONFIG_XEN_NETDEV_FRONTEND=m
> +CONFIG_XEN_NETDEV_BACKEND=m
> +CONFIG_INPUT_XEN_KBDDEV_FRONTEND=y
> +CONFIG_HVC_XEN=y
> +CONFIG_HVC_XEN_FRONTEND=y
> +CONFIG_XEN_WDT=m
> +CONFIG_XEN_FBDEV_FRONTEND=y
> +CONFIG_XEN_BALLOON=y
> +CONFIG_XEN_BALLOON_MEMORY_HOTPLUG=y
> +CONFIG_XEN_SCRUB_PAGES=y
> +CONFIG_XEN_DEV_EVTCHN=m
> +CONFIG_XEN_BACKEND=y
> +CONFIG_XENFS=m
> +CONFIG_XEN_COMPAT_XENFS=y
> +CONFIG_XEN_SYS_HYPERVISOR=y
> +CONFIG_XEN_XENBUS_FRONTEND=y
> +CONFIG_XEN_GNTDEV=m
> +CONFIG_XEN_GRANT_DEV_ALLOC=m
> +CONFIG_SWIOTLB_XEN=y
> +CONFIG_XEN_PCIDEV_BACKEND=m
> +CONFIG_XEN_PRIVCMD=m
> diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
> index ff612b0..f4a8f89 100644
> --- a/scripts/kconfig/Makefile
> +++ b/scripts/kconfig/Makefile
> @@ -117,6 +117,10 @@ PHONY += kvmconfig
>  kvmconfig:
>  	$(call mergeconfig,kvm_guest)
>  
> +PHONY += xenconfig
> +xenconfig:
> +	$(call mergeconfig,xen)
> +
>  PHONY += tinyconfig
>  tinyconfig: allnoconfig
>  	$(call mergeconfig,tiny)
> @@ -142,6 +146,7 @@ help:
>  	@echo  '  listnewconfig   - List new options'
>  	@echo  '  olddefconfig	  - Same as silentoldconfig but sets new symbols to their default value'
>  	@echo  '  kvmconfig	  - Enable additional options for kvm guest kernel support'
> +	@echo  '  xenconfig       - Enable additional options for xen dom0 and guest kernel support'
>  	@echo  '  tinyconfig	  - Configure the tiniest possible kernel'
>  
>  # lxdialog stuff
> -- 
> 2.1.1
> 
