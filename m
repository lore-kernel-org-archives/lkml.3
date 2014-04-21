Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751707AbaDUEzY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 00:55:24 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:44888 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbaDUEzT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 00:55:19 -0400
MIME-Version: 1.0
In-Reply-To: <1397795756-23283-1-git-send-email-andi@firstfloor.org>
References: <1397795756-23283-1-git-send-email-andi@firstfloor.org>
Date: Mon, 21 Apr 2014 10:25:18 +0530
Message-ID: <CAKohpond9DbNqWHLi9ZdL0BJRwZjeDZcar7KYuC2kAvWZp96-Q@mail.gmail.com>
Subject: Re: [PATCH] Kbuild, lto: Avoid reported warning with strtoul
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: mmarek@suse.cz, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 April 2014 10:05, Andi Kleen <andi@firstfloor.org> wrote:
> From: Andi Kleen <ak@linux.intel.com>
>
> Apparently someone's C library declares strtoul with warn_unused_result.
> Cast to void to avoid the warning. Error handling is not useful here.

I just did a x86_64 compilation without a CROSS_COMPILE= option
(My .config also had a empty string) and so gcc must be used for it?

$ gcc --version
gcc (Ubuntu/Linaro 4.6.3-1ubuntu5) 4.6.3
Copyright (C) 2011 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

> Cc: Viresh Kumar <viresh.kumar@linaro.org>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  scripts/mod/modpost.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
> index 0663556..b9cf439 100644
> --- a/scripts/mod/modpost.c
> +++ b/scripts/mod/modpost.c
> @@ -1707,7 +1707,7 @@ static char *remove_dot(char *s)
>         int n = strcspn(s, ".");
>
>         if (n > 0 && s[n] != 0) {
> -               strtoul(s + n + 1, &end, 10);
> +               (void)strtoul(s + n + 1, &end, 10);

I tried this earlier before reporting and it still had the same problem :(
I tried it again just to cross check and still getting this:

scripts/mod/modpost.c: In function ‘remove_dot’:
scripts/mod/modpost.c:1710:3: warning: ignoring return value of
‘strtoul’, declared with attribute warn_unused_result
[-Wunused-result]
