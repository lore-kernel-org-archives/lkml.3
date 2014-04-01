Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751600AbaDAUWC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 16:22:02 -0400
Received: from hygieia.santi-shop.eu ([78.46.175.2]:50748 "EHLO
	hygieia.santi-shop.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbaDAUWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 16:22:00 -0400
Date: Tue, 1 Apr 2014 22:21:52 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: "Justin Piszcz" <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: X.org doesn't start with 3.14: [KMS] drm report modesetting
 isn't supported
Message-ID: <20140401222152.10af8cdf@neptune.home>
In-Reply-To: <001101cf4d30$782fa0f0$688ee2d0$@lucidpixels.com>
References: <001101cf4d30$782fa0f0$688ee2d0$@lucidpixels.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.22; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Justin,

CC-ing dri-devel as more KMS/radeon people will see it there.

On Mon, 31 March 2014 "Justin Piszcz" <jpiszcz@lucidpixels.com> wrote:
> Do I need some updated ATI firmware (I believe this might have happened in
> the past)..?
> I booted back to 3.13.6, Xorg starts up fine, but with 3.14 it does not
> start.

Could you include all the drm/kms/radeon related output from your
kernel log as well as your /proc/cmdline?
Also, are /sys/class/drm/card0* entries present with proper contents
(modes, enabled, status attributes present and with sensible values)?

What exact AMD/ATI GPU is present in your system (lspci)?

Are your graphics drivers built-in or built as a module?

Bruno


> Thoughts?
> 
> 3.13.6:
> $ ps auxww|grep X
> root      4368  5.3  0.0 296648 37364 tty7     Ssl+ 18:23   0:00 /usr/bin/X
> :0 vt7 -nolisten tcp
> 
> 3.14:
> [   346.490] (**) ModulePath set to "/usr/lib/xorg/modules"
> [   346.490] (WW) Hotplugging is on, devices using drivers 'kbd', 'mouse' or
> 'vmmouse' will be disabled.
> [   346.490] (WW) Disabling Mouse0
> [   346.490] (WW) Disabling Keyboard0
> [   346.490] (II) [KMS] drm report modesetting isn't supported.
> [   346.490] (EE)
> [   346.490] (EE) Backtrace:
> [   346.490] (EE) 0: Xorg (xorg_backtrace+0x48) [0x7fbbbd731c58]
> [   346.490] (EE) 1: Xorg (0x7fbbbd58a000+0x1ab949) [0x7fbbbd735949]
> [   346.490] (EE) 2: /lib/x86_64-linux-gnu/libpthread.so.0
> (0x7fbbbc3c5000+0xf880) [0x7fbbbc3d4880]
> [   346.490] (EE)
> [   346.490] (EE) Segmentation fault at address 0x0
> [   346.490] (EE)
> Fatal server error:
> [   346.491] (EE) Caught signal 11 (Segmentation fault). Server aborting
> [   346.491] (EE)
> [   346.491] (EE)
> Please consult the The X.Org Foundation support
>    at http://wiki.x.org
>  for help.
> [   346.491] (EE) Please also check the log file at "/var/log/Xorg.0.log"
> for additional information.
> [   346.491] (EE)
> 
> Kernel config:
> http://home.comcast.net/~jpiszcz/20140331/3.14.txt
> 
> Kernel diffs:
> 
> $ diff -u config-20140331.1396303540 config-20140320.1395308867 | grep \^+
> +++ config-20140320.1395308867  2014-03-20 05:47:47.508584015 -0400
> +# Linux/x86 3.13.6 Kernel Configuration
> +CONFIG_UIDGID_STRICT_TYPE_CHECKS=y
> +CONFIG_MICROCODE_INTEL_LIB=y
> +# CONFIG_CC_STACKPROTECTOR is not set
> +# CONFIG_SCSI_AIC7XXX_OLD is not set
> +# CONFIG_CPU_THERMAL is not set
> +# CONFIG_GENERIC_PHY is not set
> 
> $ diff -u config-20140331.1396303540 config-20140320.1395308867 | grep \^-
> --- config-20140331.1396303540  2014-03-31 18:05:40.775863929 -0400
> -# Linux/x86 3.14.0 Kernel Configuration
> -CONFIG_HAVE_CC_STACKPROTECTOR=y
> -# CONFIG_CC_STACKPROTECTOR is not set
> -CONFIG_CC_STACKPROTECTOR_NONE=y
> -# CONFIG_CC_STACKPROTECTOR_REGULAR is not set
> -# CONFIG_CC_STACKPROTECTOR_STRONG is not set
> -# CONFIG_ZSMALLOC is not set
> -# CONFIG_NETFILTER_XT_MATCH_IPCOMP is not set
> -# CONFIG_NETFILTER_XT_MATCH_L2TP is not set
> -# CONFIG_GENWQE is not set
> -# CONFIG_I40EVF is not set
> -CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
> -# CONFIG_I2C_DESIGNWARE_PLATFORM is not set
> -# CONFIG_I2C_ROBOTFUZZ_OSIF is not set
> -# CONFIG_ACPI_INT3403_THERMAL is not set
> -# CONFIG_DW_WATCHDOG is not set
> -# CONFIG_MFD_MAX14577 is not set
> -# CONFIG_MFD_LP3943 is not set
> -# CONFIG_DRM_I915 is not set
> -# CONFIG_DRM_BOCHS is not set
> -# CONFIG_FB_OPENCORES is not set
> -# CONFIG_USB_MUSB_HDRC is not set
> -# CONFIG_USB_DWC2 is not set
> -# CONFIG_USB_SERIAL_MXUPORT is not set
> -# CONFIG_USB_OTG_FSM is not set
> -# CONFIG_RTC_DRV_ISL12057 is not set
> -# CONFIG_HP_WIRELESS is not set
> -CONFIG_GENERIC_PHY=y
> -# CONFIG_BCM_KONA_USB2_PHY is not set
> -CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
> -CONFIG_PANIC_TIMEOUT=0
> 
> 
> 
> Justin.
