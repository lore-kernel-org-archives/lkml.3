Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756344AbaAGCVy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 21:21:54 -0500
Received: from mail-ve0-f171.google.com ([209.85.128.171]:56556 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755631AbaAGCVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 21:21:53 -0500
MIME-Version: 1.0
In-Reply-To: <1386773661-921-1-git-send-email-ethan.kernel@gmail.com>
References: <1386773661-921-1-git-send-email-ethan.kernel@gmail.com>
Date: Tue, 7 Jan 2014 10:21:51 +0800
Message-ID: <CABawtvPt9V_2=KxOGetUCVeatJVcD-uJqs9c6cUzOc2uZCqpYg@mail.gmail.com>
Subject: Re: [PATCH] sparc: replace __GFP_NOFAIL with GFP_ATOMIC in mdesc_kmalloc()
From: Ethan Zhao <ethan.kernel@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: LKML <linux-kernel@vger.kernel.org>, sparclinux@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cc sparclinux@vger.kernel.org

On Wed, Dec 11, 2013 at 10:54 PM, Ethan Zhao <ethan.kernel@gmail.com> wrote:
> Has kmalloc() failure checking there, so it is unnecessary to allocate with
> __GFP_NOFAIL flag that might block forever.
>
> Signed-off-by: Ethan Zhao <ethan.kernel@gmail.com>
> ---
>  arch/sparc/kernel/mdesc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/sparc/kernel/mdesc.c b/arch/sparc/kernel/mdesc.c
> index b90bf23..e8d678c 100644
> --- a/arch/sparc/kernel/mdesc.c
> +++ b/arch/sparc/kernel/mdesc.c
> @@ -136,7 +136,7 @@ static struct mdesc_handle *mdesc_kmalloc(unsigned int mdesc_size)
>                        sizeof(struct mdesc_hdr) +
>                        mdesc_size);
>
> -       base = kmalloc(handle_size + 15, GFP_KERNEL | __GFP_NOFAIL);
> +       base = kmalloc(handle_size + 15, GFP_KERNEL | GFP_ATOMIC);
>         if (base) {
>                 struct mdesc_handle *hp;
>                 unsigned long addr;
> --
> 1.8.3.4 (Apple Git-47)
>
