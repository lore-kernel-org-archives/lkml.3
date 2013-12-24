Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758076Ab3LXBhG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 20:37:06 -0500
Received: from mail-ea0-f182.google.com ([209.85.215.182]:58601 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817Ab3LXBhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 20:37:03 -0500
MIME-Version: 1.0
In-Reply-To: <1387820970-6949-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1387820970-6949-1-git-send-email-ard.biesheuvel@linaro.org>
Date: Mon, 23 Dec 2013 17:37:00 -0800
X-Google-Sender-Auth: noc2mzBUoZe1bxsmEnMVmBrW4TQ
Message-ID: <CA+55aFwbrdgO_=LQ5=p2J=QmX_BmCvNbGGcxS0C0dKqocAkfYA@mail.gmail.com>
Subject: Re: [PATCH] auxvec.h: account for AT_HWCAP2 in AT_VECTOR_SIZE_BASE
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Michael Neuling <michael@neuling.org>,
        Nishanth Aravamudan <nacc@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please cc the guilty parties when sending patches like this.

Also, just out of interest, please describe how this bug affected
things. Did we overflow the saved_auxv[] array, or what? Also, how
does this change affect architectures that _don't_ have that
ELF_HWCAP2 thing, ie everything but powerpc?

Acks, people?

           Linus

On Mon, Dec 23, 2013 at 9:49 AM, Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
> Commit 2171364d1a92 (powerpc: Add HWCAP2 aux entry) introduced a new
> AT_ auxv entry type AT_HWCAP2 but failed to update AT_VECTOR_SIZE_BASE
> accordingly.
>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Fixes: 2171364d1a92 (powerpc: Add HWCAP2 aux entry)
> Cc: stable@vger.kernel.org
> ---
>
>  include/linux/auxvec.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/linux/auxvec.h b/include/linux/auxvec.h
> index 669fef5..3e0fbe4 100644
> --- a/include/linux/auxvec.h
> +++ b/include/linux/auxvec.h
> @@ -3,6 +3,6 @@
>
>  #include <uapi/linux/auxvec.h>
>
> -#define AT_VECTOR_SIZE_BASE 19 /* NEW_AUX_ENT entries in auxiliary table */
> +#define AT_VECTOR_SIZE_BASE 20 /* NEW_AUX_ENT entries in auxiliary table */
>    /* number of "#define AT_.*" above, minus {AT_NULL, AT_IGNORE, AT_NOTELF} */
>  #endif /* _LINUX_AUXVEC_H */
> --
> 1.8.3.2
>
