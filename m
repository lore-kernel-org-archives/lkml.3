Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003Ab3KDVzg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 16:55:36 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:64275 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753697Ab3KDVze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 16:55:34 -0500
Message-ID: <527817CF.7020304@gmail.com>
Date: Tue, 05 Nov 2013 08:55:27 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Frank Haverkamp <haver@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
CC: arnd@arndb.de, gregkh@linuxfoundation.org, cody@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, utz.bacher@de.ibm.com, mmarek@suse.cz,
        jsvogt@de.ibm.com, MIJUNG@de.ibm.com, cascardo@linux.vnet.ibm.com,
        michael@ibmra.de
Subject: Re: [PATCH 2/9] GenWQE: Remove option to select name
References: <1383584889-21594-1-git-send-email-haver@linux.vnet.ibm.com> <1383584889-21594-3-git-send-email-haver@linux.vnet.ibm.com>
In-Reply-To: <1383584889-21594-3-git-send-email-haver@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/13 04:08, Frank Haverkamp wrote:
> Selecting interface names via configuration option is obsolete.

Don't do this. You are adding completely new code, so there is no reason
to post a patch full of code that is known to be incorrect, followed by
a set of patches fixing things. Just post the correct code to start
with. This makes the git history cleaner, and makes the code easier to
review.

You can use tools like git interactive rebase to split your work into
multiple patches. It should be quite easy for this because you mostly
just want to break down things to the file level, so even:

  git reset --soft <your-first-commit>

and then manually staging and commiting things from there would probably
be enough. You can use git add --interactive to stage individual file
hunks if you want to break things down further.

~Ryan

> 
> Signed-off-by: Frank Haverkamp <haver@linux.vnet.ibm.com>
> ---
>  drivers/misc/genwqe/Kconfig        |   14 ++------------
>  include/linux/genwqe/genwqe_card.h |    6 +-----
>  2 files changed, 3 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/misc/genwqe/Kconfig b/drivers/misc/genwqe/Kconfig
> index bbf137d..6069d8c 100644
> --- a/drivers/misc/genwqe/Kconfig
> +++ b/drivers/misc/genwqe/Kconfig
> @@ -9,15 +9,5 @@ menuconfig GENWQE
>  	default n
>  	help
>  	  Enables PCIe card driver for IBM GenWQE accelerators.
> -          The user-space interface is described in
> -          include/linux/genwqe/genwqe_card.h.
> -
> -if GENWQE
> -
> -config GENWQE_DEVNAME
> -        string "Name for sysfs and device nodes"
> -	default "genwqe"
> -        help
> -          Select alternate name for sysfs and device nodes.
> -
> -endif
> +	  The user-space interface is described in
> +	  include/linux/genwqe/genwqe_card.h.
> diff --git a/include/linux/genwqe/genwqe_card.h b/include/linux/genwqe/genwqe_card.h
> index 2c33db1..ffed142 100644
> --- a/include/linux/genwqe/genwqe_card.h
> +++ b/include/linux/genwqe/genwqe_card.h
> @@ -41,11 +41,7 @@
>  #endif
>  
>  /* Basename of sysfs, debugfs and /dev interfaces */
> -#if defined(CONFIG_GENWQE_DEVNAME)
> -#  define GENWQE_DEVNAME CONFIG_GENWQE_DEVNAME
> -#else
> -#  define GENWQE_DEVNAME "genwqe"
> -#endif
> +#define GENWQE_DEVNAME "genwqe"
>  
>  #define GENWQE_TYPE_ALTERA_230		0x00 /* GenWQE4 Stratix-IV-230 */
>  #define GENWQE_TYPE_ALTERA_530		0x01 /* GenWQE4 Stratix-IV-530 */
> 

