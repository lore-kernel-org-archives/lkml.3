Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765087Ab3DDXRV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 19:17:21 -0400
Received: from mail-ia0-f172.google.com ([209.85.210.172]:53742 "EHLO
	mail-ia0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765062Ab3DDXRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 19:17:19 -0400
Message-ID: <515E09FA.1090408@gmail.com>
Date: Thu, 04 Apr 2013 18:17:14 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Michal Marek <mmarek@suse.cz>, Grant Likely <glikely@secretlab.ca>,
        arm@kernel.org, Shawn Guo <shawn.guo@linaro.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>, linux-kbuild@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH V2 1/7] kbuild: create an "include chroot" for DT bindings
References: <1365032098-22825-1-git-send-email-swarren@wwwdotorg.org>
In-Reply-To: <1365032098-22825-1-git-send-email-swarren@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2013 06:34 PM, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
> 
> The recent dtc+cpp support allows header files and C pre-processor
> defines/macros to be used when compiling device tree files. These
> headers will typically define various constants that are part of the
> device tree bindings.
> 
> The original patch which set up the dtc+cpp include path only considered
> using those headers from device tree files. However, most are also
> useful for kernel code which needs to interpret the device tree.
> 
> In both the DT files and the kernel, I'd like to include the DT-related
> headers in the same way, for example, <dt-bindings/gpio/tegra-gpio.h>.
> That will simplify any text which discusses the DT header locations.
> 
> Creating a <dt-bindings/> for kernel source to use is as simple as
> placing files into include/dt-bindings/.
> 
> However, when compiling DT files, the include path should be restricted
> so that only the dt-bindings path is available; arbitrary kernel headers
> shouldn't be exposed. For this reason, create a specific include
> directory for use by dtc+cpp, and symlink dt-bindings from there to the
> actual location of include/dt-bindings/. For want of a better location,
> place this "include chroot" into the existing dts/ directory.
> 
> arch/*/boot/dts/include/dt-bindings -> ../../../../../include/dt-bindings
> 
> Some headers used by device tree files may not be useful to the kernel;
> they may be used simply to aid in constructing the DT file (e.g. macros
> to create a node), but not define any information that the kernel needs
> to share. These may be placed directly into arch/*/boot/dts/ along with
> the DT files themselves.
> 
> Cc: Shawn Guo <shawn.guo@linaro.org>
> Cc: Hiroshi Doyu <hdoyu@nvidia.com>
> Acked-by: Michal Marek <mmarek@suse.cz>
> Acked-by: Shawn Guo <shawn.guo@linaro.org>
> Acked-by: Rob Herring <rob.herring@calxeda.com>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> ---
> Grant, Rob, Michal, I'm hoping for acks or comments from you so this
> series can be placed into a topic branch in the arm-soc repo, for others
> to build on during the 3.10 kernel cycle. Thanks.

Well, you have mine here and the rest looks fine, so add it to the others.

Rob

> 
> This first patch was previously posted separately as V2. I'm including
> it here to keep it with the whole series. I hope this series can be
> applied as a topic branch in arm-soc.
> ---
>  arch/arm/boot/dts/include/dt-bindings |    1 +
>  scripts/Makefile.lib                  |    2 +-
>  2 files changed, 2 insertions(+), 1 deletion(-)
>  create mode 120000 arch/arm/boot/dts/include/dt-bindings
> 
> diff --git a/arch/arm/boot/dts/include/dt-bindings b/arch/arm/boot/dts/include/dt-bindings
> new file mode 120000
> index 0000000..08c00e4
> --- /dev/null
> +++ b/arch/arm/boot/dts/include/dt-bindings
> @@ -0,0 +1 @@
> +../../../../../include/dt-bindings
> \ No newline at end of file
> diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
> index 07125e6..af35521 100644
> --- a/scripts/Makefile.lib
> +++ b/scripts/Makefile.lib
> @@ -158,7 +158,7 @@ ld_flags       = $(LDFLAGS) $(ldflags-y)
>  
>  dtc_cpp_flags  = -Wp,-MD,$(depfile) -nostdinc                            \
>  		 -I$(srctree)/arch/$(SRCARCH)/boot/dts                   \
> -		 -I$(srctree)/arch/$(SRCARCH)/include/dts                \
> +		 -I$(srctree)/arch/$(SRCARCH)/boot/dts/include           \
>  		 -undef -D__DTS__
>  
>  # Finds the multi-part object the current object will be linked into
> 

