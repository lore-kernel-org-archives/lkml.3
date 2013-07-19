Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965012Ab3GSAsS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 20:48:18 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:61296 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759509Ab3GSAsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 20:48:17 -0400
MIME-Version: 1.0
In-Reply-To: <20130716152737.507bc6f1cc7cfe069e97d245@canb.auug.org.au>
References: <20130716152737.507bc6f1cc7cfe069e97d245@canb.auug.org.au>
From: Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Thu, 18 Jul 2013 20:47:45 -0400
X-Google-Sender-Auth: fN47dNWQl_1RW2VLngDXJLMuFl4
Message-ID: <CAP=VYLr7fL4a8VTHdgX=GWT9kApP7e2NLHtftTL4_v9VJ097ng@mail.gmail.com>
Subject: Re: linux-next: manual merge of the cpuinit tree with the
 hwmon-staging tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 1:27 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Paul,
>
> Today's linux-next merge of the cpuinit tree got a conflict in
> drivers/hwmon/coretemp.c between commit cc58db361386 ("hwmon: (coretemp)
> Atom CPUs don't support TjMax; no warning needed") from the hwmon-staging
> tree and commit "hwmon: delete __cpuinit usage from all hwmon files" from
> the cpuinit tree.
>
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Hi Stephen,

As the cpuinit tree was merged today, can you drop it from the
linux-next process?   Thanks again for your help in testing this
and dealing with the patch queue like an akpm/mmotm source.

Paul.
>
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
>
> diff --cc drivers/hwmon/coretemp.c
> index be58da1,2e5e2dc..0000000
> --- a/drivers/hwmon/coretemp.c
> +++ b/drivers/hwmon/coretemp.c
> @@@ -317,20 -316,7 +316,19 @@@ static int adjust_tjmax(struct cpuinfo_
>         return tjmax;
>   }
>
>  +static bool cpu_has_tjmax(struct cpuinfo_x86 *c)
>  +{
>  +      u8 model = c->x86_model;
>  +
>  +      return model > 0xe &&
>  +             model != 0x1c &&
>  +             model != 0x26 &&
>  +             model != 0x27 &&
>  +             model != 0x35 &&
>  +             model != 0x36;
>  +}
>  +
> - static int __cpuinit get_tjmax(struct cpuinfo_x86 *c, u32 id,
> -                              struct device *dev)
> + static int get_tjmax(struct cpuinfo_x86 *c, u32 id, struct device *dev)
>   {
>         int err;
>         u32 eax, edx;
