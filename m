Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955AbaATIDg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 03:03:36 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:61997 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbaATIDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 03:03:34 -0500
MIME-Version: 1.0
In-Reply-To: <1390145225-11030-1-git-send-email-gurligebis@gentoo.org>
References: <1390145225-11030-1-git-send-email-gurligebis@gentoo.org>
Date: Mon, 20 Jan 2014 09:03:33 +0100
X-Google-Sender-Auth: HvkU62HReY1XqhW5GpNNeTHXh54
Message-ID: <CACPM=kUcn_SNhAst=1OZvuwqMetjROy4SjZ9XsW4jvcLmore9w@mail.gmail.com>
Subject: Re: [PATCH] Adding makefile for tools/hv
From: Bjarke Istrup Pedersen <gurligebis@gentoo.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Haiyang Zhang <haiyangz@microsoft.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Bjarke Istrup Pedersen <gurligebis@gentoo.org>,
        Greg Kroah-Hartman <greg@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding Greg to CC list.

/Bjarke

2014/1/19 Bjarke Istrup Pedersen <gurligebis@gentoo.org>:
> Currently, there is no makefile for the Hyper-V tools.
> This patch adds the missing makefile, and adds it to the main tools makefile.
>
> Signed-off-by: Bjarke Istrup Pedersen <gurligebis@gentoo.org>
> ---
>  tools/Makefile    | 11 ++++++-----
>  tools/hv/Makefile | 13 +++++++++++++
>  2 files changed, 19 insertions(+), 5 deletions(-)
>  create mode 100644 tools/hv/Makefile
>
> diff --git a/tools/Makefile b/tools/Makefile
> index a9b0200..35b46bc 100644
> --- a/tools/Makefile
> +++ b/tools/Makefile
> @@ -6,6 +6,7 @@ help:
>         @echo '  cgroup     - cgroup tools'
>         @echo '  cpupower   - a tool for all things x86 CPU power'
>         @echo '  firewire   - the userspace part of nosy, an IEEE-1394 traffic sniffer'
> +       @echo '  hv         - tools used when in Hyper-V clients'
>         @echo '  lguest     - a minimal 32-bit x86 hypervisor'
>         @echo '  perf       - Linux performance measurement and analysis tool'
>         @echo '  selftests  - various kernel selftests'
> @@ -36,7 +37,7 @@ help:
>  cpupower: FORCE
>         $(call descend,power/$@)
>
> -cgroup firewire guest usb virtio vm net: FORCE
> +cgroup firewire hv guest usb virtio vm net: FORCE
>         $(call descend,$@)
>
>  liblk: FORCE
> @@ -57,7 +58,7 @@ tmon: FORCE
>  cpupower_install:
>         $(call descend,power/$(@:_install=),install)
>
> -cgroup_install firewire_install lguest_install perf_install usb_install virtio_install vm_install net_install:
> +cgroup_install firewire_install hv_install lguest_install perf_install usb_install virtio_install vm_install net_install:
>         $(call descend,$(@:_install=),install)
>
>  selftests_install:
> @@ -69,7 +70,7 @@ turbostat_install x86_energy_perf_policy_install:
>  tmon_install:
>         $(call descend,thermal/$(@:_install=),install)
>
> -install: cgroup_install cpupower_install firewire_install lguest_install \
> +install: cgroup_install cpupower_install hv_install firewire_install lguest_install \
>                 perf_install selftests_install turbostat_install usb_install \
>                 virtio_install vm_install net_install x86_energy_perf_policy_install \
>         tmon
> @@ -77,7 +78,7 @@ install: cgroup_install cpupower_install firewire_install lguest_install \
>  cpupower_clean:
>         $(call descend,power/cpupower,clean)
>
> -cgroup_clean firewire_clean lguest_clean usb_clean virtio_clean vm_clean net_clean:
> +cgroup_clean hv_clean firewire_clean lguest_clean usb_clean virtio_clean vm_clean net_clean:
>         $(call descend,$(@:_clean=),clean)
>
>  liblk_clean:
> @@ -95,7 +96,7 @@ turbostat_clean x86_energy_perf_policy_clean:
>  tmon_clean:
>         $(call descend,thermal/tmon,clean)
>
> -clean: cgroup_clean cpupower_clean firewire_clean lguest_clean perf_clean \
> +clean: cgroup_clean cpupower_clean hv_clean firewire_clean lguest_clean perf_clean \
>                 selftests_clean turbostat_clean usb_clean virtio_clean \
>                 vm_clean net_clean x86_energy_perf_policy_clean tmon_clean
>
> diff --git a/tools/hv/Makefile b/tools/hv/Makefile
> new file mode 100644
> index 0000000..bd22f78
> --- /dev/null
> +++ b/tools/hv/Makefile
> @@ -0,0 +1,13 @@
> +# Makefile for Hyper-V tools
> +
> +CC = $(CROSS_COMPILE)gcc
> +PTHREAD_LIBS = -lpthread
> +WARNINGS = -Wall -Wextra
> +CFLAGS = $(WARNINGS) -g $(PTHREAD_LIBS)
> +
> +all: hv_kvp_daemon hv_vss_daemon
> +%: %.c
> +       $(CC) $(CFLAGS) -o $@ $^
> +
> +clean:
> +       $(RM) hv_kvp_daemon hv_vss_daemon
> --
> 1.8.5.3
>
