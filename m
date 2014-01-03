Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015AbaACRLD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 12:11:03 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33399 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752488AbaACRLA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 12:11:00 -0500
Message-ID: <52C6EF1C.9070809@suse.cz>
Date: Fri, 03 Jan 2014 18:10:52 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>, LKML <linux-kernel@vger.kernel.org>
CC: linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] scripts/gcc-version.sh: handle CC="gcc -m32"
References: <87d2l5ji06.fsf@rustcorp.com.au>
In-Reply-To: <87d2l5ji06.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-12-10 08:13, Rusty Russell wrote:
> Without it we get ugly warnings (though build still succeeds).
> 
> $ make -j8 CC="gcc -m32"
> In file included from <command-line>:0:0:
> /usr/include/stdc-predef.h:30:26: fatal error: bits/predefs.h: No such file or directory
>  #include <bits/predefs.h>
>                           ^
> compilation terminated.
> In file included from <command-line>:0:0:
> /usr/include/stdc-predef.h:30:26: fatal error: bits/predefs.h: No such file or directory
>  #include <bits/predefs.h>
>                           ^
> compilation terminated.
> /home/rusty/devel/kernel/linux/scripts/gcc-version.sh: line 31: printf: #: invalid number
> /home/rusty/devel/kernel/linux/scripts/gcc-version.sh: line 31: printf: #: invalid number
> /bin/sh: 1: [: 0001: unexpected operator
>   CHK     include/config/kernel.release
>   CHK     include/generated/uapi/linux/version.h
> make[1]: Nothing to be done for `all'.
> ...
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> 
> diff --git a/scripts/gcc-version.sh b/scripts/gcc-version.sh
> index 7f2126df91f2..d48b0cbaf246 100644
> --- a/scripts/gcc-version.sh
> +++ b/scripts/gcc-version.sh
> @@ -14,7 +14,7 @@ if [ "$1" = "-p" ] ; then
>  	shift;
>  fi
>  
> -compiler="$*"
> +compiler="$1"

But this will break things like CC="ccache gcc". Your problem is that
you do not have the 32bit glibc headers, right? How about invoking the
compiler with $NOSTDINC_FLAGS, so that it does not depend on any
userspace stuff?

Thanks,
Michal
