Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422768AbaD3PgE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 11:36:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47958 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422696AbaD3PgB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 11:36:01 -0400
Date: Wed, 30 Apr 2014 17:35:59 +0200
From: Michal Marek <mmarek@suse.cz>
To: Masahiro Yamada <yamada.m@jp.panasonic.com>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] kbuild: support simultaneous "make %config" and "make
 all"
Message-ID: <20140430153559.GA31256@sepie.suse.cz>
References: <1397026295-13822-1-git-send-email-yamada.m@jp.panasonic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397026295-13822-1-git-send-email-yamada.m@jp.panasonic.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2014 at 03:51:35PM +0900, Masahiro Yamada wrote:
> Kbuild is supposed to support mixed targets. (%config and build targets)
> 
> But "make all" did nothing if it was run with configuration targets.
> For example,
> 
>   $ LANG=C make defconfig all
>     HOSTCC  scripts/basic/fixdep
>     HOSTCC  scripts/kconfig/conf.o
>     SHIPPED scripts/kconfig/zconf.tab.c
>     SHIPPED scripts/kconfig/zconf.lex.c
>     SHIPPED scripts/kconfig/zconf.hash.c
>     HOSTCC  scripts/kconfig/zconf.tab.o
>     HOSTLD  scripts/kconfig/conf
>   *** Default configuration is based on 'x86_64_defconfig'
>   #
>   # configuration written to .config
>   #
>   make: Nothing to be done for `all'.
> 
> This commits allows "make %config all" and makes sure
> mixed targets are built one by one in the given order.
> 
> Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>
> Cc: Michal Marek <mmarek@suse.cz>
> CC: Sam Ravnborg <sam@ravnborg.org>

Applied to kbuild.git#kbuild, thanks.

Michal
