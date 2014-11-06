Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751484AbaKFV61 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 16:58:27 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:47144 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbaKFV60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 16:58:26 -0500
Date: Thu, 6 Nov 2014 13:58:19 -0800
From: josh@joshtriplett.org
To: Aristeu Rozanski <aris@redhat.com>
Cc: linux-kernel@vger.kernel.org, Aristeu Rozanski <arozansk@redhat.com>,
        Changli Gao <xiaosuo@gmail.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>, Eric Paris <eparis@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Jesse Gross <jesse@nicira.com>, Jonathan Corbet <corbet@lwn.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pravin Shelar <pshelar@nicira.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] lib/flex_array: make build optional
Message-ID: <20141106215819.GB7185@cloud>
References: <1415309241-12971-1-git-send-email-aris@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415309241-12971-1-git-send-email-aris@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 04:27:21PM -0500, Aristeu Rozanski wrote:
> From: Aristeu Rozanski <arozansk@redhat.com>
> 
> flex_array currently is built unconditionally:
> 	text    data     bss     dec     hex filename
> 	2294    1008    1568    4870    1306 lib/flex_array.o
> 	2294    1008    1568    4870    1306 (TOTALS)
> 
> and it's used by procfs, selinux and openvswitch. This patch is
> useful for situations in which memory footprint is a concern and
> those features aren't used.
> 
> Cc: Changli Gao <xiaosuo@gmail.com>
> Cc: Dave Hansen <dave@linux.vnet.ibm.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Eric Paris <eparis@redhat.com>
> Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>
> Cc: Jesse Gross <jesse@nicira.com>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
> Cc: Pravin Shelar <pshelar@nicira.com>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: Josh Triplett <josh@joshtriplett.org>
> Signed-off-by: Aristeu Rozanski <arozansk@redhat.com>

I already have a patch for this sitting in the tiny tree (branch
tiny/unflex-array) for the next merge window, and that patch hides the
symbol from the user, just selecting it internally.

I've updated the tinification project list to mark that and several
other projects as "done" or "in progress".

- Josh Triplett

>  fs/proc/Kconfig          |  1 +
>  lib/Kconfig              | 10 ++++++++++
>  lib/Makefile             |  3 ++-
>  net/openvswitch/Kconfig  |  1 +
>  security/selinux/Kconfig |  1 +
>  5 files changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/proc/Kconfig b/fs/proc/Kconfig
> index 2183fcf..2d624b7 100644
> --- a/fs/proc/Kconfig
> +++ b/fs/proc/Kconfig
> @@ -1,6 +1,7 @@
>  config PROC_FS
>  	bool "/proc file system support" if EXPERT
>  	default y
> +	select FLEX_ARRAY
>  	help
>  	  This is a virtual file system providing information about the status
>  	  of the system. "Virtual" means that it doesn't take up any space on
> diff --git a/lib/Kconfig b/lib/Kconfig
> index 54cf309..675920b 100644
> --- a/lib/Kconfig
> +++ b/lib/Kconfig
> @@ -432,6 +432,16 @@ config GLOB_SELFTEST
>  	  module load) by a small amount, so you're welcome to play with
>  	  it, but you probably don't need it.
>  
> +config FLEX_ARRAY
> +	bool "Flexible array"
> +	default n
> +	help
> +	  This option enables an implementation of flexible arrays which
> +	  allows creating arrays of fixed size elements with an arbritrary
> +	  size without requiring the single allocation of a contiguous area.
> +
> +	  See Documentation/flexible-arrays.txt
> +
>  #
>  # Netlink attribute parsing support is select'ed if needed
>  #
> diff --git a/lib/Makefile b/lib/Makefile
> index 7512dc9..9c12cbc 100644
> --- a/lib/Makefile
> +++ b/lib/Makefile
> @@ -24,7 +24,7 @@ obj-y	+= lockref.o
>  
>  obj-y += bcd.o div64.o sort.o parser.o halfmd4.o debug_locks.o random32.o \
>  	 bust_spinlocks.o hexdump.o kasprintf.o bitmap.o scatterlist.o \
> -	 gcd.o lcm.o list_sort.o uuid.o flex_array.o iovec.o clz_ctz.o \
> +	 gcd.o lcm.o list_sort.o uuid.o iovec.o clz_ctz.o \
>  	 bsearch.o find_last_bit.o find_next_bit.o llist.o memweight.o kfifo.o \
>  	 percpu-refcount.o percpu_ida.o hash.o rhashtable.o
>  obj-y += string_helpers.o
> @@ -35,6 +35,7 @@ obj-$(CONFIG_TEST_LKM) += test_module.o
>  obj-$(CONFIG_TEST_USER_COPY) += test_user_copy.o
>  obj-$(CONFIG_TEST_BPF) += test_bpf.o
>  obj-$(CONFIG_TEST_FIRMWARE) += test_firmware.o
> +obj-$(CONFIG_FLEX_ARRAY) += flex_array.o
>  
>  ifeq ($(CONFIG_DEBUG_KOBJECT),y)
>  CFLAGS_kobject.o += -DDEBUG
> diff --git a/net/openvswitch/Kconfig b/net/openvswitch/Kconfig
> index ba3bb82..1d979ce 100644
> --- a/net/openvswitch/Kconfig
> +++ b/net/openvswitch/Kconfig
> @@ -5,6 +5,7 @@
>  config OPENVSWITCH
>  	tristate "Open vSwitch"
>  	select LIBCRC32C
> +	select FLEX_ARRAY
>  	---help---
>  	  Open vSwitch is a multilayer Ethernet switch targeted at virtualized
>  	  environments.  In addition to supporting a variety of features
> diff --git a/security/selinux/Kconfig b/security/selinux/Kconfig
> index bca1b74..cfcc7c1 100644
> --- a/security/selinux/Kconfig
> +++ b/security/selinux/Kconfig
> @@ -2,6 +2,7 @@ config SECURITY_SELINUX
>  	bool "NSA SELinux Support"
>  	depends on SECURITY_NETWORK && AUDIT && NET && INET
>  	select NETWORK_SECMARK
> +	select FLEX_ARRAY
>  	default n
>  	help
>  	  This selects NSA Security-Enhanced Linux (SELinux).
> -- 
> 1.8.3.1
> 
