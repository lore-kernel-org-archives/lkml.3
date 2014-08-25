Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932545AbaHYNlA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 09:41:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50673 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932262AbaHYNk5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 09:40:57 -0400
Message-ID: <53FB3CE7.9060609@suse.cz>
Date: Mon, 25 Aug 2014 15:40:55 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Boaz Harrosh <boaz@plexistor.com>, Stable Tree <stable@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] Makefile: One last adjustment to relative paths
References: <53FAF8BF.3010008@plexistor.com>
In-Reply-To: <53FAF8BF.3010008@plexistor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-08-25 10:50, Boaz Harrosh wrote:
> the simple fix is to have "Entering directory" print full path.
> 
> [Stable needed for 3.16]
> CC: Stable Tree <stable@vger.kernel.org>
> Signed-off-by: Boaz Harrosh <boaz@plexistor.com>
> ---
>  Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Makefile b/Makefile
> index 6b27741..973c48f 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -178,7 +178,7 @@ $(filter-out _all sub-make $(CURDIR)/Makefile, $(MAKECMDGOALS)) _all: sub-make
>   quiet_echodir := @echo
>  silent_echodir := @:
>  sub-make: FORCE
> -	$($(quiet)echodir) "make[1]: Entering directory \`$(KBUILD_OUTPUT)'"
> +	$($(quiet)echodir) "make[1]: Entering directory \`$(CURDIR)/$(KBUILD_OUTPUT)'"

KBUILD_OUTPUT is converted to an absolute path a few lines earlier:

KBUILD_OUTPUT := $(shell mkdir -p $(KBUILD_OUTPUT) && cd $(KBUILD_OUTPUT) \
								&& /bin/pwd)

So I don't understand why are you getting a message with a relative
path. I get an absolute path as expected here:
$ mkdir aaa
$ make O=aaa defconfig
make[1]: Entering directory `/home/mmarek/linux-2.6/aaa'
...

Michal
