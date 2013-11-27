Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757484Ab3K0QgK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 11:36:10 -0500
Received: from queue01a.mail.zen.net.uk ([212.23.3.234]:43836 "EHLO
	queue01a.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754778Ab3K0QgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 11:36:08 -0500
Message-ID: <1385569979.32005.2.camel@linaro1.home>
Subject: Re: [PATCH 2/2] regulator: core: Check for DT every time we check
 full constraints
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Fabio Estevam <festevam@gmail.com>, Liam Girdwood <lgirdwood@gmail.com>,
        thierry.reding@gmail.com, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, Mark Brown <broonie@linaro.org>
Date: Wed, 27 Nov 2013 16:32:59 +0000
In-Reply-To: <1385569457-8650-2-git-send-email-broonie@kernel.org>
References: <1385569457-8650-1-git-send-email-broonie@kernel.org>
	 <1385569457-8650-2-git-send-email-broonie@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-smarthost01a-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-11-27 at 16:24 +0000, Mark Brown wrote:
> From: Mark Brown <broonie@linaro.org>
> 
> Eliminate the gap between DT becoming available and this being used to say
> we have full constraints by checking directly for DT every time we check
> for full constraints. This improves interoperaton with optional regulator
> support.
> 
> Signed-off-by: Mark Brown <broonie@linaro.org>
> ---
>  drivers/regulator/core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
> index 02fdf925bb56..d85f31385b24 100644
> --- a/drivers/regulator/core.c
> +++ b/drivers/regulator/core.c
> @@ -121,7 +121,7 @@ static const char *rdev_get_name(struct regulator_dev *rdev)
>  
>  static bool have_full_constraints(void)
>  {
> -	return has_full_constraints;
> +	return has_full_constraints || of_have_populated_dt();
>  }
>  
>  /**

Doesn't this now make this code in regulator_init_complete()
redundant..?

	if (of_have_populated_dt())
		has_full_constraints = true;

Or is keeping this to avoid one less variable check a worthwhile
optimisation?

-- 
Tixy

