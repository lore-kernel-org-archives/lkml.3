Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741Ab3JQKOY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 06:14:24 -0400
Received: from mail-qe0-f42.google.com ([209.85.128.42]:45577 "EHLO
	mail-qe0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068Ab3JQKOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 06:14:23 -0400
MIME-Version: 1.0
In-Reply-To: <1381939056-27898-2-git-send-email-geyslan@gmail.com>
References: <1381939056-27898-1-git-send-email-geyslan@gmail.com>
	<1381939056-27898-2-git-send-email-geyslan@gmail.com>
Date: Thu, 17 Oct 2013 07:14:22 -0300
Message-ID: <CAGG-pURWKA9aBuaeE_q1TbGaa9wTigUMRjTpA613c+Xrh3Bz_g@mail.gmail.com>
Subject: Re: [PATCH] drivers: staging: dgap: Remove useless casting in dgap_parse.c
From: =?UTF-8?Q?Geyslan_Greg=C3=B3rio_Bem?= <geyslan@gmail.com>
To: Lidza Louina <lidza.louina@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-br <kernel-br@googlegroups.com>,
        "Geyslan G. Bem" <geyslan@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/10/16 Geyslan G. Bem <geyslan@gmail.com>:
> Casting (void *) value returned by kmalloc is useless
> as mentioned in Documentation/CodingStyle, Chap 14.
>
> Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
> ---
>  drivers/staging/dgap/dgap_parse.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/staging/dgap/dgap_parse.c b/drivers/staging/dgap/dgap_parse.c
> index 5497e6d..d41aa1c 100644
> --- a/drivers/staging/dgap/dgap_parse.c
> +++ b/drivers/staging/dgap/dgap_parse.c
> @@ -1013,7 +1013,7 @@ static void dgap_err(char *s)
>  static struct cnode *dgap_newnode(int t)
>  {
>         struct cnode *n;
> -       if ( (n = (struct cnode *) kmalloc(sizeof(struct cnode ), GFP_ATOMIC) ) != NULL) {
> +       if ( (n = kmalloc(sizeof(struct cnode ), GFP_ATOMIC) ) != NULL) {
>                 memset( (char *)n, 0, sizeof(struct cnode ) );
>                 n->type = t;
>         }
> --
> 1.8.4
>

Please, disregard this one. I have compared against staging-next and
noted that it was already done by Jingoo Han.

Regards.
Geyslan
