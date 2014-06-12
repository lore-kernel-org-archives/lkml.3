Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751362AbaFLR6G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 13:58:06 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:39874 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbaFLR6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 13:58:04 -0400
Message-ID: <5399EA29.7090302@codeaurora.org>
Date: Thu, 12 Jun 2014 10:58:01 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
CC: Marc Zyngier <Marc.Zyngier@arm.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] clocksource: arch_arm_timer: Fix timecounter initialization
References: <1402475861-15354-1-git-send-email-Li.Xiubo@freescale.com> <5398A7B2.6030807@codeaurora.org> <bce193f3fc264abf82ff52ef69f0b86a@BY2PR03MB505.namprd03.prod.outlook.com>
In-Reply-To: <bce193f3fc264abf82ff52ef69f0b86a@BY2PR03MB505.namprd03.prod.outlook.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/14 00:45, Li.Xiubo@freescale.com wrote:
>
> And if so, why not just set it to 0 ? And by the way, 0 is must here ?
>
>

I would just set it to 0 and be done with it. But all of this doesn't
seem very urgent. The only user of this timecounter is using it for the
read() and mult/shift members. We never call timecounter_read() or
timecounter_cyc2time() so the nsec member is irrelevant.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

