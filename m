Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932564AbbA0Q7r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 11:59:47 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:9270 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932352AbbA0Q7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 11:59:44 -0500
From: Bjorn <bjorn@sonymobile.com>
Date: Tue, 27 Jan 2015 08:59:38 -0800
To: Stanimir Varbanov <svarbanov@mm-sol.com>
CC: Linus Walleij <linus.walleij@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Joonwoo Park <joonwoop@codeaurora.org>
Subject: Re: [PATCH 1/3] pinctrl: qcom: increase variable size for register
 addresses
Message-ID: <20150127165937.GC11960@sonymobile.com>
References: <1421745476-6276-1-git-send-email-svarbanov@mm-sol.com>
 <1421745476-6276-2-git-send-email-svarbanov@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1421745476-6276-2-git-send-email-svarbanov@mm-sol.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 20 Jan 01:17 PST 2015, Stanimir Varbanov wrote:

> From: Joonwoo Park <joonwoop@codeaurora.org>
> 
> Newer MSM SoCs have TLMM hardware block upper than 16 bit.  Increase to
> 32 bit registers to hold addresses correctly.
> 

It's not the addresses but rather the offsets and the reason is that the
registers are now spread so we need offsets >16 bit to address them. And this
is to be able to benefit from page based access control.

Could you please update the subject and commit message to be slightly more
accurate?

> Signed-off-by: Joonwoo Park <joonwoop@codeaurora.org>
> Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
> ---
>  drivers/pinctrl/qcom/pinctrl-msm.h |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/pinctrl/qcom/pinctrl-msm.h b/drivers/pinctrl/qcom/pinctrl-msm.h
> index b952c4b..54fdd04 100644
> --- a/drivers/pinctrl/qcom/pinctrl-msm.h
> +++ b/drivers/pinctrl/qcom/pinctrl-msm.h
> @@ -70,11 +70,11 @@ struct msm_pingroup {
>  	unsigned *funcs;
>  	unsigned nfuncs;
>  
> -	s16 ctl_reg;
> -	s16 io_reg;
> -	s16 intr_cfg_reg;
> -	s16 intr_status_reg;
> -	s16 intr_target_reg;
> +	u32 ctl_reg;
> +	u32 io_reg;
> +	u32 intr_cfg_reg;
> +	u32 intr_status_reg;
> +	u32 intr_target_reg;
>  
>  	unsigned mux_bit:5;
>  

The patch itself looks good!

Regards,
Bjorn
