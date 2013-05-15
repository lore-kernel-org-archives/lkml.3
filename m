Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959Ab3EOWbN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 18:31:13 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:33538 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677Ab3EOWbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 18:31:12 -0400
X-IronPort-AV: E=Sophos;i="4.87,679,1363158000"; 
   d="scan'208";a="47605471"
Message-ID: <51940C9F.6000804@codeaurora.org>
Date: Wed, 15 May 2013 15:30:55 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Ingo Molnar <mingo@elte.hu>, Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [patch 13/15] clockevents: Provide sysfs interface
References: <20130425142452.908423538@linutronix.de> <20130425143436.371634778@linutronix.de> <20130426223729.GA782@sboyd-linux.qualcomm.com> <alpine.LFD.2.02.1305151148470.1388@ionos>
In-Reply-To: <alpine.LFD.2.02.1305151148470.1388@ionos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/13 02:50, Thomas Gleixner wrote:
> On Fri, 26 Apr 2013, Stephen Boyd wrote:
>
>> On 04/25, Thomas Gleixner wrote:
>>> Provide a simple sysfs interface for the clockevent devices. Show the
>>> current active clockevent device.
>>>
>> Neat. Does this do anything about clockevents that aren't in use
>> for the tick devices or broadcast device?
> No, but that would be simple to add.

What would it look like? Right now I think we have clockevent0,1,2,3,
etc. for all the cpus and a broadcast0 device. The broadcast0 device is
present even if we don't actually have a broadcast device in the system
(i.e. it says <null> for its name).

Would we add unused_clockevent0,1,2? Maybe we should have clockevent
devices for each physical evtdev and then symlinks for clockevent0,1,2,3
and broadcast0 that point to the physical clockevent device?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

