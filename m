Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750828Ab3HSEt0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 00:49:26 -0400
Received: from mail-ve0-f175.google.com ([209.85.128.175]:51995 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab3HSEtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 00:49:22 -0400
MIME-Version: 1.0
Reply-To: myungjoo.ham@gmail.com
In-Reply-To: <20130815075509.GB19280@elgon.mountain>
References: <20130815075509.GB19280@elgon.mountain>
Date: Mon, 19 Aug 2013 13:49:21 +0900
X-Google-Sender-Auth: sqwbD9lm4WQEeOrB4MgfriOC620
Message-ID: <CAJ0PZbTNGDW2buntJUD2Sk4Yd_gB_YQceCvRjWOAEvbMaatrrw@mail.gmail.com>
Subject: Re: [patch] PM / devfreq: create_freezable_workqueue() doesn't return
 an ERR_PTR
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 15, 2013 at 4:55 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> The create_freezable_workqueue() function returns a NULL on error and
> not an ERR_PTR.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Thanks. I'll apply this.

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>

>
> diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
> index e94e619..5088523 100644
> --- a/drivers/devfreq/devfreq.c
> +++ b/drivers/devfreq/devfreq.c
> @@ -983,10 +983,10 @@ static int __init devfreq_init(void)
>         }
>
>         devfreq_wq = create_freezable_workqueue("devfreq_wq");
> -       if (IS_ERR(devfreq_wq)) {
> +       if (!devfreq_wq) {
>                 class_destroy(devfreq_class);
>                 pr_err("%s: couldn't create workqueue\n", __FILE__);
> -               return PTR_ERR(devfreq_wq);
> +               return -ENOMEM;
>         }
>         devfreq_class->dev_attrs = devfreq_attrs;
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html




--
MyungJoo Ham, Ph.D.
System S/W Lab, S/W Center, Samsung Electronics
