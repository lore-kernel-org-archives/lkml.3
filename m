Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785AbaAVJqL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 04:46:11 -0500
Received: from mail-we0-f176.google.com ([74.125.82.176]:48648 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698AbaAVJqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 04:46:08 -0500
MIME-Version: 1.0
In-Reply-To: <1390339396-3479-2-git-send-email-paul.gortmaker@windriver.com>
References: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
	<1390339396-3479-2-git-send-email-paul.gortmaker@windriver.com>
Date: Wed, 22 Jan 2014 04:46:06 -0500
Message-ID: <CAP=VYLqEBc40AoLZ_V1XxG4PrsweSwdzRf7et5=3Q4yJricYJQ@mail.gmail.com>
Subject: Re: [PATCH 01/73] init: delete the __cpuinit related stubs
From: Paul Gortmaker <paul.gortmaker@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, Paul Gortmaker <paul.gortmaker@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/21/14, Paul Gortmaker <paul.gortmaker@windriver.com> wrote:
> The __cpuinit support was removed several releases ago.  People
> have had a chance to update their out of tree code, so now we
> remove the no-op stubs.
>
> Also delete the mention of __cpuinitdata from the tag script.
>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> ---
>  include/linux/init.h | 11 -----------
>  scripts/tags.sh      |  2 +-
>  2 files changed, 1 insertion(+), 12 deletions(-)
>  mode change 100755 => 100644 scripts

Odd.  I definitely did not chmod -x this file manually.
Wonder how that happened?  Will fix...

Paul.
--

>
> diff --git a/include/linux/init.h b/include/linux/init.h
> index e168880..f693cc3 100644
> --- a/include/linux/init.h
> +++ b/include/linux/init.h
> @@ -91,14 +91,6 @@
>
>  #define __exit          __section(.exit.text) __exitused __cold notrace
>
> -/* temporary, until all users are removed */
> -#define __cpuinit
> -#define __cpuinitdata
> -#define __cpuinitconst
> -#define __cpuexit
> -#define __cpuexitdata
> -#define __cpuexitconst
> -
>  /* Used for MEMORY_HOTPLUG */
>  #define __meminit        __section(.meminit.text) __cold notrace
>  #define __meminitdata    __section(.meminit.data)
> @@ -116,9 +108,6 @@
>  #define __INITRODATA	.section	".init.rodata","a",%progbits
>  #define __FINITDATA	.previous
>
> -/* temporary, until all users are removed */
> -#define __CPUINIT
> -
>  #define __MEMINIT        .section	".meminit.text", "ax"
>  #define __MEMINITDATA    .section	".meminit.data", "aw"
>  #define __MEMINITRODATA  .section	".meminit.rodata", "a"
> diff --git a/scripts/tags.sh b/scripts/tags.sh
> old mode 100755
> new mode 100644
> index 58c4559..78382c2
> --- a/scripts/tags.sh
> +++ b/scripts/tags.sh
> @@ -150,7 +150,7 @@ exuberant()
>  {
>  	all_target_sources | xargs $1 -a                        \
>  	-I __initdata,__exitdata,__initconst,			\
> -	-I __cpuinitdata,__initdata_memblock			\
> +	-I __initdata_memblock					\
>  	-I __refdata,__attribute,__maybe_unused,__always_unused \
>  	-I __acquires,__releases,__deprecated			\
>  	-I __read_mostly,__aligned,____cacheline_aligned        \
> --
> 1.8.4.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arch" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
