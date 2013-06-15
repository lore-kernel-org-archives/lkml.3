Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab3FOXvM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 19:51:12 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:38231 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754639Ab3FOXvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 19:51:11 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        LMML <linux-media@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] media: i2c: ths7303: remove unused member driver_data
Date: Sun, 16 Jun 2013 01:51:22 +0200
Message-ID: <2064603.dg6NN5EgtL@avalon>
User-Agent: KMail/4.10.2 (Linux/3.8.13-gentoo; KDE/4.10.2; x86_64; ; )
In-Reply-To: <1371314050-25866-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1371314050-25866-1-git-send-email-prabhakar.csengg@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Prabhakar,

Thanks for the patch.

On Saturday 15 June 2013 22:04:10 Prabhakar Lad wrote:
> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
> 
> This patch removes the driver_data member from ths7303_state structure.
> The driver_data member was intended to differentiate between ths7303 and
> ths7353 chip and get the g_chip_ident, But as of now g_chip_ident is
> obsolete, so there is no need of driver_data.

What tree it this based on ? linuxtv/master still uses driver_data in the 
ths7303_g_chip_ident() function.

> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> ---
>  drivers/media/i2c/ths7303.c |    4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/drivers/media/i2c/ths7303.c b/drivers/media/i2c/ths7303.c
> index 2e17abc..0a2dacb 100644
> --- a/drivers/media/i2c/ths7303.c
> +++ b/drivers/media/i2c/ths7303.c
> @@ -38,7 +38,6 @@ struct ths7303_state {
>  	struct v4l2_bt_timings		bt;
>  	int std_id;
>  	int stream_on;
> -	int driver_data;
>  };
> 
>  enum ths7303_filter_mode {
> @@ -355,9 +354,6 @@ static int ths7303_probe(struct i2c_client *client,
>  	sd = &state->sd;
>  	v4l2_i2c_subdev_init(sd, client, &ths7303_ops);
> 
> -	/* store the driver data to differntiate the chip */
> -	state->driver_data = (int)id->driver_data;
> -
>  	/* set to default 480I_576I filter mode */
>  	if (ths7303_setval(sd, THS7303_FILTER_MODE_480I_576I) < 0) {
>  		v4l_err(client, "Setting to 480I_576I filter mode failed!\n");
-- 
Regards,

Laurent Pinchart

