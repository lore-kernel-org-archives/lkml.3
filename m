Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545AbbAWWG4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 17:06:56 -0500
Received: from mail-vc0-f179.google.com ([209.85.220.179]:41811 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbbAWWGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 17:06:55 -0500
MIME-Version: 1.0
In-Reply-To: <1422050221-28345-1-git-send-email-holler@ahsoftware.de>
References: <1421976009-9819-1-git-send-email-holler@ahsoftware.de>
	<1422050221-28345-1-git-send-email-holler@ahsoftware.de>
Date: Fri, 23 Jan 2015 23:06:54 +0100
Message-ID: <CAFLxGvwQVKaB_MTpJ9LPNvY6bO_-_qCf7PYQuDrF4Q+4e3oUnQ@mail.gmail.com>
Subject: Re: [PATCH] modsign: overwrite keys with zero before deleting them
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Alexander Holler <holler@ahsoftware.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Michal Marek <mmarek@suse.cz>, David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 10:57 PM, Alexander Holler <holler@ahsoftware.de> wrote:
> This is for the more paranoid people, also it's
> questionable what paranoid nowadays means.

Isn't this complete useless when modern filesystems like btrfs or
storage devices like SSDs are used?

> Signed-off-by: Alexander Holler <holler@ahsoftware.de>
> ---
>  Makefile | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/Makefile b/Makefile
> index 7ad66de..590ff53 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1132,7 +1132,9 @@ ifeq ($(CONFIG_MODULE_SIG_THROW_AWAY), y)
>         @echo "###"
>         @echo "### Deleting key used to sign modules."
>         @echo "###"
> +       @dd status=none if=/dev/zero of=./signing_key.priv bs=4096 count=1
>         @rm ./signing_key.priv
> +       @dd status=none if=/dev/zero of=./signing_key.x509 bs=4096 count=1
>         @rm ./signing_key.x509
>  endif
>
> --
> 2.0.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Thanks,
//richard
