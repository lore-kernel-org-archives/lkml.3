Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932487AbaJNPlD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 11:41:03 -0400
Received: from mail-oi0-f48.google.com ([209.85.218.48]:58022 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932229AbaJNPlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 11:41:01 -0400
MIME-Version: 1.0
In-Reply-To: <15420.1413169748@turing-police.cc.vt.edu>
References: <15420.1413169748@turing-police.cc.vt.edu>
Date: Tue, 14 Oct 2014 08:41:00 -0700
X-Google-Sender-Auth: eOqt29eXq3URPj7WIBAjjlKO-9Q
Message-ID: <CAGXu5jLOZ6pR-CTJBsQXR=62RsctB0dxDJRxDOUCiHTb=p+Nfg@mail.gmail.com>
Subject: Re: [PATCH[ fix duplicate console-efi entries in pstore
From: Kees Cook <keescook@chromium.org>
To: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Cc: Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 12, 2014 at 8:09 PM, Valdis Kletnieks
<Valdis.Kletnieks@vt.edu> wrote:
> The pstore filesystem still creates duplicate filename/inode pairs for
> some pstore types.  Add the id to the filename to prevent that.

Looks good to me, thanks!

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

>
> Before patch:
>
> [/sys/fs/pstore] ls -li
> total 0
> 1250 -r--r--r--. 1 root root 67 Sep 29 17:09 console-efi
> 1250 -r--r--r--. 1 root root 67 Sep 29 17:09 console-efi
> 1250 -r--r--r--. 1 root root 67 Sep 29 17:09 console-efi
> 1250 -r--r--r--. 1 root root 67 Sep 29 17:09 console-efi
> 1250 -r--r--r--. 1 root root 67 Sep 29 17:09 console-efi
> 1250 -r--r--r--. 1 root root 67 Sep 29 17:09 console-efi
> 1250 -r--r--r--. 1 root root 67 Sep 29 17:09 console-efi
> 1250 -r--r--r--. 1 root root 67 Sep 29 17:09 console-efi
> 1250 -r--r--r--. 1 root root 67 Sep 29 17:09 console-efi
>
>
> After:
>
> [/sys/fs/pstore] ls -li
> total 0
> 1232 -r--r--r--. 1 root root 148 Sep 29 17:09 console-efi-141202499100000
> 1231 -r--r--r--. 1 root root  67 Sep 29 17:09 console-efi-141202499200000
> 1230 -r--r--r--. 1 root root 148 Sep 29 17:44 console-efi-141202705400000
> 1229 -r--r--r--. 1 root root  67 Sep 29 17:44 console-efi-141202705500000
> 1228 -r--r--r--. 1 root root  67 Sep 29 20:42 console-efi-141203772600000
> 1227 -r--r--r--. 1 root root 148 Sep 29 23:42 console-efi-141204854900000
> 1226 -r--r--r--. 1 root root  67 Sep 29 23:42 console-efi-141204855000000
> 1225 -r--r--r--. 1 root root 148 Sep 29 23:59 console-efi-141204954200000
> 1224 -r--r--r--. 1 root root  67 Sep 29 23:59 console-efi-141204954400000
>
> Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>
>
> --- linux-next/fs/pstore/inode.c.orig   2014-10-03 23:58:00.440386528 -0400
> +++ linux-next/fs/pstore/inode.c        2014-10-09 17:50:50.613829841 -0400
> @@ -320,10 +320,10 @@ int pstore_mkfile(enum pstore_type_id ty
>                                                 compressed ? ".enc.z" : "");
>                 break;
>         case PSTORE_TYPE_CONSOLE:
> -               sprintf(name, "console-%s", psname);
> +               sprintf(name, "console-%s-%lld", psname, id);
>                 break;
>         case PSTORE_TYPE_FTRACE:
> -               sprintf(name, "ftrace-%s", psname);
> +               sprintf(name, "ftrace-%s-%lld", psname, id);
>                 break;
>         case PSTORE_TYPE_MCE:
>                 sprintf(name, "mce-%s-%lld", psname, id);
>



-- 
Kees Cook
Chrome OS Security
