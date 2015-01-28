Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760249AbbA1B2m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 20:28:42 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41026 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760002AbbA1B2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:28:30 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Timur Tabi <timur@codeaurora.org>,
        Pramod Gurav <pramod.gurav@smartplayin.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Andy Gross <agross@codeaurora.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 3.18 03/61] pinctrl: qcom: Dont iterate past end of function array
Date: Tue, 27 Jan 2015 17:26:15 -0800
Message-Id: <20150128012637.297311475@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150128012636.936333725@linuxfoundation.org>
References: <20150128012636.936333725@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Boyd <sboyd@codeaurora.org>

commit bcd53f858d87f52843cc87764b283999126a50d6 upstream.

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
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pinctrl/qcom/pinctrl-msm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/pinctrl/qcom/pinctrl-msm.c
+++ b/drivers/pinctrl/qcom/pinctrl-msm.c
@@ -865,10 +865,10 @@ static int msm_ps_hold_restart(struct no
 
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


