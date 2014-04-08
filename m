Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325AbaDHPHB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 11:07:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35759 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757267AbaDHPHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 11:07:00 -0400
Message-ID: <53441091.2060706@suse.cz>
Date: Tue, 08 Apr 2014 17:06:57 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Masahiro Yamada <yamada.m@jp.panasonic.com>
CC: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] Kbuild: move extra gcc check flags to the top Makefile
References: <1396840939-24512-1-git-send-email-yamada.m@jp.panasonic.com>
In-Reply-To: <1396840939-24512-1-git-send-email-yamada.m@jp.panasonic.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-04-07 05:22, Masahiro Yamada wrote:
> If W=... given to the command line, extra gcc check flags are added
> to KBUILD_CFLAGS.
> 
> If we have such code in scripts/Makefile.build, the same flags are
> added to KBUILD_CFLAGS multiple times becuase scripts/Makefile.build
> is invoked every time Kbuild descends into the subdirectories.

Indeed. For three years, nobody has noticed that the gcc commandline is
growing with every subdirectory.

> 
> Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>
> ---
>  Makefile               | 51 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  scripts/Makefile.build | 51 --------------------------------------------------
>  2 files changed, 51 insertions(+), 51 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index 00a933b..6588a03 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -579,6 +579,57 @@ endif # $(dot-config)
>  # Defaults to vmlinux, but the arch makefile usually adds further targets
>  all: vmlinux
>  
> +#
> +# make W=... settings

I don't think it's a good idea to add this to the main Makefile. First
of all, this option

> +warning-1 += $(call cc-option, -Wunused-but-set-variable)

gets overridden by

KBUILD_CFLAGS += $(call cc-disable-warning, unused-but-set-variable)

couple of lines later. This is easily fixed by moving the whole block
down. However, the main Makefile is quite complex already, so please
move this to a new Makefile fragment in scripts/ and include this from
the main Makefile instead.

Thanks,
Michal
