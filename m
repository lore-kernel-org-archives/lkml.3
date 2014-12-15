Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750840AbaLOL6o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 06:58:44 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:54443 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbaLOL6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 06:58:41 -0500
Message-ID: <548ECCEA.5040500@linaro.org>
Date: Mon, 15 Dec 2014 11:58:34 +0000
From: Julien Grall <julien.grall@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, hpa@zytor.com,
        josh@joshtriplett.org, sam@ravnborg.org
CC: Michal Marek <mmarek@suse.cz>, Randy Dunlap <rdunlap@infradead.org>,
        Ian Campbell <Ian.Campbell@citrix.com>, kvm@vger.kernel.org,
        "Luis R. Rodriguez" <mcgrof@suse.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, mtosatti@redhat.com,
        Pekka Enberg <penberg@kernel.org>, fengguang.wu@intel.com,
        levinsasha928@gmail.com, David Rientjes <rientjes@google.com>,
        xen-devel@lists.xenproject.org, Borislav Petkov <bp@suse.de>,
        David Vrabel <david.vrabel@citrix.com>, bpoirier@suse.de
Subject: Re: [Xen-devel] [PATCH v2 2/2] x86, arm, platform, xen, kconfig:
 add xen defconfig helper
References: <1418168138-6425-1-git-send-email-mcgrof@do-not-panic.com> <1418168138-6425-3-git-send-email-mcgrof@do-not-panic.com>
In-Reply-To: <1418168138-6425-3-git-send-email-mcgrof@do-not-panic.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Luis,

On 09/12/14 23:35, Luis R. Rodriguez wrote:
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

I guess this is also working for arm (32bits)?

> diff --git a/kernel/configs/xen.config b/kernel/configs/xen.config
> new file mode 100644
> index 0000000..d2ec010
> --- /dev/null
> +++ b/kernel/configs/xen.config
> @@ -0,0 +1,30 @@
> +# generic config
> +CONFIG_XEN=y
> +CONFIG_XEN_DOM0=y
> +CONFIG_PCI_XEN=y
> +CONFIG_XEN_PCIDEV_FRONTEND=m
> +CONFIG_XEN_BLKDEV_FRONTEND=m
> +CONFIG_XEN_BLKDEV_BACKEND=m
> +CONFIG_XEN_NETDEV_FRONTEND=m
> +CONFIG_XEN_NETDEV_BACKEND=m
> +CONFIG_INPUT_XEN_KBDDEV_FRONTEND=y
> +CONFIG_HVC_XEN=y
> +CONFIG_HVC_XEN_FRONTEND=y
> +CONFIG_TCG_XEN=m
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
> +CONFIG_XEN_ACPI_PROCESSOR=m

The common fragment config looks good for both ARM32 and ARM64:

Acked-by: Julien Grall <julien.grall@linaro.org>

Regards,

-- 
Julien Grall
