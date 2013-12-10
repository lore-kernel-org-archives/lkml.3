Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752282Ab3LJG7r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 01:59:47 -0500
Received: from mail-ve0-f171.google.com ([209.85.128.171]:35766 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841Ab3LJG7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 01:59:39 -0500
MIME-Version: 1.0
In-Reply-To: <1623649.XDp4FCPInj@avalon>
References: <1386470506-553-1-git-send-email-ethan.kernel@gmail.com>
	<1623649.XDp4FCPInj@avalon>
Date: Tue, 10 Dec 2013 14:59:38 +0800
Message-ID: <CABawtvMn36BWk99kU+dx-E-7ESa3eKdeLugBVsvN130zAYCFcA@mail.gmail.com>
Subject: Re: [PATCH] r_du_lvdsenc.c : Check return value of
 devm_ioremap_resource with IS_ERR
From: Ethan Zhao <ethan.kernel@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Wei Yongjun <weiyj.lk@gmail.com>,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Laurent,

    Next time I scan the NULL check, if hit your driver again, I will resend it.

Thanks,
Ethan

On Tue, Dec 10, 2013 at 10:24 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Ethan,
>
> Thank you for the patch.
>
> On Sunday 08 December 2013 10:41:46 ethan.zhao wrote:
>> function devm_ioremap_resource() doesn't return NULL, should check its
>> return value with helper IS_ERR().
>>
>> Signed-off-by: ethan.zhao <ethan.kernel@gmail.com>
>
> This issue has already been addressed by a patch sent to the dri-devel mailing
> list by Wei Yongjun (https://lkml.org/lkml/2013/8/22/637).
>
> I've asked for a v2 to be submitted but haven't received any reply. I'll fix
> the problem myself and send the patch now.
>
>> ---
>>  drivers/gpu/drm/rcar-du/rcar_du_lvdsenc.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/gpu/drm/rcar-du/rcar_du_lvdsenc.c
>> b/drivers/gpu/drm/rcar-du/rcar_du_lvdsenc.c index a0f6a17..93190ab 100644
>> --- a/drivers/gpu/drm/rcar-du/rcar_du_lvdsenc.c
>> +++ b/drivers/gpu/drm/rcar-du/rcar_du_lvdsenc.c
>> @@ -151,7 +151,7 @@ static int rcar_du_lvdsenc_get_resources(struct
>> rcar_du_lvdsenc *lvds, }
>>
>>       lvds->mmio = devm_ioremap_resource(&pdev->dev, mem);
>> -     if (lvds->mmio == NULL) {
>> +     if (IS_ERR(lvds->mmio)) {
>>               dev_err(&pdev->dev, "failed to remap memory resource for %s\n",
>>                       name);
>>               return -ENOMEM;
>
> --
> Regards,
>
> Laurent Pinchart
>
