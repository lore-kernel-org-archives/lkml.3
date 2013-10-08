Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755782Ab3JHT3t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 15:29:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43913 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488Ab3JHT3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 15:29:48 -0400
Date: Tue, 8 Oct 2013 12:29:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christian Ruppert <christian.ruppert@abilis.com>
Cc: linux-kernel@vger.kernel.org, alexander.stein@systec-electronic.com,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Noam Camus <noamc@ezchip.com>,
        pierrick hascoet <pierrick.hascoet@abilis.com>
Subject: Re: [PATCH REBASE] Add option to disable kernel compression
Message-Id: <20131008122940.63aae6f1769a162eb8e5e602@linux-foundation.org>
In-Reply-To: <1381235612-23988-1-git-send-email-christian.ruppert@abilis.com>
References: <2065777.DKEM6dSyjc@ws-stein>
	<1381235612-23988-1-git-send-email-christian.ruppert@abilis.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  8 Oct 2013 14:33:32 +0200 Christian Ruppert <christian.ruppert@abilis.com> wrote:

> Until now, kernel compression can only be disabled by deselecting
> HAVE_<compression> in the architecture Kconfig.

Scratching my head a bit.  There's no way of deselecting these things. 
I *think* you mean "by editing arch/xxx/Kconfig and removing all the
"select HAVE_KERNEL_<compression>" lines"?

> However, some
> users/platforms within the same architecture might want to use
> compression while others might want to disable it.

Why would anyone want to run an uncompressed kernel, btw?  Boot time?

> This patch is a solution to the dilemma.
> 
> ...
>
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -118,7 +118,6 @@ config HAVE_KERNEL_LZ4
>  choice
>  	prompt "Kernel compression mode"
>  	default KERNEL_GZIP
> -	depends on HAVE_KERNEL_GZIP || HAVE_KERNEL_BZIP2 || HAVE_KERNEL_LZMA || HAVE_KERNEL_XZ || HAVE_KERNEL_LZO || HAVE_KERNEL_LZ4
>  	help
>  	  The linux kernel is a kind of self-extracting executable.
>  	  Several compression algorithms are available, which differ
> @@ -137,6 +136,13 @@ choice
>  
>  	  If in doubt, select 'gzip'
>  
> +config KERNEL_UNCOMPRESSED
> +	bool "No compression"
> +	help
> +	  No compression at all. The kernel is huge but the compression and
> +	  decompression times are zero.
> +	  This is usually not what you want.
> +
>  config KERNEL_GZIP
>  	bool "Gzip"
>  	depends on HAVE_KERNEL_GZIP

It's odd to create CONFIG_KERNEL_UNCOMPRESSED and not use it for
anything, but I guess Kconfig's `choice' forces this.


