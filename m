Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684Ab3EYObO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 10:31:14 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:45882 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756373Ab3EYObJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 10:31:09 -0400
MIME-Version: 1.0
In-Reply-To: <1369473168-13456-1-git-send-email-toralf.foerster@gmx.de>
References: <1369473168-13456-1-git-send-email-toralf.foerster@gmx.de>
Date: Sat, 25 May 2013 16:31:08 +0200
Message-ID: <CAFLxGvyLxpuaF9wONQ+ngc_EQwyFPP0iC85OeGo9HT3_Jt-RvA@mail.gmail.com>
Subject: Re: [PATCH] kernel/auditfilter.c: fix compiler warning about decimal constant
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 25, 2013 at 11:12 AM, Toralf Förster <toralf.foerster@gmx.de> wrote:
> fixes
>
>   CC      kernel/auditfilter.o
>   kernel/auditfilter.c: In function ‘audit_data_to_entry’:
>   kernel/auditfilter.c:426:3: warning: this decimal constant is unsigned
>   only in ISO C90 [enabled by default]
>
> Signed-off-by: Toralf Förster <toralf.foerster@gmx.de>
> ---
>  kernel/auditfilter.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
> index 6bd4a90..0ee9eff 100644
> --- a/kernel/auditfilter.c
> +++ b/kernel/auditfilter.c
> @@ -423,7 +423,7 @@ static struct audit_entry *audit_data_to_entry(struct audit_rule_data *data,
>                 f->lsm_rule = NULL;
>
>                 /* Support legacy tests for a valid loginuid */
> -               if ((f->type == AUDIT_LOGINUID) && (f->val == 4294967295)) {
> +               if ((f->type == AUDIT_LOGINUID) && (f->val == 4294967295U)) {

Why not UINT_MAX?

>                         f->type = AUDIT_LOGINUID_SET;
>                         f->val = 0;
>                 }
> --
> 1.8.1.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



--
Thanks,
//richard
