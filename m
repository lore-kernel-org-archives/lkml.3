Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628AbaHFWi7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 18:38:59 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:55487 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753608AbaHFWi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 18:38:58 -0400
Date: Wed, 6 Aug 2014 15:38:56 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Josh Triplett <josh@joshtriplett.org>
cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
        "Luis R. Rodriguez" <mcgrof@suse.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86: Add "make tinyconfig" to configure the tiniest
 possible kernel
In-Reply-To: <20140806223152.GA14348@jtriplet-mobl1>
Message-ID: <alpine.DEB.2.02.1408061537220.13545@chino.kir.corp.google.com>
References: <20140806222419.GA2566@jtriplet-mobl1> <20140806223152.GA14348@jtriplet-mobl1>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Aug 2014, Josh Triplett wrote:

> diff --git a/arch/x86/Makefile b/arch/x86/Makefile
> index 1568678..2b5ca16 100644
> --- a/arch/x86/Makefile
> +++ b/arch/x86/Makefile
> @@ -257,6 +257,10 @@ PHONY += kvmconfig
>  kvmconfig:
>  	$(call mergeconfig,kvm_guest)
>  
> +PHONY += tinyconfig
> +tinyconfig: allnoconfig

Calling allnoconfig here makes "make tinyconfig" default to CONFIG_X86_32 
even on 64 bit platforms and the caller would need to explicitly do
"make ARCH=x86_64 tinyconfig" to avoid it.  It's not clear that this is 
intended from the documentation of tinyconfig, that tiniest == 32 bit by 
default.

> +	$(call mergeconfig,tiny)
> +
>  define archhelp
>    echo  '* bzImage      - Compressed kernel image (arch/x86/boot/bzImage)'
>    echo  '  install      - Install kernel using'
> @@ -271,4 +275,5 @@ define archhelp
>    echo  '                  FDARGS="..."  arguments for the booted kernel'
>    echo  '                  FDINITRD=file initrd for the booted kernel'
>    echo  '  kvmconfig	- Enable additional options for guest kernel support'
> +  echo  '  tinyconfig   - Configure the tiniest possible kernel'
>  endef
> diff --git a/arch/x86/configs/tiny.config b/arch/x86/configs/tiny.config
> new file mode 100644
> index 0000000..8f0e54c
> --- /dev/null
> +++ b/arch/x86/configs/tiny.config
> @@ -0,0 +1,5 @@
> +CONFIG_CC_OPTIMIZE_FOR_SIZE=y
> +CONFIG_KERNEL_XZ=y
> +CONFIG_NOHIGHMEM=y
> +CONFIG_OPTIMIZE_INLINING=y
> +CONFIG_SLOB=y
