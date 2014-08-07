Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757353AbaHGKbU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 06:31:20 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:62603 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754267AbaHGKbR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 06:31:17 -0400
MIME-Version: 1.0
Date: Thu, 7 Aug 2014 12:31:15 +0200
X-Google-Sender-Auth: pLZYUcAxbKuZeprRL5FXI6TkSb4
Message-ID: <CAMuHMdV4VpaH1nHYO5hr66Xib5o_Pib863JzGRtg2kYcjMp2TQ@mail.gmail.com>
Subject: sel_netif_init: 'err' is used uninitialized (was: Re: selinux: reduce
 the number of calls to synchronize_net() when flushing caches)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Paul Moore <pmoore@redhat.com>
Cc: linux-security-module@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 6, 2014 at 6:27 PM, Linux Kernel Mailing List
<linux-kernel@vger.kernel.org> wrote:
> Gitweb:     http://git.kernel.org/linus/;a=commit;h=615e51fdda6f274e94b1e905fcaf6111e0d9aa20
> Commit:     615e51fdda6f274e94b1e905fcaf6111e0d9aa20
> Parent:     f31e799459659ae88c341aeac16a8a5efb1271d4
> Refname:    refs/heads/master
> Author:     Paul Moore <pmoore@redhat.com>
> AuthorDate: Thu Jun 26 14:33:56 2014 -0400
> Committer:  Paul Moore <pmoore@redhat.com>
> CommitDate: Thu Jun 26 14:33:56 2014 -0400
>
>     selinux: reduce the number of calls to synchronize_net() when flushing caches
>
>     When flushing the AVC, such as during a policy load, the various
>     network caches are also flushed, with each making a call to
>     synchronize_net() which has shown to be expensive in some cases.
>     This patch consolidates the network cache flushes into a single AVC
>     callback which only calls synchronize_net() once for each AVC cache
>     flush.

> --- a/security/selinux/netif.c
> +++ b/security/selinux/netif.c

> @@ -291,10 +282,6 @@ static __init int sel_netif_init(void)
>
>         register_netdevice_notifier(&sel_netif_netdev_notifier);
>
> -       err = avc_add_callback(sel_netif_avc_callback, AVC_CALLBACK_RESET);
> -       if (err)
> -               panic("avc_add_callback() failed, error %d\n", err);
> -
>         return err;

security/selinux/netif.c: In function ‘sel_netif_init’:
/scratch/geert/linux/linux-m68k/security/selinux/netif.c:285: warning:
‘err’ is used uninitialized in this function

Should it just return 0, like before?
Or should it return the return value of register_netdevice_notifier() instead,
which also returns an error code? Or is that failure non-critical?

>  }

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
