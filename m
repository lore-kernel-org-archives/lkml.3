Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465AbaAMTk4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 14:40:56 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38815 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbaAMTkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 14:40:52 -0500
Message-ID: <52D44141.4020304@infradead.org>
Date: Mon, 13 Jan 2014 11:40:49 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Dave Hansen <dave@sr71.net>, linux-kernel@vger.kernel.org
CC: linux-security-module@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 1/3] kconfig: consolidate arch-specific seccomp options
References: <20140102202014.CA206E9B@viggo.jf.intel.com>
In-Reply-To: <20140102202014.CA206E9B@viggo.jf.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/02/2014 12:20 PM, Dave Hansen wrote:
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> ---
> 
>  linux.git-davehans/arch/arm/Kconfig        |   15 +--------------
>  linux.git-davehans/arch/microblaze/Kconfig |   18 +-----------------
>  linux.git-davehans/arch/mips/Kconfig       |   18 +-----------------
>  linux.git-davehans/arch/powerpc/Kconfig    |   18 +-----------------
>  linux.git-davehans/arch/s390/Kconfig       |   18 +-----------------
>  linux.git-davehans/arch/sh/Kconfig         |   17 +----------------
>  linux.git-davehans/arch/sparc/Kconfig      |   18 +-----------------
>  linux.git-davehans/arch/x86/Kconfig        |   17 +----------------
>  linux.git-davehans/security/Kconfig        |   21 ++++++++++++++++++++-
>  9 files changed, 28 insertions(+), 132 deletions(-)
> 
> diff -puN security/Kconfig~consolidate-seccomp-options security/Kconfig
> --- linux.git/security/Kconfig~consolidate-seccomp-options	2014-01-02 11:23:58.604785905 -0800
> +++ linux.git-davehans/security/Kconfig	2014-01-02 11:23:58.614786355 -0800
> @@ -167,5 +167,24 @@ config DEFAULT_SECURITY
>  	default "yama" if DEFAULT_SECURITY_YAMA
>  	default "" if DEFAULT_SECURITY_DAC
>  
> -endmenu
> +config HAVE_ARCH_SECCOMP
> +	bool
> +
> +config SECCOMP
> +	bool
> +	default y

Prefer
	def_bool y

> +	prompt "Enable seccomp to safely compute untrusted bytecode"
> +	---help---
> +	  This kernel feature is useful for number crunching applications
> +	  that may need to compute untrusted bytecode during their
> +	  execution. By using pipes or other transports made available to
> +	  the process as file descriptors supporting the read/write
> +	  syscalls, it's possible to isolate those applications in
> +	  their own address space using seccomp. Once seccomp is
> +	  enabled via prctl(PR_SET_SECCOMP), it cannot be disabled
> +	  and the task is only allowed to execute a few safe syscalls
> +	  defined by each seccomp mode.
>  
> +	  If unsure, say Y. Only embedded should say N here.
> +
> +endmenu


-- 
~Randy
