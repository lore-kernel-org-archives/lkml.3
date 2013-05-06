Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526Ab3EFJr5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 05:47:57 -0400
Received: from mail.skyhub.de ([78.46.96.112]:34918 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752700Ab3EFJrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 05:47:55 -0400
Date: Mon, 6 May 2013 11:51:24 +0200
From: Borislav Petkov <bp@alien8.de>
To: Kyungsik Lee <kyungsik.lee@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Marek <mmarek@suse.cz>,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        x86@kernel.org, celinux-dev@lists.celinuxforum.org,
        linux-arm-kernel@lists.infradead.org, hyojun.im@lge.com,
        chan.jeong@lge.com, raphael.andy.lee@gmail.com,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <rmk@arm.linux.org.uk>,
        Florian Fainelli <florian@openwrt.org>,
        Yann Collet <yann.collet.73@gmail.com>,
        Chanho Min <chanho.min@lge.com>
Subject: Re: [PATCH -next 2/2] kbuild: fix for updated LZ4 tool with the new
 streaming format
Message-ID: <20130506095124.GA22041@pd.tnic>
References: <1367829775-4434-1-git-send-email-kyungsik.lee@lge.com>
 <1367829775-4434-2-git-send-email-kyungsik.lee@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1367829775-4434-2-git-send-email-kyungsik.lee@lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 06, 2013 at 05:42:55PM +0900, Kyungsik Lee wrote:
> LZ4 has been updated with LZ4 Streaming Format specification(v1.3).
> lz4demo is replaced by lz4c. lz4c supports both the new streaming and
> legacy format with -l option.
> 
> This patch makes use of lz4c to support legacy format which is
> used for LZ4 De/compression in the linux kernel.
> 
> Link: https://code.google.com/p/lz4/source/checkout
> Signed-off-by: Kyungsik Lee <kyungsik.lee@lge.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Russell King <rmk@arm.linux.org.uk>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Florian Fainelli <florian@openwrt.org>
> Cc: Yann Collet <yann.collet.73@gmail.com>
> Cc: Chanho Min <chanho.min@lge.com>
> ---
>  scripts/Makefile.lib | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
> index a0ab6d7..c9bfbb0 100644
> --- a/scripts/Makefile.lib
> +++ b/scripts/Makefile.lib
> @@ -313,7 +313,7 @@ cmd_lzo = (cat $(filter-out FORCE,$^) | \
>  
>  quiet_cmd_lz4 = LZ4     $@
>  cmd_lz4 = (cat $(filter-out FORCE,$^) | \
> -	lz4demo -c1 stdin stdout && $(call size_append, $(filter-out FORCE,$^))) > $@ || \
> +	lz4c -l -c1 stdin stdout && $(call size_append, $(filter-out FORCE,$^))) > $@ || \

You probably want to check for the presence of lz4c on the system and
bail with an informative message if absent.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
