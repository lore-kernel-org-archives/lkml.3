Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932312AbaIWQuB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 12:50:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:34239 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbaIWQuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 12:50:00 -0400
Message-ID: <5421A4B4.1040604@infradead.org>
Date: Tue, 23 Sep 2014 09:49:56 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Valentin Rothberg <valentinrothberg@gmail.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
CC: pebolle@tiscali.nl
Subject: Re: [PATCH] lib: rename TEST_MODULE to TEST_LKM
References: <1411455508-11958-1-git-send-email-valentinrothberg@gmail.com>
In-Reply-To: <1411455508-11958-1-git-send-email-valentinrothberg@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/14 23:58, Valentin Rothberg wrote:
> The "_MODULE" suffix is reserved for tristates compiled as
> loadable kernel modules (LKM). The "TEST_MODULE" feature thereby

Is that documented anywhere?

Was this causing some kind of problem or error?  Please tell us what that was if so.


> violates this convention. The feature is used to compile the
> lib/test_module.c kernel module.
> 
> This patch renames the feature and its reference in a Makefile
> to "TEST_LKM", which still expresses the test of a LKM.
> 
> Signed-off-by: Valentin Rothberg <valentinrothberg@gmail.com>
> ---
>  lib/Kconfig.debug | 2 +-
>  lib/Makefile      | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 07c2832..db91c97 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -1627,7 +1627,7 @@ config DMA_API_DEBUG
>  
>  	  If unsure, say N.
>  
> -config TEST_MODULE
> +config TEST_LKM
>  	tristate "Test module loading with 'hello world' module"
>  	default n
>  	depends on m
> diff --git a/lib/Makefile b/lib/Makefile
> index d6b4bc4..382437a 100644
> --- a/lib/Makefile
> +++ b/lib/Makefile
> @@ -31,7 +31,7 @@ obj-y += string_helpers.o
>  obj-$(CONFIG_TEST_STRING_HELPERS) += test-string_helpers.o
>  obj-y += kstrtox.o
>  obj-$(CONFIG_TEST_KSTRTOX) += test-kstrtox.o
> -obj-$(CONFIG_TEST_MODULE) += test_module.o
> +obj-$(CONFIG_TEST_LKM) += test_module.o
>  obj-$(CONFIG_TEST_USER_COPY) += test_user_copy.o
>  obj-$(CONFIG_TEST_BPF) += test_bpf.o
>  obj-$(CONFIG_TEST_FIRMWARE) += test_firmware.o
> 


-- 
~Randy
