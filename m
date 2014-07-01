Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441AbaGAKMj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 06:12:39 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49737 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751417AbaGAKMU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 06:12:20 -0400
Date: Tue, 1 Jul 2014 12:12:14 +0200
From: Borislav Petkov <bp@alien8.de>
To: behanw@converseincode.com
Cc: mmarek@suse.cz, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        dl9pf@gmx.de, pageexec@freemail.hu, mcharleb@gmail.com
Subject: Re: [PATCH] kbuild, LLVMLinux: only use warnings when using clang
Message-ID: <20140701101214.GA14882@pd.tnic>
References: <20140629201308.GC12943@pd.tnic>
 <1404175346-12330-1-git-send-email-behanw@converseincode.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1404175346-12330-1-git-send-email-behanw@converseincode.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 05:42:26PM -0700, behanw@converseincode.com wrote:
> From: Behan Webster <behanw@converseincode.com>
> 
> Only consider clang warnings in Kbuild when using the clang compiler.
> 
> Signed-off-by: Behan Webster <behanw@converseincode.com>
> ---
>  scripts/Makefile.extrawarn | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/scripts/Makefile.extrawarn b/scripts/Makefile.extrawarn
> index 6564350..e350127 100644
> --- a/scripts/Makefile.extrawarn
> +++ b/scripts/Makefile.extrawarn
> @@ -26,7 +26,7 @@ warning-1 += $(call cc-option, -Wmissing-include-dirs)
>  warning-1 += $(call cc-option, -Wunused-but-set-variable)
>  warning-1 += $(call cc-disable-warning, missing-field-initializers)
>  
> -# Clang
> +ifeq ($(COMPILER),clang)
>  warning-1 += $(call cc-disable-warning, initializer-overrides)
>  warning-1 += $(call cc-disable-warning, unused-value)
>  warning-1 += $(call cc-disable-warning, format)
> @@ -35,6 +35,7 @@ warning-1 += $(call cc-disable-warning, sign-compare)
>  warning-1 += $(call cc-disable-warning, format-zero-length)
>  warning-1 += $(call cc-disable-warning, uninitialized)
>  warning-1 += $(call cc-option, -fcatch-undefined-behavior)
> +endif

Ok, just to make sure I understand that whole use case correctly:

The disabling of those warnings is really intended for the case where
people build the kernel with "W=1" on the make cmdline *and* clang?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
