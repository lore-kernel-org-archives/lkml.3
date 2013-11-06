Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932575Ab3KFOxJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 09:53:09 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:39803 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932522Ab3KFOxB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 09:53:01 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        "open list:MEDIA INPUT INFRA..." <linux-media@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] ths7303: Declare as static a private function
Date: Wed, 06 Nov 2013 15:53:31 +0100
Message-ID: <2256105.l3uKzTDqXY@avalon>
User-Agent: KMail/4.10.5 (Linux/3.10.7-gentoo-r1; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1383748818-22487-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1383748818-22487-1-git-send-email-ricardo.ribalda@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ricardo,

Thank you for the patch.

On Wednesday 06 November 2013 15:40:18 Ricardo Ribalda Delgado wrote:
> git grep shows that the function is only called from ths7303.c
> 
> Fix this build warning:
> 
> CC      drivers/media/i2c/ths7303.o
> drivers/media/i2c/ths7303.c:86:5: warning: no previous prototype for 
> ‘ths7303_setval’ [-Wmissing-prototypes] int ths7303_setval(struct
> v4l2_subdev *sd, enum ths7303_filter_mode mode) ^
> 
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Confirmed :-)

> ---
> v2: Comment by Laurent Pinchart
> Align parameters
> 
>  drivers/media/i2c/ths7303.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/i2c/ths7303.c b/drivers/media/i2c/ths7303.c
> index 42276d9..ed9ae88 100644
> --- a/drivers/media/i2c/ths7303.c
> +++ b/drivers/media/i2c/ths7303.c
> @@ -83,7 +83,8 @@ static int ths7303_write(struct v4l2_subdev *sd, u8 reg,
> u8 val) }
> 
>  /* following function is used to set ths7303 */
> -int ths7303_setval(struct v4l2_subdev *sd, enum ths7303_filter_mode mode)
> +static int ths7303_setval(struct v4l2_subdev *sd,
> +			  enum ths7303_filter_mode mode)
>  {
>  	struct i2c_client *client = v4l2_get_subdevdata(sd);
>  	struct ths7303_state *state = to_state(sd);
-- 
Regards,

Laurent Pinchart

