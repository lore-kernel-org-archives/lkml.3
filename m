Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916AbaHRMh5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 08:37:57 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:39378 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641AbaHRMh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 08:37:56 -0400
MIME-Version: 1.0
In-Reply-To: <1408354400-1656-1-git-send-email-arjun024@gmail.com>
References: <1408354400-1656-1-git-send-email-arjun024@gmail.com>
Date: Mon, 18 Aug 2014 08:37:51 -0400
Message-ID: <CAC-25o_-nFG8LJzxLwy1EmQvpG72T9_pj3vqygbam6u6pc3_3g@mail.gmail.com>
Subject: Re: [PATCH] tools/thermal: fix calloc argument ordering
From: "edubezval@gmail.com" <edubezval@gmail.com>
To: Arjun Sreedharan <arjun024@gmail.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Aug 18, 2014 at 5:33 AM, Arjun Sreedharan <arjun024@gmail.com> wrote:
> @number first, @size second argument
>
> Signed-off-by: Arjun Sreedharan <arjun024@gmail.com>

Acked-by: Eduardo Valentin <edubezval@gmail.com>

> ---
>  tools/thermal/tmon/sysfs.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/tools/thermal/tmon/sysfs.c b/tools/thermal/tmon/sysfs.c
> index dfe4548..1c12536 100644
> --- a/tools/thermal/tmon/sysfs.c
> +++ b/tools/thermal/tmon/sysfs.c
> @@ -446,7 +446,7 @@ int probe_thermal_sysfs(void)
>                 return -1;
>         }
>
> -       ptdata.tzi = calloc(sizeof(struct tz_info), ptdata.max_tz_instance+1);
> +       ptdata.tzi = calloc(ptdata.max_tz_instance+1, sizeof(struct tz_info));
>         if (!ptdata.tzi) {
>                 fprintf(stderr, "Err: allocate tz_info\n");
>                 return -1;
> @@ -454,8 +454,8 @@ int probe_thermal_sysfs(void)
>
>         /* we still show thermal zone information if there is no cdev */
>         if (ptdata.nr_cooling_dev) {
> -               ptdata.cdi = calloc(sizeof(struct cdev_info),
> -                               ptdata.max_cdev_instance + 1);
> +               ptdata.cdi = calloc(ptdata.max_cdev_instance + 1,
> +                               sizeof(struct cdev_info));
>                 if (!ptdata.cdi) {
>                         free(ptdata.tzi);
>                         fprintf(stderr, "Err: allocate cdev_info\n");
> --
> 1.8.1.msysgit.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Eduardo Bezerra Valentin
