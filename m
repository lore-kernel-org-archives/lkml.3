Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932240AbaIWSBa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 14:01:30 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:44137 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755536AbaIWSB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 14:01:29 -0400
Date: Tue, 23 Sep 2014 12:55:56 -0500
From: Josh Cartwright <joshc@codeaurora.org>
To: Kumar Gala <galak@codeaurora.org>
Cc: Pramod Gurav <pramod.gurav@smartplayin.com>, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>,
        Josh Cartwright <joshc@codeaurora.org>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-pm@vger.kernel.org,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH v3] power: reset: use restart_notifier mechanism for
 msm-poweroff
Message-ID: <20140923175556.GG868@joshc.qualcomm.com>
References: <1411452520-29589-1-git-send-email-pramod.gurav@smartplayin.com>
 <542112FD.7080302@smartplayin.com>
 <2C40727B-BF1E-46AC-9189-6B35E358220E@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2C40727B-BF1E-46AC-9189-6B35E358220E@codeaurora.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 12:48:42PM -0500, Kumar Gala wrote:
> 
> On Sep 23, 2014, at 1:28 AM, Pramod Gurav <pramod.gurav@smartplayin.com> wrote:
> 
> > +linux-arm-msm
> > On Tuesday 23 September 2014 11:38 AM, Pramod Gurav wrote:
> >> This change replaces use of arm_pm_restart with recently introduced
> >> reset mechanism in Linux kernel called restart_notifier.
> 
> Can you update the commit message to include details about the priority level we are setting it to.
> 
> Probably something like Josh had:
> 
> Choose priority 128, as according to documentation, this mechanism "is
> sufficient to restart the entire system?.
> 
> Hmm, what happens if we have ps_hold restart and msm-poweroff enabled.
> Which one should have priority?

I would hope we would avoid a situation where both this driver is
probed, and the pinctrl-msm driver has registered a restart handler?

That is, we wouldn't ever mix the pinctrl-msm ps_hold mechanism (for
MSM8660/MSM8960/APQ8064, etc) and msm-poweroff (APQ8074 and later).  Is
this a case you're worried about?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
