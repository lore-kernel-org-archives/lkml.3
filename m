Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757170Ab3D2DTJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Apr 2013 23:19:09 -0400
Received: from ozlabs.org ([203.10.76.45]:60508 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756954Ab3D2DSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Apr 2013 23:18:21 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Tom Rini <trini@ti.com>, linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] modpost.c: Add .text.unlikely to TEXT_SECTIONS
In-Reply-To: <1366842363-7513-1-git-send-email-trini@ti.com>
References: <1366842363-7513-1-git-send-email-trini@ti.com>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 29 Apr 2013 12:29:12 +0930
Message-ID: <87sj2aca9r.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tom Rini <trini@ti.com> writes:

> Recent gcc's may place functions into the .text.unlikely section and we
> need to check this section as well for section mismatches now otherwise
> we may have false negatives for this test.

Hmm, I don't think it's all that recent, is it?  I can find it back to
gcc 4.0.4:

`-freorder-functions'
     Reorder functions in the object file in order to improve code
     locality.  This is implemented by using special subsections
     `.text.hot' for most frequently executed functions and
     `.text.unlikely' for unlikely executed functions.  Reordering is
     done by the linker so object file format must support named
     sections and linker must place them in a reasonable way.

     Also profile feedback must be available in to make this option
     effective.  See `-fprofile-arcs' for details.

     Enabled at levels `-O2', `-O3', `-Os'.

The comment is the same in in gcc 4.7.

So is your real issue that this section is generated with
-fprofile-arcs, or has something changed with gcc 4.8, or...?

Thanks,
Rusty.

> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-kbuild@vger.kernel.org
> Signed-off-by: Tom Rini <trini@ti.com>
> ---
>  scripts/mod/modpost.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
> index ff36c50..13ff12f 100644
> --- a/scripts/mod/modpost.c
> +++ b/scripts/mod/modpost.c
> @@ -880,7 +880,7 @@ static void check_section(const char *modname, struct elf_info *elf,
>  #define ALL_EXIT_SECTIONS EXIT_SECTIONS, ALL_XXXEXIT_SECTIONS
>  
>  #define DATA_SECTIONS ".data$", ".data.rel$"
> -#define TEXT_SECTIONS ".text$"
> +#define TEXT_SECTIONS ".text$", ".text.unlikely$"
>  
>  #define INIT_SECTIONS      ".init.*"
>  #define CPU_INIT_SECTIONS  ".cpuinit.*"
> -- 
> 1.7.9.5
