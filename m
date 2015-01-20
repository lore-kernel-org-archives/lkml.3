Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755750AbbATRC7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 12:02:59 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:46478 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755730AbbATRC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 12:02:57 -0500
Date: Tue, 20 Jan 2015 17:02:49 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Cc: Rob Herring <robh+dt@kernel.org>, Mark Brown <broonie@kernel.org>,
        Josh Cartwright <joshc@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v8 3/3] regulator: qcom-rpm: Add missing state flag in
 call to RPM
Message-ID: <20150120170249.GA32408@x1>
References: <1417038661-30209-1-git-send-email-bjorn.andersson@sonymobile.com>
 <1417038661-30209-4-git-send-email-bjorn.andersson@sonymobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1417038661-30209-4-git-send-email-bjorn.andersson@sonymobile.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Nov 2014, Bjorn Andersson wrote:

> This adds the missing state parameter to the call down to the RPM. This
> is currently hard coded to the active state, as that's all we're
> supporting at this moment.
> 
> Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
> ---
>  drivers/regulator/qcom_rpm-regulator.c | 1 +
>  1 file changed, 1 insertion(+)

Applied with Mark's Ack, thanks.

> diff --git a/drivers/regulator/qcom_rpm-regulator.c b/drivers/regulator/qcom_rpm-regulator.c
> index b55cd5b..8f66040 100644
> --- a/drivers/regulator/qcom_rpm-regulator.c
> +++ b/drivers/regulator/qcom_rpm-regulator.c
> @@ -198,6 +198,7 @@ static int rpm_reg_write(struct qcom_rpm_reg *vreg,
>  	vreg->val[req->word] |= value << req->shift;
>  
>  	return qcom_rpm_write(vreg->rpm,
> +			      QCOM_RPM_ACTIVE_STATE,
>  			      vreg->resource,
>  			      vreg->val,
>  			      vreg->parts->request_len);

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
