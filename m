Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854AbaISPZe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 11:25:34 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:56801 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755682AbaISPZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 11:25:33 -0400
Date: Fri, 19 Sep 2014 10:19:20 -0500
From: Josh Cartwright <joshc@codeaurora.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        Pramod Gurav <pramod.gurav@smartplayin.com>
Subject: Re: [PATCH] pinctrl: qcom: use restart_notifier mechanism for ps_hold
Message-ID: <20140919151920.GH3749@joshc.qualcomm.com>
References: <1411079579-10172-1-git-send-email-joshc@codeaurora.org>
 <541B9ADA.2070107@roeck-us.net>
 <541BA451.9010508@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <541BA451.9010508@roeck-us.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 08:34:41PM -0700, Guenter Roeck wrote:
> On 09/18/2014 07:54 PM, Guenter Roeck wrote:
> >On 09/18/2014 03:32 PM, Josh Cartwright wrote:
> >>By converting to the restart_notifier mechanism for restart, we allow
> >>for other mechanisms, like the watchdog, to be used for restart in the
> >>case where PS_HOLD has failed to reset the chip.
> >>
> >>Choose priority 128, as according to documentation, this mechanism "is
> >>sufficient to restart the entire system".
> >>
> >>Cc: Pramod Gurav <pramod.gurav@smartplayin.com>
> >>Cc: Guenter Roeck <linux@roeck-us.net>
> >>Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
> >>---
[..]
> >>  int msm_pinctrl_probe(struct platform_device *pdev,
> >>                const struct msm_pinctrl_soc_data *soc_data)
> >>@@ -943,6 +948,15 @@ int msm_pinctrl_remove(struct platform_device *pdev)
> >>
> >>      pinctrl_unregister(pctrl->pctrl);
> >>
> >>+    if (pctrl->restart_nb.notifier_call) {
>
> One more comment: The conditional is really unnecessary. Just let
> unregister_restart_handler deal with it ...
>
> >>+        ret = unregister_restart_handler(&pctrl->restart_nb);
> 
> and just ignore the error return. The function will only return an error
> if the entry was not found, and then it is a don't care.

Awesome, thanks.  I like simplifications :).  I was hijacking
notifier_call to indicate whether or not the restart notifier was
registered at all (because it's conditional on the particular chipset
having a "ps_hold" function).  But, nice to know
unregister_restart_handler() does the right thing if the handler wasn't
registered in the first place.

  Josh

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
