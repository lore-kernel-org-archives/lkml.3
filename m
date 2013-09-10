Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799Ab3IJDzX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 23:55:23 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:51708 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab3IJDzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 23:55:22 -0400
MIME-Version: 1.0
In-Reply-To: <1378749661-8841-1-git-send-email-teg@jklm.no>
References: <1378749661-8841-1-git-send-email-teg@jklm.no>
From: Lucas De Marchi <lucas.de.marchi@gmail.com>
Date: Tue, 10 Sep 2013 00:55:01 -0300
Message-ID: <CAKi4VAJuvrpBdCecG=xcZt3K5r2ffnRAXsh_Yj=85eE+ey-t0w@mail.gmail.com>
Subject: Re: [PATCH] depmod: warn on invalid devname specification
To: Tom Gundersen <teg@jklm.no>
Cc: linux-modules <linux-modules@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Kay Sievers <kay@vrfy.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tom,

On Mon, Sep 9, 2013 at 3:01 PM, Tom Gundersen <teg@jklm.no> wrote:
> During the last merge window (3.12) a couple of modules gained devname
> aliases, but without the necessary major and minor information. These were
> then silently ignored when generating modules.devname.
>
> Complain loudly to avoid such errors sneaking in undetected in the future:
>
>     depmod: ERROR: Module 'zram' has devname (zram) but lacks major and minor information. Ignoring.
>     depmod: ERROR: Module 'uhid' has devname (uhid) but lacks major and minor information. Ignoring.
>
> Cc: Kay Sievers <kay@vrfy.org>
> Cc: Lucas De Marchi <lucas.demarchi@profusion.mobi>
> ---
>  tools/depmod.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
>
> diff --git a/tools/depmod.c b/tools/depmod.c
> index 985cf3a..5855b2a 100644
> --- a/tools/depmod.c
> +++ b/tools/depmod.c
> @@ -2120,11 +2120,18 @@ static int output_devname(struct depmod *depmod, FILE *out)
>                                 minor = min;
>                         }
>
> -                       if (type != '\0' && devname != NULL) {
> +                       if (type != '\0' && devname != NULL)
> +                               break;
> +               }
> +
> +               if (devname != NULL) {
> +                       if (type != '\0')
>                                 fprintf(out, "%s %s %c%u:%u\n", mod->modname,
>                                         devname, type, major, minor);
> -                               break;
> -                       }
> +                       else
> +                               ERR("Module '%s' has devname (%s) but "
> +                                   "lacks major and minor information. "
> +                                   "Ignoring.\n", mod->modname, devname);
>                 }
>         }
>
> --

Patch has been applied. Thanks.

Lucas De Marchi
