Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079AbaJAVZJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 17:25:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47817 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445AbaJAVZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 17:25:07 -0400
Message-ID: <542C7131.1090902@suse.cz>
Date: Wed, 01 Oct 2014 23:25:05 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Masahiro Yamada <yamada.m@jp.panasonic.com>, linux-kbuild@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] kbuild: handle C=... and M=... after entering into
 build directory
References: <1410260544-22657-1-git-send-email-yamada.m@jp.panasonic.com> <1410260544-22657-4-git-send-email-yamada.m@jp.panasonic.com>
In-Reply-To: <1410260544-22657-4-git-send-email-yamada.m@jp.panasonic.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 9.9.2014 13:02, Masahiro Yamada napsal(a):
>  sub-make: FORCE
>  	$(Q)$(MAKE) -C $(KBUILD_OUTPUT) KBUILD_SRC=$(CURDIR) \
> -	KBUILD_EXTMOD="$(KBUILD_EXTMOD)" -f $(CURDIR)/Makefile \
> -	$(filter-out _all sub-make,$(MAKECMDGOALS))
> +	-f $(CURDIR)/Makefile $(filter-out _all sub-make,$(MAKECMDGOALS))
>  
>  # Leave processing to above invocation of make
>  skip-makefile := 1
> @@ -188,6 +158,34 @@ ifeq ($(skip-makefile),)
>  # so that IDEs/editors are able to understand relative filenames.
>  MAKEFLAGS += --no-print-directory
>  
> +# Call a source code checker (by default, "sparse") as part of the
> +# C compilation.
> +#
> +# Use 'make C=1' to enable checking of only re-compiled files.
> +# Use 'make C=2' to enable checking of *all* source files, regardless
> +# of whether they are re-compiled or not.
> +#
> +# See the file "Documentation/sparse.txt" for more details, including
> +# where to get the "sparse" utility.
> +
> +ifeq ("$(origin C)", "command line")

I thought that the origin check would not work in the sub-make, because
the variables are part of the environment. But the sub-makes learn about
commandline variables from the MAKEFLAGS variable, so it works as
expected. Nice cleanup!

Michal
