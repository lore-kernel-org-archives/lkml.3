Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004AbaB0JNV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 04:13:21 -0500
Received: from mout.gmx.net ([212.227.15.19]:63349 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750907AbaB0JNR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 04:13:17 -0500
MIME-Version: 1.0
Message-ID: <trinity-0877060f-29cb-4f1f-885e-f0d1c09a0a31-1393492393926@3capp-gmx-bs47>
From: "Lorenz Bucher" <Lorenz.Bucher@gmx.de>
To: "Jeff Layton" <jlayton@samba.org>
Cc: sfrench@samba.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Subject: Aw: Re: [PATCH] cifs: connect: added option krb5mi which may allow
 package signing
Content-Type: text/plain; charset=UTF-8
Date: Thu, 27 Feb 2014 10:13:14 +0100
Importance: normal
Sensitivity: Normal
In-Reply-To: <20140226122634.1190167e@corrin.poochiereds.net>
References: <trinity-7e911dab-5097-463a-ba4a-09935acbdc69-1393422407694@3capp-gmx-bs33>,
 <20140226122634.1190167e@corrin.poochiereds.net>
Content-Transfer-Encoding: 8BIT
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K0:IASjhAb58x7yJuNdH5a71tFS9ub3Tw5rJnUgoXhWF8A
 JsoNdB4DXerXsg9N5vaoX+q9vCz30cycpndRX0oZO1RhSIHrbR
 uqE9mFJYjLGvK/ShBPM2XK2WXbYAhXkPIJqnmLt0TM1T0g/TSq
 0qqM6N6xgmO8Gl4uRohqK6vfnwVKyB3ZWa9DSkz9UZU7gOKHrn
 ftdOMcZ6yJTNPIJNqSZKoTw7z36Zyf4rOZWjS4Q9yGzvkFKc/E
 a6BzkwAmklcLRZkTe240Los+/upJvzYzfCDP+byARMIx32v9u8 HRdV5Q=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 
 

Gesendet: Mittwoch, 26. Februar 2014 um 21:26 Uhr
Von: "Jeff Layton" <jlayton@samba.org>
An: "Lorenz Bucher" <Lorenz.Bucher@gmx.de>
Cc: sfrench@samba.org, linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Betreff: Re: [PATCH] cifs: connect: added option krb5mi which may allow package signing
On Wed, 26 Feb 2014 14:46:47 +0100
"Lorenz Bucher" <Lorenz.Bucher@gmx.de> wrote:

> Solves an issue with dfs where servers using package signing are
> mixed with servers which don't use package signing.
>
> Signed-off-by: Lorenz Bucher <lorenz.bucher@gmx.de>
> ---
> fs/cifs/connect.c | 3 +++
> 1 file changed, 3 insertions(+)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 56c152d..9d06dd8 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -1104,6 +1104,9 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
> if (!value || !*value) {
> cERROR(1, "no security value specified");
> continue;
> + } else if (strnicmp(value, "krb5mi", 6) == 0) {
> + vol->secFlg |= CIFSSEC_MAY_KRB5 |
> + CIFSSEC_MAY_SIGN;
> } else if (strnicmp(value, "krb5i", 5) == 0) {
> vol->secFlg |= CIFSSEC_MAY_KRB5 |
> CIFSSEC_MUST_SIGN;

This looks like it applies to a really old kernel. I think that problem
was what commit 0b7bc84000d71f3647ca33ab1bf5bd928535c846 was intended
to fix.

--
Jeff Layton <jlayton@samba.org>

Its the current kernel from LTS Ubuntu 12.04
3.2.0-59-generic #90-Ubuntu SMP Tue Jan 7 22:43:51 UTC 2014

