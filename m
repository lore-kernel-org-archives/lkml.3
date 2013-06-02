Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392Ab3FBMMn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 08:12:43 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:34282 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab3FBMMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 08:12:37 -0400
MIME-Version: 1.0
In-Reply-To: <57c43b1b2fdcec5bc95d22654bd4f34df6cc1faf.1370048648.git.joe@perches.com>
References: <1369978679.10556.36.camel@joe-AO722>
	<cover.1370048648.git.joe@perches.com>
	<57c43b1b2fdcec5bc95d22654bd4f34df6cc1faf.1370048648.git.joe@perches.com>
Date: Sun, 2 Jun 2013 15:12:36 +0300
Message-ID: <CAHp75Vc+bnh+O5UAHiw6czn6VzKeXiOGurdOLMJvwVLK=8aM-g@mail.gmail.com>
Subject: Re: [PATCH V2 6/8] pktcdvd: Convert pr_notice to pkt_notice
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Dan Carpenter <dan.carpenter@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 1, 2013 at 7:11 AM, Joe Perches <joe@perches.com> wrote:
> Add a new pkt_notice macro to prefix the name to the logging output.

One nitpick below.

> --- a/drivers/block/pktcdvd.c
> +++ b/drivers/block/pktcdvd.c
> @@ -71,17 +71,19 @@
>
>  #define DRIVER_NAME    "pktcdvd"
>
> +#define pkt_err(pd, fmt, ...)                                          \
> +       pr_err("%s: " fmt, pd->name, ##__VA_ARGS__)
> +#define pkt_notice(pd, fmt, ...)                                       \
> +       pr_notice("%s: " fmt, pd->name, ##__VA_ARGS__)
> +
>  #define pkt_dbg(level, pd, fmt, ...)                                   \
>  do {                                                                   \
>         if (level == 2 && PACKET_DEBUG >= 2)                            \
> -               pr_notice("%s: %s():" fmt,                              \
> -                         pd->name, __func__, ##__VA_ARGS__);           \
> +               pkt_notice(pd, "%s(): " fmt, __func__, ##__VA_ARGS__);  \
>         else if (level == 1 && PACKET_DEBUG >= 1)                       \
> -               pr_notice("%s: " fmt, pd->name, ##__VA_ARGS__);         \
> +               pkt_notice(pd, fmt, ##__VA_ARGS__);                     \
>  } while (0)
>
> -#define pkt_err(pd, fmt, ...)                                          \
> -       pr_err("%s: " fmt, pd->name, ##__VA_ARGS__)

May be put this in the right place before?

--
With Best Regards,
Andy Shevchenko
