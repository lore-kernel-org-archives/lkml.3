Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868AbaJHWm6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 18:42:58 -0400
Received: from mail-oi0-f45.google.com ([209.85.218.45]:47061 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbaJHWm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 18:42:57 -0400
MIME-Version: 1.0
Date: Wed, 8 Oct 2014 18:42:55 -0400
X-Google-Sender-Auth: wKsWbbIesjLGhRaxCCSZ0GuD-Nc
Message-ID: <CA+5PVA4mO+BiTGvrRb7-MLZRV1iQKsmvaDifFLQiqZN1-b88RQ@mail.gmail.com>
Subject: pinctrl-msm build error on Linus' tree
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Josh Cartwright <joshc@codeaurora.org>,
        Pramod Gurav <pramod.gurav@smartplayin.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're hitting a build error on ARM with Linus' tree as of Linux
v3.17-2860-gef0625b70dac :

drivers/pinctrl/qcom/pinctrl-msm.c: In function 'msm_pinctrl_setup_pm_reset':
drivers/pinctrl/qcom/pinctrl-msm.c:875:4: error: implicit declaration
of function 'register_restart_handler'
[-Werror=implicit-function-declaration]
    if (register_restart_handler(&pctrl->restart_nb))
    ^
drivers/pinctrl/qcom/pinctrl-msm.c: In function 'msm_pinctrl_remove':
drivers/pinctrl/qcom/pinctrl-msm.c:949:2: error: implicit declaration
of function 'unregister_restart_handler'
[-Werror=implicit-function-declaration]
  unregister_restart_handler(&pctrl->restart_nb);
  ^
cc1: some warnings being treated as errors

Looking at the git logs it seems this was added via:

commit cf1fc187628913070c3e418ce0e205732435aa2f
Author: Josh Cartwright <joshc@codeaurora.org>
Date:   Tue Sep 23 15:59:53 2014 -0500

    pinctrl: qcom: use restart_notifier mechanism for ps_hold


However, there is literally nothing else in the tree that calls or
provides those functions:

[jwboyer@vader linux]$ git grep unregister_restart_handler
drivers/pinctrl/qcom/pinctrl-msm.c:     unregister_restart_handler(&pctrl->resta
[jwboyer@vader linux]$


I'm rather confused.  How was this commit built and tested?

josh

Full build log here:
http://koji.fedoraproject.org/koji/getfile?taskID=7803166&name=build.log
