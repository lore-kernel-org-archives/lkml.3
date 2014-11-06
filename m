Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751292AbaKFWUk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:20:40 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:55350 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbaKFWUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:20:36 -0500
Date: Thu, 6 Nov 2014 14:20:31 -0800
From: josh@joshtriplett.org
To: Aristeu Rozanski <aris@redhat.com>
Cc: linux-kernel@vger.kernel.org, Aristeu Rozanski <arozansk@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Fabian Frederick <fabf@skynet.be>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>, Thomas Graf <tgraf@suug.ch>,
        Ying Xue <ying.xue@windriver.com>
Subject: Re: [PATCH] lib/rhashtable: make build optional
Message-ID: <20141106222031.GA7424@cloud>
References: <1415309263-13063-1-git-send-email-aris@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415309263-13063-1-git-send-email-aris@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 04:27:43PM -0500, Aristeu Rozanski wrote:
> From: Aristeu Rozanski <arozansk@redhat.com>
> 
> rhashtable currently is built unconditionally:
> 	text    data     bss     dec     hex filename
> 	9158    2008    5264   16430    402e lib/rhashtable.o
> 	9158    2008    5264   16430    402e (TOTALS)
> 
> and it's used by netlink (which currently can't be optionally built if
> CONFIG_NET is enabled) and netfilter_hash. This patch is useful for
> situations in which memory footprint is a concern and networking is not
> enabled.
> 
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Fabian Frederick <fabf@skynet.be>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Pablo Neira Ayuso <pablo@netfilter.org>
> Cc: Thomas Graf <tgraf@suug.ch>
> Cc: Ying Xue <ying.xue@windriver.com>
> Cc: Josh Triplett <josh@joshtriplett.org>
> Signed-off-by: Aristeu Rozanski <arozansk@redhat.com>

I already have a patch for this in the tiny tree (tiny/no-rhashtable),
using a non-user-visible Kconfig symbol.

Sorry that you ran into some projects that have already been completed.
I'll try to keep the tinification projects list more up to date; I've
been getting patches *very* rapidly, and just about the entire "small"
project list is either done or in progress.

- Josh Triplett

>  lib/Kconfig  | 6 ++++++
>  lib/Makefile | 4 +++-
>  net/Kconfig  | 1 +
>  3 files changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/Kconfig b/lib/Kconfig
> index 108196c..d6b8879 100644
> --- a/lib/Kconfig
> +++ b/lib/Kconfig
> @@ -369,6 +369,12 @@ config ASSOCIATIVE_ARRAY
>  
>  	  for more information.
>  
> +config RHASH_TABLE
> +	bool "Resizable hash table"
> +	default y
> +	help
> +	  Resizable, scalable and concurrent hash table implementation.
> +
>  config HAS_IOMEM
>  	boolean
>  	depends on !NO_IOMEM
> diff --git a/lib/Makefile b/lib/Makefile
> index 53fd120..43d29ff 100644
> --- a/lib/Makefile
> +++ b/lib/Makefile
> @@ -26,7 +26,7 @@ obj-y += bcd.o div64.o sort.o parser.o debug_locks.o random32.o \
>  	 bust_spinlocks.o hexdump.o kasprintf.o bitmap.o scatterlist.o \
>  	 gcd.o lcm.o list_sort.o uuid.o iovec.o clz_ctz.o \
>  	 bsearch.o find_last_bit.o find_next_bit.o llist.o memweight.o kfifo.o \
> -	 percpu-refcount.o percpu_ida.o hash.o rhashtable.o
> +	 percpu-refcount.o percpu_ida.o hash.o
>  obj-y += string_helpers.o
>  obj-$(CONFIG_TEST_STRING_HELPERS) += test-string_helpers.o
>  obj-y += kstrtox.o
> @@ -155,6 +155,8 @@ obj-$(CONFIG_GENERIC_NET_UTILS) += net_utils.o
>  
>  obj-$(CONFIG_STMP_DEVICE) += stmp_device.o
>  
> +obj-$(CONFIG_RHASH_TABLE) += rhashtable.o
> +
>  libfdt_files = fdt.o fdt_ro.o fdt_wip.o fdt_rw.o fdt_sw.o fdt_strerror.o \
>  	       fdt_empty_tree.o
>  $(foreach file, $(libfdt_files), \
> diff --git a/net/Kconfig b/net/Kconfig
> index 99815b5..d376630 100644
> --- a/net/Kconfig
> +++ b/net/Kconfig
> @@ -7,6 +7,7 @@ menuconfig NET
>  	select NLATTR
>  	select GENERIC_NET_UTILS
>  	select BPF
> +	select RHASH_TABLE
>  	---help---
>  	  Unless you really know what you are doing, you should say Y here.
>  	  The reason is that some programs need kernel networking support even
> -- 
> 1.8.3.1
> 
