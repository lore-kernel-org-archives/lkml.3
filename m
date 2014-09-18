Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741AbaIRXCX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 19:02:23 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:42153 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbaIRXCW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 19:02:22 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH] pinctrl: qcom: use restart_notifier mechanism for ps_hold
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <20140918224904.GD3749@joshc.qualcomm.com>
Date: Thu, 18 Sep 2014 16:02:19 -0700
Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        Pramod Gurav <pramod.gurav@smartplayin.com>,
        Guenter Roeck <linux@roeck-us.net>
Content-Transfer-Encoding: 8BIT
Message-Id: <9CD0FD1C-E8EA-4585-9837-070199BCC26D@codeaurora.org>
References: <1411079579-10172-1-git-send-email-joshc@codeaurora.org> <11F1E440-6BD4-46F1-A399-4334FBA2C3B6@codeaurora.org> <20140918224904.GD3749@joshc.qualcomm.com>
To: Josh Cartwright <joshc@codeaurora.org>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 18, 2014, at 3:49 PM, Josh Cartwright <joshc@codeaurora.org> wrote:

> On Thu, Sep 18, 2014 at 03:47:20PM -0700, Kumar Gala wrote:
>> On Sep 18, 2014, at 3:32 PM, Josh Cartwright <joshc@codeaurora.org> wrote:
>> 
>>> By converting to the restart_notifier mechanism for restart, we allow
>>> for other mechanisms, like the watchdog, to be used for restart in the
>>> case where PS_HOLD has failed to reset the chip.
>>> 
>>> Choose priority 128, as according to documentation, this mechanism "is
>>> sufficient to restart the entire system?.
>> 
>> Will we use a higher priority for watchdog?  or how would we fail over to watchdog?
> 
> The registered restart handlers are called in (descending) priority
> order.  This driver registers as 128, but conceivably there could be
> some super-board-specific restart mechanism that can register itself as
> higher priority than this and it will be attempted first.
> 
> If PS_HOLD doesn't work, the lower priority restart handlers will
> continue to be called, including the watchdog, which is registering with
> the lowest priority (0).

Cool, thanks.

- k
-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

