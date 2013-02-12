Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932333Ab3BLI4C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 03:56:02 -0500
Received: from www.meduna.org ([92.240.244.38]:52265 "EHLO meduna.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932089Ab3BLI4A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 03:56:00 -0500
X-Greylist: delayed 2602 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Feb 2013 03:56:00 EST
Message-ID: <5119F967.3040302@meduna.org>
Date: Tue, 12 Feb 2013 09:12:23 +0100
From: Stanislav Meduna <stano@meduna.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [PATCH] sched/rt: Unthrottle the highest RT task of the rq if
 there are no another available tasks to be picked
References: <2260671360618316@web22h.yandex.ru> <1360652809.4657.87.camel@marge.simpson.net>
In-Reply-To: <1360652809.4657.87.camel@marge.simpson.net>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: stano@meduna.org
X-Authenticator: dovecot_plain
X-Spam-Score: -6.9
X-Spam-Score-Int: -68
X-Exim-Version: 4.72 (build at 25-Oct-2012 18:35:58)
X-Date: 2013-02-12 09:12:29
X-Connected-IP: 95.105.165.4:49551
X-Message-Linecount: 53
X-Body-Linecount: 37
X-Message-Size: 2289
X-Body-Size: 1493
X-Received-Count: 1
X-Recipient-Count: 4
X-Local-Recipient-Count: 4
X-Local-Recipient-Defer-Count: 0
X-Local-Recipient-Fail-Count: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12.02.2013 08:06, Mike Galbraith wrote:

>> In this case pick_next_task takes idle tasks and idle wastes cpu
>> time.

> That's not a waste of CPU time, that's utilization enforcement the thing
> it is designed to do.

Well this is a philosophical question and the opinions will IMHO
vary strongly. If the throttling kicks in, the system already
is in the out-of-spec state. Is the goal now just to allow
e.g. the ssh login to be able to kill the task and still try
to do the best if otherwise (possibly masking the problem for
months), or is it to enforce the utilization?

For example we have a PLC software where the end-user develops
an application that will be executed in our realtime task.
The application usually has a longer initialization part where
the excess utilization can happen and should be tolerated
and the running part where it is a bug if it happens. Here
I would prefer the throttling to alert the user, but not
to actually throttle if there is no non-RT task actually
wanting to run. In other cases I would maybe prefer even
killing the task, alerting the user to the fact.

I have a related question: is the information that the throttling
happened available somewhere except the log (where it gets only
written once)? If not, would a patch exporting the count
of throttlings via /sys be accepted?

My problem is that I would like to know that the throttling
happened right now and display it to the user.

Regards
-- 
                                        Stano

