Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560AbaIWSU5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 14:20:57 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:45855 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756267AbaIWSUz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 14:20:55 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH v3] power: reset: use restart_notifier mechanism for msm-poweroff
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <20140923175556.GG868@joshc.qualcomm.com>
Date: Tue, 23 Sep 2014 13:20:50 -0500
Cc: Pramod Gurav <pramod.gurav@smartplayin.com>, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>, Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-pm@vger.kernel.org,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <C6FFC8E5-EDF0-4248-BE4B-AF4EB8533CCB@codeaurora.org>
References: <1411452520-29589-1-git-send-email-pramod.gurav@smartplayin.com> <542112FD.7080302@smartplayin.com> <2C40727B-BF1E-46AC-9189-6B35E358220E@codeaurora.org> <20140923175556.GG868@joshc.qualcomm.com>
To: Josh Cartwright <joshc@codeaurora.org>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 23, 2014, at 12:55 PM, Josh Cartwright <joshc@codeaurora.org> wrote:

> On Tue, Sep 23, 2014 at 12:48:42PM -0500, Kumar Gala wrote:
>> 
>> On Sep 23, 2014, at 1:28 AM, Pramod Gurav <pramod.gurav@smartplayin.com> wrote:
>> 
>>> +linux-arm-msm
>>> On Tuesday 23 September 2014 11:38 AM, Pramod Gurav wrote:
>>>> This change replaces use of arm_pm_restart with recently introduced
>>>> reset mechanism in Linux kernel called restart_notifier.
>> 
>> Can you update the commit message to include details about the priority level we are setting it to.
>> 
>> Probably something like Josh had:
>> 
>> Choose priority 128, as according to documentation, this mechanism "is
>> sufficient to restart the entire system?.
>> 
>> Hmm, what happens if we have ps_hold restart and msm-poweroff enabled.
>> Which one should have priority?
> 
> I would hope we would avoid a situation where both this driver is
> probed, and the pinctrl-msm driver has registered a restart handler?
> 
> That is, we wouldn't ever mix the pinctrl-msm ps_hold mechanism (for
> MSM8660/MSM8960/APQ8064, etc) and msm-poweroff (APQ8074 and later).  Is
> this a case you're worried about?

Yes, I’m worried about possibly case of having both solutions on a device.

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

