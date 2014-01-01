Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501AbaAAQQJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jan 2014 11:16:09 -0500
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:46148 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804AbaAAQQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jan 2014 11:16:07 -0500
X-SENDER-IP: [85.230.168.69]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ak8dAA8+xFJV5qhFPGdsb2JhbAANS4tRsWSBKwMBAQEBOIJaAQEBAQIBeAEFCwshFg8JAwIBAgExFAYNAQcBAYd4DallmkkXjx0HhDYBA61ZgWcj
X-IronPort-AV: E=Sophos;i="4.95,585,1384297200"; 
   d="scan'208";a="451005588"
Message-ID: <52C43FFE.3010005@euromail.se>
Date: Wed, 01 Jan 2014 17:19:10 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: "Felipe F. Tonello" <eu@felipetonello.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] input: mt: Add helper function to send end events
References: <1388455601-17033-1-git-send-email-eu@felipetonello.com> <52C28DC7.9020003@euromail.se> <20131231185035.GD6897@core.coreip.homeip.net>
In-Reply-To: <20131231185035.GD6897@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

>> What problematic scenario is this supposed to solve?
>>
>> The 'release on suspend' is only an approximation to the 'close
>> laptop' scenario, it is certainly not correct in the coffee table
>> case,
> 
> Why would it not be correct for coffee table? Do we expect the touches
> to remain valid while the device is asleep?

In some scenarios with placed objects (like a cup or a marker), that would be
the case, yes.

>> for instance. Instead of
>> hardcoding this in the kernel, userland can easily detect long intervals
>> directly using the event time.
> 
> But with slots it is not only problem with old events being sent out
> later, it is that we have mix of old (pre-sleep) and new state.

The new state is not really a problem, it will look exactly the same regardless
of how 'old' releases are handled.

> We do that for keys (release them when we transition to system sleep)
> and I think it might be worthwhile to do the same for touch data.

I agree that keyboard applications seldom look at time intervals and hence are
well helped by such a strategy, even though it is not strictly 'correct'.
However, touch interfaces are quite dependent on time intervals, and it
therefore makes a lot of sense to resolve touch timeouts directly in the
application. It also puts less restrictions on what can be done.

Regarding notifications in general, perhaps it would be interesting to be able
to send a notification event via the input interface when a device comes back
from sleep. It could help resolve other complex issues, if there were any.

Thanks,
Henrik

