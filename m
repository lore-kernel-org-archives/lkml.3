Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306AbaJHXJV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 19:09:21 -0400
Received: from mail-oi0-f49.google.com ([209.85.218.49]:34949 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504AbaJHXJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 19:09:19 -0400
MIME-Version: 1.0
In-Reply-To: <20141008224908.GX868@joshc.qualcomm.com>
References: <CA+5PVA4mO+BiTGvrRb7-MLZRV1iQKsmvaDifFLQiqZN1-b88RQ@mail.gmail.com>
	<20141008224908.GX868@joshc.qualcomm.com>
Date: Wed, 8 Oct 2014 19:09:18 -0400
X-Google-Sender-Auth: 52-jgpg6OpNQPoUERJhe_y9x5-Q
Message-ID: <CA+5PVA4nJkPZnZ2GfRmj4YBgmBKJBM4cG_3=DC2LXXJtB5=HHw@mail.gmail.com>
Subject: Re: pinctrl-msm build error on Linus' tree
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Josh Cartwright <joshc@codeaurora.org>
Cc: Pramod Gurav <pramod.gurav@smartplayin.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 8, 2014 at 6:49 PM, Josh Cartwright <joshc@codeaurora.org> wrote:
> Hey Josh-
>
> On Wed, Oct 08, 2014 at 06:42:55PM -0400, Josh Boyer wrote:
>> We're hitting a build error on ARM with Linus' tree as of Linux
>> v3.17-2860-gef0625b70dac :
>>
>> drivers/pinctrl/qcom/pinctrl-msm.c: In function 'msm_pinctrl_setup_pm_reset':
>> drivers/pinctrl/qcom/pinctrl-msm.c:875:4: error: implicit declaration
>> of function 'register_restart_handler'
>> [-Werror=implicit-function-declaration]
>>     if (register_restart_handler(&pctrl->restart_nb))
>>     ^
>> drivers/pinctrl/qcom/pinctrl-msm.c: In function 'msm_pinctrl_remove':
>> drivers/pinctrl/qcom/pinctrl-msm.c:949:2: error: implicit declaration
>> of function 'unregister_restart_handler'
>> [-Werror=implicit-function-declaration]
>>   unregister_restart_handler(&pctrl->restart_nb);
>>   ^
>> cc1: some warnings being treated as errors
>>
>> Looking at the git logs it seems this was added via:
>>
>> commit cf1fc187628913070c3e418ce0e205732435aa2f
>> Author: Josh Cartwright <joshc@codeaurora.org>
>> Date:   Tue Sep 23 15:59:53 2014 -0500
>>
>>     pinctrl: qcom: use restart_notifier mechanism for ps_hold
>>
>>
>> However, there is literally nothing else in the tree that calls or
>> provides those functions:
>>
>> [jwboyer@vader linux]$ git grep unregister_restart_handler
>> drivers/pinctrl/qcom/pinctrl-msm.c:     unregister_restart_handler(&pctrl->resta
>> [jwboyer@vader linux]$
>>
>>
>> I'm rather confused.  How was this commit built and tested?
>
> This may be my fault for not clearly stating that this particular patch
> was dependent on Guenter's restart notifier patchset.  This patch was
> applied to linusw's tree without these patches.   Perhaps it should be
> dropped for now until the restart_notifier stuff lands?

Thanks, that explains things.  I'm not sure if Linus would do a revert
at this point.  I guess it depends on how fast he's going to merge
Guenter's patches.

Is there a reason this wasn't all brought in via one tree?  Seems like
it should have been.

josh
