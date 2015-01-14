Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751276AbbANFq1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 00:46:27 -0500
Received: from mail-oi0-f48.google.com ([209.85.218.48]:50723 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbbANFqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 00:46:25 -0500
MIME-Version: 1.0
In-Reply-To: <35FD53F367049845BC99AC72306C23D103EDAF89E1A3@CNBJMBX05.corpusers.net>
References: <35FD53F367049845BC99AC72306C23D103EDAF89E1A3@CNBJMBX05.corpusers.net>
Date: Tue, 13 Jan 2015 21:46:25 -0800
X-Google-Sender-Auth: qdcPsmWJDOnY9uASe3P9VseTyWU
Message-ID: <CAGXu5jKz_ZT=FWg5MuFh1sz3uXx0mHEc_zNu=OSZi7noHZZ7oA@mail.gmail.com>
Subject: Re: [RFC] export module parameters even the permission is zero
From: Kees Cook <keescook@chromium.org>
To: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
Cc: "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "jani.nikula@intel.com" <jani.nikula@intel.com>,
        "hch@infradead.org" <hch@infradead.org>, "hare@suse.de" <hare@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 6:16 PM, Wang, Yalin <Yalin.Wang@sonymobile.com> wrote:
> This patch make sure to export module parameters even the permission
> is zero, this is useful for some platforms like Android,
> the init process can change the parameter mode/owner by
> chmod/chown during bootup
>
> Signed-off-by: Yalin Wang <yalin.wang@sonymobile.com>

NAK. No sorry, these parameters are explicitly being removed from
sysfs by the various things that use perm==0. This would potentially
expose sensitive values to sysfs. If a value should be exposed, the
perm argument on the specific thing should be changed.

-Kees

> ---
>  kernel/params.c | 6 ------
>  1 file changed, 6 deletions(-)
>
> diff --git a/kernel/params.c b/kernel/params.c
> index bd65d136..aa80c04 100644
> --- a/kernel/params.c
> +++ b/kernel/params.c
> @@ -607,9 +607,6 @@ static __modinit int add_sysfs_param(struct module_kobject *mk,
>         struct attribute **new_attrs;
>         unsigned int i;
>
> -       /* We don't bother calling this with invisible parameters. */
> -       BUG_ON(!kp->perm);
> -
>         if (!mk->mp) {
>                 /* First allocation. */
>                 mk->mp = kzalloc(sizeof(*mk->mp), GFP_KERNEL);
> @@ -812,9 +809,6 @@ static void __init param_sysfs_builtin(void)
>         for (kp = __start___param; kp < __stop___param; kp++) {
>                 char *dot;
>
> -               if (kp->perm == 0)
> -                       continue;
> -
>                 dot = strchr(kp->name, '.');
>                 if (!dot) {
>                         /* This happens for core_param() */
> --
> 2.1.3



-- 
Kees Cook
Chrome OS Security
