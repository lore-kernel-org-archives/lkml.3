Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222AbaIWN6T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 09:58:19 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:62356 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbaIWN6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 09:58:17 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-49-54217c751b1a
From: Kamil Debski <k.debski@samsung.com>
To: "'Sjoerd Simons'" <sjoerd.simons@collabora.co.uk>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Arun Kumar K'" <arun.kk@samsung.com>
Cc: "'Mauro Carvalho Chehab'" <m.chehab@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        "'Daniel Drake'" <drake@endlessm.com>
References: <1411390322-25212-1-git-send-email-sjoerd.simons@collabora.co.uk>
In-reply-to: <1411390322-25212-1-git-send-email-sjoerd.simons@collabora.co.uk>
Subject: RE: [PATCH] [media] s5p-mfc: Use decode status instead of display
 status on MFCv5
Date: Tue, 23 Sep 2014 15:58:12 +0200
Message-id: <085901cfd736$6ae349c0$40a9dd40$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac/WZBXtp0Rh5qMJQvSjr9pTqLRtMAA0he1Q
Content-language: pl
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBLMWRmVeSWpSXmKPExsVy+t/xa7qlNYohBtMajCw+nrrNavFo/mNm
	i7NNb9gtNj2+xmpxedccNoueDVtZLWac38dkcXGdvMX0429ZHTg9/j6/zuKx6HuWx+Yl9R59
	W1YxenzeJBfAGsVlk5Kak1mWWqRvl8CV0XHzCWPBfaGKQ+8nsDUwHufvYuTkkBAwkfj65h4j
	hC0mceHeerYuRi4OIYGljBJTfvUyQTgNTBJvZ+8HquLgYBPQlFh1zwMkLiLQxSixbtYrZhCH
	WeAho8Tr9zOZQUYJCfhKHFmwFMzmFPCTWPlqKwuILSwQIzHv61SwOIuAqsSDbWvZQWxeAQeJ
	Y5ueskLYghI/Jt8Dq2cW0JJYv/M4E4QtL7F5zVtmkCMkBNQlHv3VBTFFBIwkJh50hKgQkbjb
	8Jx1AqPQLCSDZiEZNAvJoFlIWhYwsqxiFE0tTS4oTkrPNdQrTswtLs1L10vOz93ECImdLzsY
	Fx+zOsQowMGoxMPrsUYhRIg1say4MvcQowQHs5II74MqxRAh3pTEyqrUovz4otKc1OJDjEwc
	nFINjN7GIXrG5WsXvztfdiNVYsHxYwx372Z2O/z6IWWVpDqvLJDXJ3BR6ubFnVG+U7nn71iW
	0KH+9XyyUKHHwmNXjrgal2Yp16Tccb8kMuPk/7MZ4t2ZSTv6Ohbu+fI50e+XzNT2v/d7p/Pn
	yxx9vnDf9er0Zxv2TdKwzNnf7fvI9/GD2kU3dKWza5VYijMSDbWYi4oTAeynz4l7AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sjoerd,

> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Sjoerd Simons
> Sent: Monday, September 22, 2014 2:52 PM
> To: Kyungmin Park; Kamil Debski; Arun Kumar K
> Cc: Mauro Carvalho Chehab; linux-arm-kernel@lists.infradead.org; linux-
> media@vger.kernel.org; linux-kernel@vger.kernel.org; linux-samsung-
> soc@vger.kernel.org; Daniel Drake; Sjoerd Simons
> Subject: [PATCH] [media] s5p-mfc: Use decode status instead of display
> status on MFCv5
> 
> Commit 90c0ae50097 changed how the frame_type of a decoded frame
> gets determined, by switching from the get_dec_frame_type to
> get_disp_frame_type operation. Unfortunately it seems that on MFC v5
> the
> result of get_disp_frame_type is always 0 (no display) when decoding
> (tested with H264), resulting in no frame ever being output from the
> decoder.

Could you tell me which firmware version do you use (date)?

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland
 
> This patch reverts MFC v5 to the previous behaviour while keeping the
> new behaviour for v6 and up.
> 
> Signed-off-by: Sjoerd Simons <sjoerd.simons@collabora.co.uk>
> ---
>  drivers/media/platform/s5p-mfc/s5p_mfc.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c
> b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> index d35b041..27ca9d0 100644
> --- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
> +++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
> @@ -264,7 +264,12 @@ static void s5p_mfc_handle_frame_new(struct
> s5p_mfc_ctx *ctx, unsigned int err)
>  	unsigned int frame_type;
> 
>  	dspl_y_addr = s5p_mfc_hw_call(dev->mfc_ops, get_dspl_y_adr, dev);
> -	frame_type = s5p_mfc_hw_call(dev->mfc_ops, get_disp_frame_type,
> ctx);
> +	if (IS_MFCV6_PLUS(dev))
> +		frame_type = s5p_mfc_hw_call(dev->mfc_ops,
> +			get_disp_frame_type, ctx);
> +	else
> +		frame_type = s5p_mfc_hw_call(dev->mfc_ops,
> +			get_dec_frame_type, dev);
> 
>  	/* If frame is same as previous then skip and do not dequeue */
>  	if (frame_type == S5P_FIMV_DECODE_FRAME_SKIPPED) {
> --
> 2.1.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

