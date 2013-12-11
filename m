Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751222Ab3LKGoU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 01:44:20 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:49671 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082Ab3LKGoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 01:44:17 -0500
Message-ID: <1386744250.12005.43.camel@marge.simpson.net>
Subject: Re: [question] sched: idle_avg and migration latency
From: Mike Galbraith <bitbucket@online.de>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alex Shi <alex.shi@linaro.org>, Ingo Molnar <mingo@kernel.org>
Date: Wed, 11 Dec 2013 07:44:10 +0100
In-Reply-To: <52A75DE6.8090901@linaro.org>
References: <52A6FB5C.7010706@linaro.org>
	 <1386688302.6304.30.camel@marge.simpson.net> <52A75DE6.8090901@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:luj0ROu0uMz2rCGxFwxdvi2TpK8ExLmjYHaijGyCUGg
 lhm9jQsvkwZIJCyqtskNh72FxcphKLDYYXzi5GtTP3fjekaD7I
 aityDH2CuZXMGl8rB3iPm9XLTqCg+QteImnN3vhKPDrDfklZTy
 d/UCAwM4qxHCbkgc/5Fy0S0XMqnBobu163FrlPhXSpmwGgVV+C
 tsneSEVXFKAqbsFvgy1ZXDm+Qlp3OO/GtjoSZkppkxBvCc1TRi
 gRuY8Q+aacIvrSb5vWrHGKqoXHBjEX+VYuRKaMsAYZKKWFHW6V
 A5RWC01dO51nXzgJnNUid5+VBv5AvHfw/LgkMVLnMoRzQdQE5J
 vhryynTIeEPPD+BR3A4mPNyWwn6JrjyNRnQc1fFiP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-10 at 19:31 +0100, Daniel Lezcano wrote:

> I think I am a bit puzzled with the 'idle_avg' name. I am guessing the 
> semantic of this variable is "how long this cpu has been idle".

Average distance between idles.

> The idle duration, with the no_hz, could be long, several seconds if the 
> work queues have been migrated and if the timer affinity is set to 
> another cpu. So if we fall in this case and there is a burst of activity 
> + micro-idle and idle_avg is not leverage to max, it will stay high 
> during an amount of time, thus pulling tasks at each micro idle period, 
> right ?

Yeah, it cares about shutting the thing down when idle distance is too
small to be affordable, but cranking is back up quickly as to not damage
generic bursty load utilization too much.  It tries to be dirt simply
and cheap, not perfect.

For nohz_full loads, you'll likely want to kill most if not all wake and
idle balancing, or at least put some serious roadblocks up.. but then
you'll have isolated and pinned everything anyway if you deeply care
about perturbation.  All load balancing totally sucks in that regard, as
do those darn workqueues you mentioned.

-Mike

