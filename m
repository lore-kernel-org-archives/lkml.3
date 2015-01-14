Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398AbbANXi0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 18:38:26 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:41591 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbbANXiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 18:38:24 -0500
MIME-Version: 1.0
In-Reply-To: <1409322659-17693-5-git-send-email-pramod.gurav@smartplayin.com>
References: <1409322659-17693-1-git-send-email-pramod.gurav@smartplayin.com>
	<1409322659-17693-5-git-send-email-pramod.gurav@smartplayin.com>
Date: Wed, 14 Jan 2015 17:38:22 -0600
Message-ID: <CAOZdJXXRgrYUEcX4f5zRuKgX-Dtbpvf-SV4-8rjuohv3=0NJhQ@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] pinctrl: qcom: Add support for reset for apq8064
From: Timur Tabi <timur@codeaurora.org>
To: Pramod Gurav <pramod.gurav@smartplayin.com>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-arm-msm@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Andy Gross <agross@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2014 at 9:30 AM, Pramod Gurav
<pramod.gurav@smartplayin.com> wrote:
>
> +static void msm_pinctrl_setup_pm_reset(struct msm_pinctrl *pctrl)
> +{
> +       int i = 0;
> +       const struct msm_function *func = pctrl->soc->functions;
> +
> +       for (; i <= pctrl->soc->nfunctions; i++)

Shouldn't this be

            i < pctrl->soc->nfunctions

As it stands, if nfunctions == 0, this function crashes.

-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
