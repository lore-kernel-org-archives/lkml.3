Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460AbaBRS0v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 13:26:51 -0500
Received: from mail-oa0-f51.google.com ([209.85.219.51]:46144 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbaBRS0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 13:26:49 -0500
MIME-Version: 1.0
In-Reply-To: <1392630167-26317-1-git-send-email-fathi.boudra@linaro.org>
References: <1392630167-26317-1-git-send-email-fathi.boudra@linaro.org>
Date: Tue, 18 Feb 2014 10:26:49 -0800
X-Google-Sender-Auth: kcMsr2-OLWr6KaCe0DFGxBsYeQE
Message-ID: <CAGXu5jJLy1X3_KYhAD+n80dYTRte3B=214k9PQvU8kBNCT=Y5w@mail.gmail.com>
Subject: Re: [PATCH] Makefile: fix extra parenthesis typo when
 CC_STACKPROTECTOR_REGULAR is enabled
From: Kees Cook <keescook@chromium.org>
To: Fathi Boudra <fathi.boudra@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Marek <mmarek@suse.cz>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 1:42 AM, Fathi Boudra <fathi.boudra@linaro.org> wrote:
> extra parenthesis typo introduced in commit 19952a9203 is causing
> the following error when CONFIG_CC_STACKPROTECTOR_REGULAR is enabled:
> Makefile:608: Cannot use CONFIG_CC_STACKPROTECTOR: -fstack-protector not
> supported by compiler
> Makefile:608: *** missing separator.  Stop.

Yikes! I have no idea how that snuck in. :( Thank you for noticing and
fixing this.

> Signed-off-by: Fathi Boudra <fathi.boudra@linaro.org>

Acked-by: Kees Cook <keescook@chromium.org>

Thanks!

-Kees

> ---
>  Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/Makefile b/Makefile
> index 893d6f0..eeaf3e7 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -606,7 +606,7 @@ ifdef CONFIG_CC_STACKPROTECTOR_REGULAR
>    stackp-flag := -fstack-protector
>    ifeq ($(call cc-option, $(stackp-flag)),)
>      $(warning Cannot use CONFIG_CC_STACKPROTECTOR: \
> -             -fstack-protector not supported by compiler))
> +             -fstack-protector not supported by compiler)
>    endif
>  else ifdef CONFIG_CC_STACKPROTECTOR_STRONG
>    stackp-flag := -fstack-protector-strong
> --
> 1.8.1.2
>



-- 
Kees Cook
Chrome OS Security
