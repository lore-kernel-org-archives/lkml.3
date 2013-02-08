Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946231Ab3BHKuc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 05:50:32 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:52539 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161046Ab3BHKua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 05:50:30 -0500
MIME-Version: 1.0
In-Reply-To: <6cebd9755011670ecaeec7930b3fa7ed0f16b3b6.1360317993.git.vijay.kumar@st.com>
References: <cover.1360317993.git.vijay.kumar@st.com>
	<6cebd9755011670ecaeec7930b3fa7ed0f16b3b6.1360317993.git.vijay.kumar@st.com>
Date: Fri, 8 Feb 2013 16:20:29 +0530
Message-ID: <CAKohpokPhHtuDDBPUYp9YPOrEnaaKxthjiAemq74qfour_3aYQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] SPEAr13xx_defconfig: Enable Memory split 2G/2G needed
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Vijay Kumar Mishra <vijay.kumar@st.com>
Cc: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vijay,

By mistake you have added an ST internal list in cc, fixed it now.

Subject should be:

ARM: SPEAr13xx: Enable 2G/2G Memory split in defconfig

On 8 February 2013 16:16, Vijay Kumar Mishra <vijay.kumar@st.com> wrote:
> Memory split 2G/2G is enabled as needed for SPEAr1310 RevC board to boot.
> Before enabling this option the boot was hanging at uncompressing linux.
> ---
>  arch/arm/configs/spear13xx_defconfig |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/arch/arm/configs/spear13xx_defconfig b/arch/arm/configs/spear13xx_defconfig
> index 1fdb826..1b5ceff 100644
> --- a/arch/arm/configs/spear13xx_defconfig
> +++ b/arch/arm/configs/spear13xx_defconfig
> @@ -14,13 +14,13 @@ CONFIG_MACH_SPEAR1340=y
>  CONFIG_SMP=y
>  # CONFIG_SMP_ON_UP is not set
>  # CONFIG_ARM_CPU_TOPOLOGY is not set
> +CONFIG_VMSPLIT_2G=y
>  CONFIG_ARM_APPENDED_DTB=y
>  CONFIG_ARM_ATAG_DTB_COMPAT=y
>  CONFIG_BINFMT_MISC=y
>  CONFIG_NET=y
>  CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
>  CONFIG_MTD=y

> -CONFIG_MTD_OF_PARTS=y
> -# CONFIG_HID_SUPPORT is not set
> -# CONFIG_USB_DEVICE_CLASS is not set

Unrelated chages. Don't get them in next time. In case they
just got added automatically because you did and make savedefconfig,
do a make savedefconfig before any of these patches to make things
stable for all SPEAr SoCs. And then add these patches.
