Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754459Ab3EVNGb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 09:06:31 -0400
Received: from gatzka.org ([85.214.228.118]:40522 "EHLO mail.gatzka.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752588Ab3EVNGa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 09:06:30 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Wed, 22 May 2013 15:06:27 +0200
From: Stephan Gatzka <stephan.gatzka@gmail.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Tejun Heo <tj@kernel.org>, Peter Hurley <peter@hurleysoftware.com>,
        linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: function call =?UTF-8?Q?fw=5Fiso=5Fresource=5Fmange=28=2E=2E?=
 =?UTF-8?Q?=29=20=28core-iso=2Ec=29=20does=20not=20return?=
Reply-To: stephan.gatzka@gmail.com
Mail-Reply-To: stephan.gatzka@gmail.com
In-Reply-To: <20130522145808.1ec7bea7@stein>
References: <8ac7ca3200325ddf85ba57aa6d000f70@gatzka.org>
 <519BA6AC.1080600@hurleysoftware.com> <20130521231847.GA6985@mtj.dyndns.org>
 <20130522094840.472b263e@stein>
 <51145028d1c880d68e0a88d863faa71c@gatzka.org>
 <20130522145808.1ec7bea7@stein>
Message-ID: <b41fcb8e7f7deafe8f8f4c708daf81d4@gatzka.org>
User-Agent: Roundcube Webmail/0.8.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Solution 2 --- Perform interdependent works in different queue 
> instances.
> (Keep the WQ_MEM_RECLAIM flag set at those workqueues that have to take
> work which is necessary for progress of memory reclaim.  If this and 
> only
> this solution is employed for an SBP-2 initiator, we need two if not 
> more
> WQ_MEM_RECLAIM workqueue instances.)

I would go for this solution. I have no problems with lots of workqueues 
around, because there is only a relatively small structure required for 
each workqueue.

> 
> Solution 3 --- Remove the dependency between worklets:
> 
> 	Solution 3a --- Remove the lower-level worklet altogether.
> 	E.g. reimplement the lower-level worklet as a tasklet.

No, I like the workqueue context. :)


> 	Solution 3b --- Remove the higher-level worklet's dependency.
> 	E.g. reimplement the higher-level worklet such that it is woken by
> 	a timer and then aborts or reschedules ( = lets the lower-level
> 	worklet bubble up in the queue).

This looks more difficult to me and not so easy to test.

Stephan
