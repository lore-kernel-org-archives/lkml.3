Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347AbaJHWzE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 18:55:04 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:46282 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754421AbaJHWzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 18:55:01 -0400
Date: Wed, 8 Oct 2014 17:49:08 -0500
From: Josh Cartwright <joshc@codeaurora.org>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Pramod Gurav <pramod.gurav@smartplayin.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: pinctrl-msm build error on Linus' tree
Message-ID: <20141008224908.GX868@joshc.qualcomm.com>
References: <CA+5PVA4mO+BiTGvrRb7-MLZRV1iQKsmvaDifFLQiqZN1-b88RQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+5PVA4mO+BiTGvrRb7-MLZRV1iQKsmvaDifFLQiqZN1-b88RQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Josh-

On Wed, Oct 08, 2014 at 06:42:55PM -0400, Josh Boyer wrote:
> We're hitting a build error on ARM with Linus' tree as of Linux
> v3.17-2860-gef0625b70dac :
> 
> drivers/pinctrl/qcom/pinctrl-msm.c: In function 'msm_pinctrl_setup_pm_reset':
> drivers/pinctrl/qcom/pinctrl-msm.c:875:4: error: implicit declaration
> of function 'register_restart_handler'
> [-Werror=implicit-function-declaration]
>     if (register_restart_handler(&pctrl->restart_nb))
>     ^
> drivers/pinctrl/qcom/pinctrl-msm.c: In function 'msm_pinctrl_remove':
> drivers/pinctrl/qcom/pinctrl-msm.c:949:2: error: implicit declaration
> of function 'unregister_restart_handler'
> [-Werror=implicit-function-declaration]
>   unregister_restart_handler(&pctrl->restart_nb);
>   ^
> cc1: some warnings being treated as errors
> 
> Looking at the git logs it seems this was added via:
> 
> commit cf1fc187628913070c3e418ce0e205732435aa2f
> Author: Josh Cartwright <joshc@codeaurora.org>
> Date:   Tue Sep 23 15:59:53 2014 -0500
> 
>     pinctrl: qcom: use restart_notifier mechanism for ps_hold
> 
> 
> However, there is literally nothing else in the tree that calls or
> provides those functions:
> 
> [jwboyer@vader linux]$ git grep unregister_restart_handler
> drivers/pinctrl/qcom/pinctrl-msm.c:     unregister_restart_handler(&pctrl->resta
> [jwboyer@vader linux]$
> 
> 
> I'm rather confused.  How was this commit built and tested?

This may be my fault for not clearly stating that this particular patch
was dependent on Guenter's restart notifier patchset.  This patch was
applied to linusw's tree without these patches.   Perhaps it should be
dropped for now until the restart_notifier stuff lands?

   Josh

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
