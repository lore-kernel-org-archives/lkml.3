Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755632AbaIZPKN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 11:10:13 -0400
Received: from mail.kernel.org ([198.145.19.201]:39775 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754819AbaIZPKL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 11:10:11 -0400
From: Kevin Hilman <khilman@kernel.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>, ulf.hansson@linaro.org,
        linux-pm@vger.kernel.org, daniel.lezcano@linaro.org, rjw@rjwysocki.net,
        linux-kernel@vger.kernel.org, Lina Iyer <lina.iyer@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 3/4] irq: Allow multiple clients to register for irq affinity notification
References: <1409170479-29955-1-git-send-email-lina.iyer@linaro.org>
	<1409170479-29955-4-git-send-email-lina.iyer@linaro.org>
	<alpine.DEB.2.10.1408272239190.3323@nanos>
	<20140902184305.GB91995@ilina-mac.local>
	<alpine.DEB.2.10.1409022109050.3333@nanos>
	<7htx3vbfqr.fsf@deeprootsystems.com>
	<alpine.DEB.2.11.1409261129220.4567@nanos>
	<20140926094003.GL5182@n2100.arm.linux.org.uk>
Date: Fri, 26 Sep 2014 08:10:04 -0700
In-Reply-To: <20140926094003.GL5182@n2100.arm.linux.org.uk> (Russell King's
	message of "Fri, 26 Sep 2014 10:40:03 +0100")
Message-ID: <7hioka4dv7.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux <linux@arm.linux.org.uk> writes:

> On Fri, Sep 26, 2014 at 11:29:56AM +0200, Thomas Gleixner wrote:
>> On Thu, 25 Sep 2014, Kevin Hilman wrote:
>> > Maybe I'm missing something, or maybe we're just lucky and nobody uses
>> > them together, but irq_set_affinity_notifier() only allows a single
>> > notifier to be registered at any given time.  So if you had a system
>> 
>> A single notifier per irq .....
>
> So what about two drivers wanting to use this notifier, but sharing an
> interrupt?
>
> It sounds to me like this notifier was misdesigned from the very start,
> and it should always have supported multiple notifiers.

I agree.

$SUBJECT patch tries to add that support, and is part of a series
wanting to use these notifiers in the PM QoS subsystem, while at the
same time not breaking existing users.

I suppose this series could be written without $SUBJECT patch, and
crossing fingers in the hopes that an existing user of the notifiers
doesn't also need to use the pm_qos constraints, but that seems like
knowingly leaving an armed landmine laying around.

Kevin
