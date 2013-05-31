Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757234Ab3EaTpB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 15:45:01 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:51578 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753780Ab3EaToz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 15:44:55 -0400
MIME-Version: 1.0
In-Reply-To: <be5d8d48c70deec2d883e122732522ced3bd6246.1369947186.git.joe@perches.com>
References: <alpine.LNX.2.00.1305291537120.30576@pobox.suse.cz>
	<cover.1369947186.git.joe@perches.com>
	<be5d8d48c70deec2d883e122732522ced3bd6246.1369947186.git.joe@perches.com>
Date: Fri, 31 May 2013 22:44:54 +0300
Message-ID: <CAHp75Vdt22imDXu0phvbAVz=D-ctXH_JV6eMZ457e4d+=Tj0=Q@mail.gmail.com>
Subject: Re: [PATCH 2/3] pktcdvd: Convert printk to pr_<level>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Dan Carpenter <dan.carpenter@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 30, 2013 at 11:57 PM, Joe Perches <joe@perches.com> wrote:
> Use a more current logging style and add messages levels
> to the logging messages.
>
> Convert bare printks to pr_cont where appropriate and
> add a simple function to emit the sense string.

Few comments below.

Why not dev_dbg wherever it's possible?

> --- a/drivers/block/pktcdvd.c
> +++ b/drivers/block/pktcdvd.c

> @@ -60,7 +62,7 @@
>  #include <linux/mutex.h>
>  #include <linux/slab.h>
>  #include <scsi/scsi_cmnd.h>
> -l#include <scsi/scsi_ioctl.h>
> +#include <scsi/scsi_ioctl.h>

Maybe you simple could remove this typo in first patch?

> @@ -734,36 +736,37 @@ out:
>         return ret;
>  }
>
> +static const char *sense_key_string(__u8 index)
> +{
> +       static const char *info[9] = {
> +               "No sense", "Recovered error", "Not ready",
> +               "Medium error", "Hardware error", "Illegal request",
> +               "Unit attention", "Data protect", "Blank check"
> +       };
> +       if (index < 8)
> +               return info[index];
> +       return "INVALID";
> +}
> +
>  /*
>   * A generic sense dump / resolve mechanism should be implemented across
>   * all ATAPI + SCSI devices.
>   */
>  static void pkt_dump_sense(struct packet_command *cgc)
>  {
> -       static char *info[9] = { "No sense", "Recovered error", "Not ready",
> -                                "Medium error", "Hardware error", "Illegal request",
> -                                "Unit attention", "Data protect", "Blank check" };
>         int i;
>         struct request_sense *sense = cgc->sense;
>
> -       printk(DRIVER_NAME":");
> +       pr_err("");
>         for (i = 0; i < CDROM_PACKET_SIZE; i++)
> -               printk(" %02x", cgc->cmd[i]);
> -       printk(" - ");
> +               pr_cont(" %02x", cgc->cmd[i]);

This one is actually %*ph.

Like: pr_info("%*ph", CDROM_PACKET_SIZE, cgc->cmd);

And what is the level of this message? debug?

--
With Best Regards,
Andy Shevchenko
