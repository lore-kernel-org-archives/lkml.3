Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751156Ab3BGGTj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 01:19:39 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:44273 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823Ab3BGGTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 01:19:38 -0500
X-AuditID: 9c930197-b7ca4ae000006ba8-db-51134778b340
From: Namhyung Kim <namhyung@kernel.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: mingo@kernel.org, peterz@infradead.org, jamie.iles@oracle.com,
        penberg@kernel.org, acme@ghostprotocols.net, paulus@samba.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/11] liblockdep: preload helper
References: <1360188694-25077-1-git-send-email-sasha.levin@oracle.com>
	<1360188694-25077-12-git-send-email-sasha.levin@oracle.com>
Date: Thu, 07 Feb 2013 15:19:36 +0900
In-Reply-To: <1360188694-25077-12-git-send-email-sasha.levin@oracle.com>
	(Sasha Levin's message of "Wed, 6 Feb 2013 17:11:34 -0500")
Message-ID: <877gmksl1j.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sasha,

On Wed,  6 Feb 2013 17:11:34 -0500, Sasha Levin wrote:
> This is a simple wrapper to make using liblockdep on existing applications
> much easier.
>
> After running 'make && make install', it becomes quite simple to test things
> with liblockdep. For example, to try it on perf:
>
> 	liblockdep perf

Shouldn't it be 'lockdep perf ...'?

Thanks,
Namhyung

>
> No other integration required.
>
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> ---
>  tools/lib/lockdep/Makefile | 12 ++++++++----
>  tools/lib/lockdep/lockdep  |  3 +++
>  2 files changed, 11 insertions(+), 4 deletions(-)
>  create mode 100755 tools/lib/lockdep/lockdep
>
> diff --git a/tools/lib/lockdep/Makefile b/tools/lib/lockdep/Makefile
> index 245f8ba..b22122f 100644
> --- a/tools/lib/lockdep/Makefile
> +++ b/tools/lib/lockdep/Makefile
> @@ -34,7 +34,9 @@ DESTDIR ?=
>  DESTDIR_SQ = '$(subst ','\'',$(DESTDIR))'
>  
>  prefix ?= /usr/local
> -bindir_relative = lib
> +libdir_relative = lib
> +libdir = $(prefix)/$(libdir_relative)
> +bindir_relative = bin
>  bindir = $(prefix)/$(bindir_relative)
>  
>  export DESTDIR DESTDIR_SQ INSTALL
> @@ -90,13 +92,14 @@ objtree		:= $(CURDIR)
>  src		:= $(srctree)
>  obj		:= $(objtree)
>  
> -export prefix bindir src obj
> +export prefix libdir bindir src obj
>  
>  # Shell quotes
> +libdir_SQ = $(subst ','\'',$(libdir))
>  bindir_SQ = $(subst ','\'',$(bindir))
> -bindir_relative_SQ = $(subst ','\'',$(bindir_relative))
>  
>  LIB_FILE = liblockdep.a liblockdep.so
> +BIN_FILE = lockdep
>  
>  CONFIG_INCLUDES =
>  CONFIG_LIBS	=
> @@ -229,7 +232,8 @@ define do_install
>  endef
>  
>  install_lib: all_cmd
> -	$(Q)$(call do_install,$(LIB_FILE),$(bindir_SQ))
> +	$(Q)$(call do_install,$(LIB_FILE),$(libdir_SQ))
> +	$(Q)$(call do_install,$(BIN_FILE),$(bindir_SQ))
>  
>  install: install_lib
>  
> diff --git a/tools/lib/lockdep/lockdep b/tools/lib/lockdep/lockdep
> new file mode 100755
> index 0000000..616bf9a
> --- /dev/null
> +++ b/tools/lib/lockdep/lockdep
> @@ -0,0 +1,3 @@
> +#! /bin/bash
> +
> +LD_PRELOAD=liblockdep.so "$@"
