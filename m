Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889AbaIPSqI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 14:46:08 -0400
Received: from mail-qg0-f51.google.com ([209.85.192.51]:60392 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754594AbaIPSqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 14:46:06 -0400
MIME-Version: 1.0
In-Reply-To: <3319326.1eJrmz0Vgc@wuerfel>
References: <3319326.1eJrmz0Vgc@wuerfel>
From: Steve French <smfrench@gmail.com>
Date: Tue, 16 Sep 2014 13:45:45 -0500
Message-ID: <CAH2r5mtvXinOSP7MujqLjdOggTnO4SrcO4WaA-iB7h=982XmSA@mail.gmail.com>
Subject: Re: [PATCH] cifs: remove dead code
To: Arnd Bergmann <arnd@arndb.de>
Cc: Steve French <sfrench@samba.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Yalin Wang <yalin.wang@sonymobile.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Merged into cifs-2.6.git for-next

Added Yalin Wang <yalin.wang@sonymobile.com> who reported the same problem/fix

On Mon, Sep 8, 2014 at 10:20 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> cifs provides two dummy functions 'sess_auth_lanman' and
> 'sess_auth_kerberos' for the case in which the respective
> features are not defined. However, the caller is also under
> an #ifdef, so we just get warnings about unused code:
>
> fs/cifs/sess.c:1109:1: warning: 'sess_auth_kerberos' defined but not used [-Wunused-function]
>  sess_auth_kerberos(struct sess_data *sess_data)
>
> Removing the dead functions gets rid of the warnings without
> any downsides that I can see.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>
> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
> index 07fe97ac6b0c..ab0fda6e8e58 100644
> --- a/fs/cifs/sess.c
> +++ b/fs/cifs/sess.c
> @@ -745,14 +745,6 @@ out:
>         sess_free_buffer(sess_data);
>  }
>
> -#else
> -
> -static void
> -sess_auth_lanman(struct sess_data *sess_data)
> -{
> -       sess_data->result = -EOPNOTSUPP;
> -       sess_data->func = NULL;
> -}
>  #endif
>
>  static void
> @@ -1103,15 +1095,6 @@ out:
>         ses->auth_key.response = NULL;
>  }
>
> -#else
> -
> -static void
> -sess_auth_kerberos(struct sess_data *sess_data)
> -{
> -       cifs_dbg(VFS, "Kerberos negotiated but upcall support disabled!\n");
> -       sess_data->result = -ENOSYS;
> -       sess_data->func = NULL;
> -}
>  #endif /* ! CONFIG_CIFS_UPCALL */
>
>  /*
>



-- 
Thanks,

Steve
