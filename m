Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756361Ab3AOWDW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:03:22 -0500
Received: from mout.gmx.net ([212.227.17.20]:53464 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754012Ab3AOWDU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:03:20 -0500
X-Authenticated: #1045983
X-Provags-ID: V01U2FsdGVkX1+zm2RhvaSzB2ZaGCov3AOLjNUZNXGeDoWTKsnPkE
	5IIuDf7h2ZbBQ8
Message-ID: <50F5D222.8070208@gmx.de>
Date: Tue, 15 Jan 2013 23:03:14 +0100
From: Helge Deller <deller@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
CC: "James E.J. Bottomley" <jejb@parisc-linux.org>,
        linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-arch@vger.kernel.org, arnd@arndb.de,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: [RESEND PATCH] sysctl: Enable PARISC "unaligned-trap" to be used
 cross-arch
References: <50D2B75A.3000208@synopsys.com> <1357196388-1247-1-git-send-email-vgupta@synopsys.com> <1357196388-1247-2-git-send-email-vgupta@synopsys.com>
In-Reply-To: <1357196388-1247-2-git-send-email-vgupta@synopsys.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/2013 07:59 AM, Vineet Gupta wrote:
> PARISC defines /proc/sys/kernel/unaligned-trap to runtime toggle
> unaligned access emulation.
>
> The exact mechanics of enablig/disabling are still arch specific, we can
> make the sysctl usable by other arches.
>
> Signed-off-by: Vineet Gupta<vgupta@synopsys.com>
> Cc: "James E.J. Bottomley"<jejb@parisc-linux.org>
> Cc: Helge Deller<deller@gmx.de>
> Cc: "Eric W. Biederman"<ebiederm@xmission.com>
> Cc: Serge Hallyn<serge.hallyn@canonical.com>

Acked-by: Helge Deller <deller@gmx.de>

Vineet, as discussed, please push it through the ARC architecture tree...

Helge

> ---
>   arch/parisc/Kconfig |    1 +
>   init/Kconfig        |    8 ++++++++
>   kernel/sysctl.c     |    7 ++++++-
>   3 files changed, 15 insertions(+), 1 deletions(-)
>
> diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
> index b77feff..8c76095 100644
> --- a/arch/parisc/Kconfig
> +++ b/arch/parisc/Kconfig
> @@ -20,6 +20,7 @@ config PARISC
>   	select ARCH_HAVE_NMI_SAFE_CMPXCHG
>   	select GENERIC_SMP_IDLE_THREAD
>   	select GENERIC_STRNCPY_FROM_USER
> +	select SYSCTL_ARCH_UNALIGN_ALLOW
>   	select HAVE_MOD_ARCH_SPECIFIC
>   	select MODULES_USE_ELF_RELA
>   	select CLONE_BACKWARDS
> diff --git a/init/Kconfig b/init/Kconfig
> index e188f9f..e64bb18 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -1240,6 +1240,14 @@ config SYSCTL_ARCH_UNALIGN_NO_WARN
>   	  unaligned access emulation going on under the hood.
>   	  see arch/ia64/kernel/unaligned.c for reference
>
> +config SYSCTL_ARCH_UNALIGN_ALLOW
> +	bool
> +	help
> +	  Enable support for /proc/sys/kernel/unaligned-trap
> +	  Allows arches to define/use @unaligned_enabled to runtime toggle
> +	  the unaligned access emulation.
> +	  see arch/parisc/kernel/unaligned.c for reference
> +
>   config KALLSYMS
>   	 bool "Load all symbols for debugging/ksymoops" if EXPERT
>   	 default y
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index 840fd5e..c4cd655 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -157,13 +157,16 @@ extern int sysctl_tsb_ratio;
>
>   #ifdef __hppa__
>   extern int pwrsw_enabled;
> -extern int unaligned_enabled;
>   #endif
>
>   #ifdef CONFIG_IA64
>   extern int unaligned_dump_stack;
>   #endif
>
> +#ifdef CONFIG_SYSCTL_ARCH_UNALIGN_ALLOW
> +extern int unaligned_enabled;
> +#endif
> +
>   #ifdef CONFIG_SYSCTL_ARCH_UNALIGN_NO_WARN
>   extern int no_unaligned_warning;
>   #endif
> @@ -548,6 +551,8 @@ static struct ctl_table kern_table[] = {
>   	 	.mode		= 0644,
>   		.proc_handler	= proc_dointvec,
>   	},
> +#endif
> +#ifdef CONFIG_SYSCTL_ARCH_UNALIGN_ALLOW
>   	{
>   		.procname	= "unaligned-trap",
>   		.data		=&unaligned_enabled,

