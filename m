Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386AbaDWFm7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 01:42:59 -0400
Received: from ozlabs.org ([103.22.144.67]:58504 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752596AbaDWFl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 01:41:26 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Borislav Petkov <bp@alien8.de>, Jiri Olsa <jolsa@redhat.com>
Cc: Borislav Petkov <bp@suse.de>, Sasha Levin <sasha.levin@oracle.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
        virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <rric@kernel.org>, David Ahern <dsahern@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>
Subject: Re: [PATCH 1/3] tools: Unify export.h
In-Reply-To: <1397493185-19521-2-git-send-email-bp@alien8.de>
References: <1397493185-19521-1-git-send-email-bp@alien8.de> <1397493185-19521-2-git-send-email-bp@alien8.de>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 23 Apr 2014 13:37:03 +0930
Message-ID: <87k3agheoo.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov <bp@alien8.de> writes:
> From: Borislav Petkov <bp@suse.de>
>
> So tools/ has been growing three, at a different stage of their
> development export.h headers and so we should unite into one. Add
> tools/include/ to the include path of virtio and liblockdep to pick the
> shared header now.

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Thanks,
Rusty.

>
> Cc: Sasha Levin <sasha.levin@oracle.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: linux-kernel@vger.kernel.org
> Cc: virtio-dev@lists.oasis-open.org
> Cc: virtualization@lists.linux-foundation.org
> Signed-off-by: Borislav Petkov <bp@suse.de>
> ---
>  tools/{virtio => include}/linux/export.h  | 5 +++++
>  tools/lib/lockdep/Makefile                | 2 +-
>  tools/lib/lockdep/uinclude/linux/export.h | 7 -------
>  tools/perf/MANIFEST                       | 1 +
>  tools/perf/Makefile.perf                  | 2 +-
>  tools/perf/util/include/linux/export.h    | 6 ------
>  tools/virtio/Makefile                     | 2 +-
>  7 files changed, 9 insertions(+), 16 deletions(-)
>  rename tools/{virtio => include}/linux/export.h (70%)
>  delete mode 100644 tools/lib/lockdep/uinclude/linux/export.h
>  delete mode 100644 tools/perf/util/include/linux/export.h
>
> diff --git a/tools/virtio/linux/export.h b/tools/include/linux/export.h
> similarity index 70%
> rename from tools/virtio/linux/export.h
> rename to tools/include/linux/export.h
> index 7311d326894a..d07e586b9ba0 100644
> --- a/tools/virtio/linux/export.h
> +++ b/tools/include/linux/export.h
> @@ -1,5 +1,10 @@
> +#ifndef _TOOLS_LINUX_EXPORT_H_
> +#define _TOOLS_LINUX_EXPORT_H_
> +
>  #define EXPORT_SYMBOL(sym)
>  #define EXPORT_SYMBOL_GPL(sym)
>  #define EXPORT_SYMBOL_GPL_FUTURE(sym)
>  #define EXPORT_UNUSED_SYMBOL(sym)
>  #define EXPORT_UNUSED_SYMBOL_GPL(sym)
> +
> +#endif
> diff --git a/tools/lib/lockdep/Makefile b/tools/lib/lockdep/Makefile
> index 07b0b7542511..41d4a99ce46e 100644
> --- a/tools/lib/lockdep/Makefile
> +++ b/tools/lib/lockdep/Makefile
> @@ -112,7 +112,7 @@ export Q VERBOSE
>  
>  LIBLOCKDEP_VERSION = $(LL_VERSION).$(LL_PATCHLEVEL).$(LL_EXTRAVERSION)
>  
> -INCLUDES = -I. -I/usr/local/include -I./uinclude -I./include $(CONFIG_INCLUDES)
> +INCLUDES = -I. -I/usr/local/include -I./uinclude -I./include -I../../include $(CONFIG_INCLUDES)
>  
>  # Set compile option CFLAGS if not set elsewhere
>  CFLAGS ?= -g -DCONFIG_LOCKDEP -DCONFIG_STACKTRACE -DCONFIG_PROVE_LOCKING -DBITS_PER_LONG=__WORDSIZE -DLIBLOCKDEP_VERSION='"$(LIBLOCKDEP_VERSION)"' -rdynamic -O0 -g
> diff --git a/tools/lib/lockdep/uinclude/linux/export.h b/tools/lib/lockdep/uinclude/linux/export.h
> deleted file mode 100644
> index 6bdf3492c535..000000000000
> --- a/tools/lib/lockdep/uinclude/linux/export.h
> +++ /dev/null
> @@ -1,7 +0,0 @@
> -#ifndef _LIBLOCKDEP_LINUX_EXPORT_H_
> -#define _LIBLOCKDEP_LINUX_EXPORT_H_
> -
> -#define EXPORT_SYMBOL(sym)
> -#define EXPORT_SYMBOL_GPL(sym)
> -
> -#endif
> diff --git a/tools/perf/MANIFEST b/tools/perf/MANIFEST
> index c0c87c87b60f..81783c2037fc 100644
> --- a/tools/perf/MANIFEST
> +++ b/tools/perf/MANIFEST
> @@ -7,6 +7,7 @@ tools/lib/symbol/kallsyms.h
>  tools/include/asm/bug.h
>  tools/include/linux/compiler.h
>  tools/include/linux/hash.h
> +tools/include/linux/export.h
>  include/linux/const.h
>  include/linux/perf_event.h
>  include/linux/rbtree.h
> diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
> index e96923310d57..595fcbeb8262 100644
> --- a/tools/perf/Makefile.perf
> +++ b/tools/perf/Makefile.perf
> @@ -222,7 +222,7 @@ LIB_H += util/include/linux/const.h
>  LIB_H += util/include/linux/ctype.h
>  LIB_H += util/include/linux/kernel.h
>  LIB_H += util/include/linux/list.h
> -LIB_H += util/include/linux/export.h
> +LIB_H += ../include/linux/export.h
>  LIB_H += util/include/linux/poison.h
>  LIB_H += util/include/linux/rbtree.h
>  LIB_H += util/include/linux/rbtree_augmented.h
> diff --git a/tools/perf/util/include/linux/export.h b/tools/perf/util/include/linux/export.h
> deleted file mode 100644
> index b43e2dc21e04..000000000000
> --- a/tools/perf/util/include/linux/export.h
> +++ /dev/null
> @@ -1,6 +0,0 @@
> -#ifndef PERF_LINUX_MODULE_H
> -#define PERF_LINUX_MODULE_H
> -
> -#define EXPORT_SYMBOL(name)
> -
> -#endif
> diff --git a/tools/virtio/Makefile b/tools/virtio/Makefile
> index 3187c62d9814..9325f4693821 100644
> --- a/tools/virtio/Makefile
> +++ b/tools/virtio/Makefile
> @@ -3,7 +3,7 @@ test: virtio_test vringh_test
>  virtio_test: virtio_ring.o virtio_test.o
>  vringh_test: vringh_test.o vringh.o virtio_ring.o
>  
> -CFLAGS += -g -O2 -Wall -I. -I ../../usr/include/ -Wno-pointer-sign -fno-strict-overflow -fno-strict-aliasing -fno-common -MMD -U_FORTIFY_SOURCE
> +CFLAGS += -g -O2 -Wall -I. -I../include/ -I ../../usr/include/ -Wno-pointer-sign -fno-strict-overflow -fno-strict-aliasing -fno-common -MMD -U_FORTIFY_SOURCE
>  vpath %.c ../../drivers/virtio ../../drivers/vhost
>  mod:
>  	${MAKE} -C `pwd`/../.. M=`pwd`/vhost_test
> -- 
> 1.9.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
