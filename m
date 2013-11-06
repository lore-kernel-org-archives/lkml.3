Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932425Ab3KFOlS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 09:41:18 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:38355 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932127Ab3KFOlR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 09:41:17 -0500
MIME-Version: 1.0
In-Reply-To: <2267169.D0UOzEMZQD@avalon>
References: <1383748068-22182-1-git-send-email-ricardo.ribalda@gmail.com> <2267169.D0UOzEMZQD@avalon>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Wed, 6 Nov 2013 15:40:55 +0100
Message-ID: <CAPybu_0kDqb4Mpbjz7ihNuQ2ZBAwpuguyi7nUUtEbhraPAVc7A@mail.gmail.com>
Subject: Re: [PATCH] ths7303: Declare as static a private function
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        "open list:MEDIA INPUT INFRA..." <linux-media@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Laurent

I have just uploaded a patch, please take a look if I align it properly.

Thanks!

On Wed, Nov 6, 2013 at 3:33 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Ricardo,
>
> Thank you for the patch.
>
> On Wednesday 06 November 2013 15:27:48 Ricardo Ribalda Delgado wrote:
>> git grep shows that the function is only called from ths7303.c
>>
>> Fix this build warning:
>>
>> CC      drivers/media/i2c/ths7303.o
>> drivers/media/i2c/ths7303.c:86:5: warning: no previous prototype for
>> ‘ths7303_setval’ [-Wmissing-prototypes] int ths7303_setval(struct
>> v4l2_subdev *sd, enum ths7303_filter_mode mode) ^
>>
>> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
>> ---
>>  drivers/media/i2c/ths7303.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/i2c/ths7303.c b/drivers/media/i2c/ths7303.c
>> index 42276d9..16da153 100644
>> --- a/drivers/media/i2c/ths7303.c
>> +++ b/drivers/media/i2c/ths7303.c
>> @@ -83,7 +83,8 @@ static int ths7303_write(struct v4l2_subdev *sd, u8 reg,
>> u8 val) }
>>
>>  /* following function is used to set ths7303 */
>> -int ths7303_setval(struct v4l2_subdev *sd, enum ths7303_filter_mode mode)
>> +static int ths7303_setval(struct v4l2_subdev *sd,
>> +                                     enum ths7303_filter_mode mode)
>
> If you align 'enum' on 'struct' from the line above,
>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>
>>  {
>>       struct i2c_client *client = v4l2_get_subdevdata(sd);
>>       struct ths7303_state *state = to_state(sd);
> --
> Regards,
>
> Laurent Pinchart
>



-- 
Ricardo Ribalda
