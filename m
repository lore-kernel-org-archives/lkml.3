Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751698AbaGMTYI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 15:24:08 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:55173 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbaGMTX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 15:23:56 -0400
Message-ID: <53C2DCC6.4070209@infradead.org>
Date: Sun, 13 Jul 2014 12:23:50 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>, Michal Marek <mmarek@suse.cz>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
CC: lkml <linux-kernel@vger.kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        David Herrmann <dh.herrmann@googlemail.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 1/6] kbuild: add support for building userspace api programs
References: <20140713183636.GA17241@ravnborg.org> <1405276974-17323-1-git-send-email-sam@ravnborg.org>
In-Reply-To: <1405276974-17323-1-git-send-email-sam@ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sam,

On 07/13/14 11:42, Sam Ravnborg wrote:
> 
> diff --git a/Documentation/kbuild/makefiles.txt b/Documentation/kbuild/makefiles.txt
> index c600e2f..713ea10 100644
> --- a/Documentation/kbuild/makefiles.txt
> +++ b/Documentation/kbuild/makefiles.txt
> @@ -761,7 +763,43 @@ Both possibilities are described in the following.
>  	like hostprogs-y. But only hostprogs-y is recommended to be used
>  	when no CONFIG symbols are involved.
>  
> -=== 5 Kbuild clean infrastructure
> +=== 5 Samples support (uapiprogs-y)
> +
> +Kbuild support building sample modules and sample binaries.

          supports

> +To build sample modules the existing infrastructure is used, but
> +to build sample binaries kbuild adds dedicated suppport.
> +
> +The sample binaries are build for the same host and bit-size as the kernel.

                           built

> +
> +The samples may demonstrate facilities not yet available
> +in the installed libc therefore they are build so they include

                    libc;                   built

> +headers from the exported uapi headers before the libc headers
> +are searched.
> +
> +The sample binaries are usually placed in sub-directories
> +below samples/ and specified in samples/Makefile.
> +The directories containing sample binaries are listed using
> +subdir-y - usually like this: subdir-$(CONFIG_SAMPLES) += dir
> +
> +The individual binaries may be defined as single .c file per binary
> +or several .c files for a single binary.
> +See the following examples.
> +
> +	Example:
> +		# samples/hid/Makefile
> +		uapiprogs-y := hid-example
> +
> +	This will compile hid-example.c and create an executable named hid-example.
> +
> +	Example:
> +		# samples/seccomp/Makefile
> +		uapiprogs-y := bpf-fancy
> +		bpf-fancy-y := bpf-fancy.o bpf-helper.o
> +
> +This will compile bpf-fancy.c and bpf-helper.c, and then link the executable
> +bpf-fancy, based on bpf-fancy.o bpf-helper.o.
> +
> +=== 6 Kbuild clean infrastructure
>  
>  "make clean" deletes most generated files in the obj tree where the kernel
>  is compiled. This includes generated files such as host programs.


-- 
~Randy
