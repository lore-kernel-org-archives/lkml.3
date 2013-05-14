Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756917Ab3ENRqC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 13:46:02 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:58501 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398Ab3ENRqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 13:46:00 -0400
MIME-Version: 1.0
In-Reply-To: <1368542918-8861-5-git-send-email-imre.deak@intel.com>
References: <1368188011-23661-1-git-send-email-imre.deak@intel.com>
	<1368542918-8861-1-git-send-email-imre.deak@intel.com>
	<1368542918-8861-5-git-send-email-imre.deak@intel.com>
Date: Tue, 14 May 2013 13:45:58 -0400
Message-ID: <CAC-25o-iHZikYLhBo_ckB07y7GgiVn4-9uhc7yN9iZiZC171jw@mail.gmail.com>
Subject: Re: [PATCH v2 4/8] media/si4713-i2c: take usecs_to_jiffies_timeout
 into use
From: "edubezval@gmail.com" <edubezval@gmail.com>
To: Imre Deak <imre.deak@intel.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Peter Senna Tschudin <peter.senna@gmail.com>,
        linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Imre,

On Tue, May 14, 2013 at 10:48 AM, Imre Deak <imre.deak@intel.com> wrote:
> Use usecs_to_jiffies_timeout instead of open-coding the same.
>
> Signed-off-by: Imre Deak <imre.deak@intel.com>

Acked-by: Eduardo Valentin <edubezval@gmail.com>

> ---
>  drivers/media/radio/si4713-i2c.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/radio/si4713-i2c.c b/drivers/media/radio/si4713-i2c.c
> index fe16088..e12f058 100644
> --- a/drivers/media/radio/si4713-i2c.c
> +++ b/drivers/media/radio/si4713-i2c.c
> @@ -233,7 +233,7 @@ static int si4713_send_command(struct si4713_device *sdev, const u8 command,
>
>         /* Wait response from interrupt */
>         if (!wait_for_completion_timeout(&sdev->work,
> -                               usecs_to_jiffies(usecs) + 1))
> +                               usecs_to_jiffies_timeout(usecs)))
>                 v4l2_warn(&sdev->sd,
>                                 "(%s) Device took too much time to answer.\n",
>                                 __func__);
> @@ -470,7 +470,7 @@ static int si4713_wait_stc(struct si4713_device *sdev, const int usecs)
>
>         /* Wait response from STC interrupt */
>         if (!wait_for_completion_timeout(&sdev->work,
> -                       usecs_to_jiffies(usecs) + 1))
> +                       usecs_to_jiffies_timeout(usecs)))
>                 v4l2_warn(&sdev->sd,
>                         "%s: device took too much time to answer (%d usec).\n",
>                                 __func__, usecs);
> --
> 1.7.10.4
>



-- 
Eduardo Bezerra Valentin
