Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453AbbAGP1o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 10:27:44 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:39702 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362AbbAGP1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 10:27:42 -0500
MIME-Version: 1.0
In-Reply-To: <1420623066-56812-1-git-send-email-xiakaixu@huawei.com>
References: <1420623066-56812-1-git-send-email-xiakaixu@huawei.com>
Date: Wed, 7 Jan 2015 08:27:42 -0700
Message-ID: <CANLsYkxRfSAmevU3dqQVXvQAJVrChYVdG=+vKTtUo84e+SLG7A@mail.gmail.com>
Subject: Re: [PATCH] coresight: fix return value judgement in of_coresight.c
From: Mathieu Poirier <mathieu.poirier@linaro.org>
To: Kaixu Xia <xiakaixu@huawei.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kaixu Xia <kaixu.xia@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 January 2015 at 02:31, Kaixu Xia <xiakaixu@huawei.com> wrote:
> The right return value is rdev, so we should judge it.
>
> Signed-off-by: Kaixu Xia <xiakaixu@huawei.com>
> ---
>  drivers/coresight/of_coresight.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/coresight/of_coresight.c b/drivers/coresight/of_coresight.c
> index 5030c07..5b5f188 100644
> --- a/drivers/coresight/of_coresight.c
> +++ b/drivers/coresight/of_coresight.c
> @@ -174,7 +174,7 @@ struct coresight_platform_data *of_get_coresight_platform_data(
>                                 continue;
>
>                         rdev = of_coresight_get_endpoint_device(rparent);
> -                       if (!dev)
> +                       if (!rdev)
>                                 continue;
>
>                         pdata->child_names[i] = dev_name(rdev);
> --
> 1.8.5.5
>

Applied with re-factoring of the commit subject line and log message.  Thanks.
