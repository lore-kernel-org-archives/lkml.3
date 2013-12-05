Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623Ab3LEMp3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 07:45:29 -0500
Received: from mail-ve0-f172.google.com ([209.85.128.172]:49608 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753534Ab3LEMp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 07:45:27 -0500
MIME-Version: 1.0
In-Reply-To: <20131205083430.32632.11103.stgit@buzz>
References: <20131205083424.32632.51618.stgit@buzz>
	<20131205083430.32632.11103.stgit@buzz>
Date: Thu, 5 Dec 2013 13:45:26 +0100
Message-ID: <CAFrcx1kCAjoMxBeqaO+iS2CGzX6omuW1reL636Lyj=bg5DB1Rg@mail.gmail.com>
Subject: Re: [PATCH 2/2] ARM: fix framepointer check in unwind_frame
From: Jean Pihet <jean.pihet@linaro.org>
To: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Will Deacon <will.deacon@arm.com>,
        Vyacheslav Tyrtov <v.tyrtov@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 December 2013 09:34, Konstantin Khlebnikov
<k.khlebnikov@samsung.com> wrote:
> This patch fixes corner case when (fp + 4) overflows unsigned long,
> for example: fp = 0xFFFFFFFF -> fp + 4 == 3.
>
> Signed-off-by: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
> ---
>  arch/arm/kernel/stacktrace.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm/kernel/stacktrace.c b/arch/arm/kernel/stacktrace.c
> index 00f79e5..af4e8c8 100644
> --- a/arch/arm/kernel/stacktrace.c
> +++ b/arch/arm/kernel/stacktrace.c
> @@ -31,7 +31,7 @@ int notrace unwind_frame(struct stackframe *frame)
>         high = ALIGN(low, THREAD_SIZE);
>
>         /* check current frame pointer is within bounds */
> -       if (fp < (low + 12) || fp + 4 >= high)
> +       if (fp < low + 12 || fp > high - 4)
Shouldn't that use the '>=' comparison?

Jean
>                 return -EINVAL;
>
>         /* restore the registers from the stack frame */
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
