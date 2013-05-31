Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810Ab3EaOlz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 10:41:55 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:47155 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755335Ab3EaOls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 10:41:48 -0400
MIME-Version: 1.0
In-Reply-To: <1365729154-24240-1-git-send-email-gheorghiuandru@gmail.com>
References: <1365729154-24240-1-git-send-email-gheorghiuandru@gmail.com>
Date: Fri, 31 May 2013 17:41:48 +0300
Message-ID: <CAG8Ei1q7JMRAdeohptkY3eg=AH8CaGtRg4dP_QwZ4Ru9sFhNYQ@mail.gmail.com>
Subject: Re: [PATCH] lib: digsig: Use ERR_CAST function
From: Dmitry Kasatkin <dmitry.s.kasatkin@gmail.com>
To: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Cc: James Morris <james.l.morris@oracle.com>,
        YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>,
        linux-kernel@vger.kernel.org,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry. I am not at @intel.com any more. Did not see it.
I will use my private email for now..

Yes. This was bothering my eye for quite a while...

- Dmitry

On Fri, Apr 12, 2013 at 4:12 AM, Alexandru Gheorghiu
<gheorghiuandru@gmail.com> wrote:
>
> Use ERR_CAST function instead of ERR_PTR and PTR_ERR.
> Patch found using coccinelle.
>
> Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
> ---
>  lib/digsig.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/lib/digsig.c b/lib/digsig.c
> index 2f31e6a..8793aed 100644
> --- a/lib/digsig.c
> +++ b/lib/digsig.c
> @@ -209,7 +209,7 @@ int digsig_verify(struct key *keyring, const char
> *sig, int siglen,
>                 kref = keyring_search(make_key_ref(keyring, 1UL),
>                                                 &key_type_user, name);
>                 if (IS_ERR(kref))
> -                       key = ERR_PTR(PTR_ERR(kref));
> +                       key = ERR_CAST(kref);
>                 else
>                         key = key_ref_to_ptr(kref);
>         } else {
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
