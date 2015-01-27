Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757457AbbA0Bg1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 20:36:27 -0500
Received: from casper.infradead.org ([85.118.1.10]:35408 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbbA0BgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 20:36:24 -0500
Message-ID: <54C6EB93.6080409@infradead.org>
Date: Mon, 26 Jan 2015 17:36:19 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>, Jonathan Corbet <corbet@lwn.net>
CC: linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] DocBook: Do not exceed argument list limit
References: <1422268277-5333-1-git-send-email-mmarek@suse.cz>
In-Reply-To: <1422268277-5333-1-git-send-email-mmarek@suse.cz>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding Mr. Corbet.

On 01/26/15 02:31, Michal Marek wrote:
> Use find + xargs to compress the generated manpages. Without this patch,
> the build can fail with
> 
>     gzip -f Documentation/DocBook/man/*.9
>     /bin/bash: /usr/bin/gzip: Argument list too long
> 
> This happened with qemu user mode emulation on aarch64.
> 
> Signed-off-by: Michal Marek <mmarek@suse.cz>
> ---
>  Documentation/DocBook/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/DocBook/Makefile b/Documentation/DocBook/Makefile
> index 9c7d92d..b6a6a2e 100644
> --- a/Documentation/DocBook/Makefile
> +++ b/Documentation/DocBook/Makefile
> @@ -56,7 +56,7 @@ htmldocs: $(HTML)
>  
>  MAN := $(patsubst %.xml, %.9, $(BOOKS))
>  mandocs: $(MAN)
> -	$(if $(wildcard $(obj)/man/*.9),gzip -f $(obj)/man/*.9)
> +	find $(obj)/man -name '*.9' | xargs gzip -f
>  
>  installmandocs: mandocs
>  	mkdir -p /usr/local/man/man9/
> 


-- 
~Randy
