Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751308Ab3FYFIF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 01:08:05 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:35124 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208Ab3FYFIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 01:08:00 -0400
MIME-Version: 1.0
In-Reply-To: <1372136569-551-1-git-send-email-jonghwa3.lee@samsung.com>
References: <1372136569-551-1-git-send-email-jonghwa3.lee@samsung.com>
Date: Tue, 25 Jun 2013 10:37:57 +0530
Message-ID: <CAK9yfHxLDiu7tagRhPEK1aCCTYnMH7i2yKrtqquAwnfxHnZxSg@mail.gmail.com>
Subject: Re: [PATCH 1/2] power: charger-manager: regulator_get() never returns NULL.
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Jonghwa Lee <jonghwa3.lee@samsung.com>
Cc: anton.vorontsov@linaro.org, linux-kernel@vger.kernel.org,
        Myungjoo Ham <myungjoo.ham@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 June 2013 10:32, Jonghwa Lee <jonghwa3.lee@samsung.com> wrote:
> This patch fixes return value checking of regulator_get() in charger-manager
> driver. The API, regulator_get(), returns ERR_PTR() when it fails to get
> regulator with given name, not NULL.
>
> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
> Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
> ---
>  drivers/power/charger-manager.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
> index ba42029..7d1bcde 100644
> --- a/drivers/power/charger-manager.c
> +++ b/drivers/power/charger-manager.c
> @@ -1239,7 +1239,7 @@ static int charger_manager_register_extcon(struct charger_manager *cm)
>
>                 charger->consumer = regulator_get(cm->dev,
>                                         charger->regulator_name);
> -               if (charger->consumer == NULL) {
> +               if (IS_ERR(charger->consumer)) {
>                         dev_err(cm->dev, "Cannot find charger(%s)\n",
>                                 charger->regulator_name);
>                         ret = -EINVAL;

 You can as well make this ret = PTR_ERR(charger->consumer).

---
With warm regards,
Sachin
