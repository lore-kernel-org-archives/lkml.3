Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846AbaGBNfQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 09:35:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36921 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752030AbaGBNfO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 09:35:14 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20140702124016.GA26965@sepie.suse.cz>
References: <20140702124016.GA26965@sepie.suse.cz> <20140702105645.17220.92338.stgit@warthog.procyon.org.uk>
To: Michal Marek <mmarek@suse.cz>
Cc: dhowells@redhat.com, torvalds@linux-foundation.org, sam@ravnborg.org,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Boaz Harrosh <boaz@plexistor.com>
Subject: Re: [PATCH] Fix compiler message generation
Date: Wed, 02 Jul 2014 14:34:10 +0100
Message-ID: <2690.1404308050@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Marek <mmarek@suse.cz> wrote:

> From 5b59dcacf358f143b9fb39d2f788142ab9ba3e00 Mon Sep 17 00:00:00 2001
> From: Michal Marek <mmarek@suse.cz>
> Date: Wed, 2 Jul 2014 14:28:26 +0200
> Subject: [PATCH] kbuild: Print the name of the build directory
> 
> With commit 9da0763b (kbuild: Use relative path when building in a
> subdir of the source tree), the compiler messages include relative
> paths. These are however relative to the build directory, not the
> directory where make was started. Print the "Entering directory ..."
> message once, so that IDEs/editors can find the source files.
> 
> Signed-off-by: Michal Marek <mmarek@suse.cz>
> ---
>  Makefile | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/Makefile b/Makefile
> index 97b2861..40544a0 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -126,7 +126,10 @@ PHONY += $(MAKECMDGOALS) sub-make
>  $(filter-out _all sub-make $(CURDIR)/Makefile, $(MAKECMDGOALS)) _all: sub-make
>  	@:
>  
> +# Fake the "Entering directory" message once, so that IDEs/editors are
> +# able to understand relative filenames.
>  sub-make: FORCE
> +	@echo "make[1]: Entering directory \`$(KBUILD_OUTPUT)'"
>  	$(if $(KBUILD_VERBOSE:1=),@)$(MAKE) -C $(KBUILD_OUTPUT) \
>  	KBUILD_SRC=$(CURDIR) \
>  	KBUILD_EXTMOD="$(KBUILD_EXTMOD)" -f $(CURDIR)/Makefile \

Works for me with emacs.

Acked-by: David Howells <dhowells@redhat.com>
