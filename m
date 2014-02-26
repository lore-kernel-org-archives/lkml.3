Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407AbaBZU0o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 15:26:44 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:38978 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463AbaBZU0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 15:26:43 -0500
Date: Wed, 26 Feb 2014 12:26:34 -0800
From: Jeff Layton <jlayton@samba.org>
To: "Lorenz Bucher" <Lorenz.Bucher@gmx.de>
Cc: sfrench@samba.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cifs: connect: added option krb5mi which may allow
 package signing
Message-ID: <20140226122634.1190167e@corrin.poochiereds.net>
In-Reply-To: <trinity-7e911dab-5097-463a-ba4a-09935acbdc69-1393422407694@3capp-gmx-bs33>
References: <trinity-7e911dab-5097-463a-ba4a-09935acbdc69-1393422407694@3capp-gmx-bs33>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Feb 2014 14:46:47 +0100
"Lorenz Bucher" <Lorenz.Bucher@gmx.de> wrote:

> Solves an issue with dfs where servers using package signing are
> mixed with servers which don't use package signing.
> 
> Signed-off-by: Lorenz Bucher <lorenz.bucher@gmx.de>
> ---
>  fs/cifs/connect.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 56c152d..9d06dd8 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -1104,6 +1104,9 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
>                         if (!value || !*value) {
>                                 cERROR(1, "no security value specified");
>                                 continue;
> +                       } else if (strnicmp(value, "krb5mi", 6) == 0) {
> +                               vol->secFlg |= CIFSSEC_MAY_KRB5 | 
> +                                       CIFSSEC_MAY_SIGN;
>                         } else if (strnicmp(value, "krb5i", 5) == 0) {
>                                 vol->secFlg |= CIFSSEC_MAY_KRB5 |
>                                         CIFSSEC_MUST_SIGN;

This looks like it applies to a really old kernel. I think that problem
was what commit 0b7bc84000d71f3647ca33ab1bf5bd928535c846 was intended
to fix.

-- 
Jeff Layton <jlayton@samba.org>
