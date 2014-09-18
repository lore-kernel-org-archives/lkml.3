Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757574AbaIRWzV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 18:55:21 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:41366 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756257AbaIRWzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 18:55:16 -0400
Date: Thu, 18 Sep 2014 17:49:04 -0500
From: Josh Cartwright <joshc@codeaurora.org>
To: Kumar Gala <galak@codeaurora.org>
Cc: Josh Cartwright <joshc@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        Pramod Gurav <pramod.gurav@smartplayin.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH] pinctrl: qcom: use restart_notifier mechanism for ps_hold
Message-ID: <20140918224904.GD3749@joshc.qualcomm.com>
References: <1411079579-10172-1-git-send-email-joshc@codeaurora.org>
 <11F1E440-6BD4-46F1-A399-4334FBA2C3B6@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11F1E440-6BD4-46F1-A399-4334FBA2C3B6@codeaurora.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 03:47:20PM -0700, Kumar Gala wrote:
> On Sep 18, 2014, at 3:32 PM, Josh Cartwright <joshc@codeaurora.org> wrote:
> 
> > By converting to the restart_notifier mechanism for restart, we allow
> > for other mechanisms, like the watchdog, to be used for restart in the
> > case where PS_HOLD has failed to reset the chip.
> > 
> > Choose priority 128, as according to documentation, this mechanism "is
> > sufficient to restart the entire system?.
> 
> Will we use a higher priority for watchdog?  or how would we fail over to watchdog?

The registered restart handlers are called in (descending) priority
order.  This driver registers as 128, but conceivably there could be
some super-board-specific restart mechanism that can register itself as
higher priority than this and it will be attempted first.

If PS_HOLD doesn't work, the lower priority restart handlers will
continue to be called, including the watchdog, which is registering with
the lowest priority (0).

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
