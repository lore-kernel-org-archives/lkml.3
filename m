Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393AbbAOAXO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 19:23:14 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:44948 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708AbbAOAXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 19:23:12 -0500
Message-ID: <54B7086E.7060807@codeaurora.org>
Date: Wed, 14 Jan 2015 16:23:10 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Timur Tabi <timur@codeaurora.org>
CC: Pramod Gurav <pramod.gurav@smartplayin.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        linux-arm-msm@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Andy Gross <agross@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 4/4] pinctrl: qcom: Add support for reset for apq8064
References: <1409322659-17693-1-git-send-email-pramod.gurav@smartplayin.com>	<1409322659-17693-5-git-send-email-pramod.gurav@smartplayin.com>	<CAOZdJXXRgrYUEcX4f5zRuKgX-Dtbpvf-SV4-8rjuohv3=0NJhQ@mail.gmail.com>	<54B6FF75.70500@codeaurora.org> <CAOZdJXXZ3RH1zOGcz1L58d9DV_LSZtUxYVKe6ssM71nyhnbMyg@mail.gmail.com>
In-Reply-To: <CAOZdJXXZ3RH1zOGcz1L58d9DV_LSZtUxYVKe6ssM71nyhnbMyg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2015 03:54 PM, Timur Tabi wrote:
> On Wed, Jan 14, 2015 at 5:44 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
>> I think so. Can you send a patch? Plus it would be nice to move i = 0 in
>> the for loop at the same time.
> Sadly, Qualcomm policy makes that very cumbersome for me.  I won't be
> able to send a patch any time soon.
>

Hm... we'll have to figure out that part. Anyway here's the patch.

---8<----
From: Stephen Boyd <sboyd@codeaurora.org>
Subject: [PATCH] pinctrl: qcom: Don't iterate past end of function array

Timur reports that this code crashes if nfunctions is 0. Fix the
loop iteration to only consider valid elements of the functions
array.

Reported-by: Timur Tabi <timur@codeaurora.org>
Cc: Pramod Gurav <pramod.gurav@smartplayin.com>
Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Cc: Ivan T. Ivanov <iivanov@mm-sol.com>
Cc: Andy Gross <agross@codeaurora.org>
Fixes: 327455817a92 "pinctrl: qcom: Add support for reset for apq8064"
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 drivers/pinctrl/qcom/pinctrl-msm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/qcom/pinctrl-msm.c b/drivers/pinctrl/qcom/pinctrl-msm.c
index e730935fa457..ed7017df065d 100644
--- a/drivers/pinctrl/qcom/pinctrl-msm.c
+++ b/drivers/pinctrl/qcom/pinctrl-msm.c
@@ -865,10 +865,10 @@ static int msm_ps_hold_restart(struct notifier_block *nb, unsigned long action,
 
 static void msm_pinctrl_setup_pm_reset(struct msm_pinctrl *pctrl)
 {
-	int i = 0;
+	int i;
 	const struct msm_function *func = pctrl->soc->functions;
 
-	for (; i <= pctrl->soc->nfunctions; i++)
+	for (i = 0; i < pctrl->soc->nfunctions; i++)
 		if (!strcmp(func[i].name, "ps_hold")) {
 			pctrl->restart_nb.notifier_call = msm_ps_hold_restart;
 			pctrl->restart_nb.priority = 128;

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project

