Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933347AbaJURGe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 13:06:34 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:47119 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932849AbaJURGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 13:06:31 -0400
Message-ID: <54469291.8000906@infradead.org>
Date: Tue, 21 Oct 2014 10:06:25 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Andrey Ryabinin <a.ryabinin@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, Michal Marek <mmarek@suse.cz>,
        Sasha Levin <sasha.levin@oracle.com>, x86@kernel.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
CC: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
        Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>
Subject: Re: [RFC PATCH] UBSan: run-time undefined behavior sanity checker
References: <1413802499-17928-1-git-send-email-a.ryabinin@samsung.com> <1413802499-17928-2-git-send-email-a.ryabinin@samsung.com>
In-Reply-To: <1413802499-17928-2-git-send-email-a.ryabinin@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/14 03:54, Andrey Ryabinin wrote:
> 
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 4e35a5d..7dc9b89 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -646,6 +646,29 @@ config DEBUG_SHIRQ
>  	  Drivers ought to be able to handle interrupts coming in at those
>  	  points; some don't and need to be caught.
>  
> +config HAVE_ARCH_UBSAN_SANTIZE_ALL
> +	bool
> +
> +config UBSAN
> +	bool "Undefined behaviour sanity checker"
> +	help
> +	  This option enables undefined behaviour sanity checker

	                                                 checker.

> +	  Compile-time instrumentataion used to detect various undefined

	               instrumentation is used

> +	  behaviours in runtime. Different kinds of checks could be enabled

prefer:	                                                   may be enabled

> +	  via boot parameter ubsan_handle (see: Documentation/ubsan.txt).
> +	  (TODO: write docs).
> +
> +config UBSAN_SANITIZE_ALL
> +	bool "Enable instrumentation for the entire kernel"
> +	depends on UBSAN
> +	depends on HAVE_ARCH_UBSAN_SANTIZE_ALL
> +	default y
> +	help
> +	  This option acitivates instrumentation for the entire kernel.

	              activates

> +	  If you don't enable this option, you have to explicitly specify
> +	  UBSAN_SANITIZE := y for the files/directories you want to check for UB.
> +
> +
>  menu "Debug Lockups and Hangs"
>  
>  config LOCKUP_DETECTOR


-- 
~Randy
