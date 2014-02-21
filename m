Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382AbaBUJPl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 04:15:41 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:63799 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754253AbaBUJPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 04:15:38 -0500
Message-ID: <1392974126.5451.109.camel@marge.simpson.net>
Subject: Re: [PATCH v2] sched: keep quiescent cpu out of idle balance loop
From: Mike Galbraith <bitbucket@online.de>
To: Lei Wen <adrian.wenl@gmail.com>
Cc: Lei Wen <leiwen@marvell.com>, Peter Zijlstra <peterz@infradead.org>,
        mingo@redhat.com, preeti.lkml@gmail.com, daniel.lezcano@linaro.org,
        viresh.kumar@linaro.org, xjian@marvell.com,
        linux-kernel@vger.kernel.org
Date: Fri, 21 Feb 2014 10:15:26 +0100
In-Reply-To: <1392971691.5451.84.camel@marge.simpson.net>
References: <20140220122311.GO27965@twins.programming.kicks-ass.net>
	 <1392949390-9867-1-git-send-email-leiwen@marvell.com>
	 <1392961903.5451.58.camel@marge.simpson.net>
	 <CALZhoSTUZpL5th8HuN_pMe7UHt1PMVO7h9_DsChyz8eW3vctvw@mail.gmail.com>
	 <1392971691.5451.84.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:TjOv6Zqsozz0l8ac7uC7HkkHkl2fwribGMnK1t+PVUl
 grkcDg11uDI43T/vo1IeNxV8A1rWCgNmdqI7mp43J30yVX5p0E
 6JKE4XD028n22PXF/KYxMOvSCSfiHnIYRGKRVJFyfQSq0Hzqvh
 p2pUO/LI0KydC1qjAd1fmkDwPmMsQTP3uKC4RLoFJEbI814rGL
 ZiAdNGS3c8xJtoacplm8PfMTLY9B7IKnsScKG1bY8QPuz0L1ki
 n1gtEERfccyDiS6hZEEQMaIzTZuc0rlg6WHMi2WLupy9XYrw6u
 FH+cmHxJz54FZOJoC0UF5RA8vx88O8VYBHnvrdIqNAFgiU3F+i
 khzt9Yq7fpEms/EEaRoNS0YVolLC20Hu00rbZSiKE4Iixa+LIT
 Lq0Qh/WVXC7tQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-02-21 at 09:34 +0100, Mike Galbraith wrote:

> I think the construction stuff works fine, and !->sd is the perfect cue
> to tell various things to keep their grubby mitts off of a CPU.

Take idle_balance() for instance.. not much point in dropping rq->lock
just to take it again after doing _nothing_, and we certainly wouldn't
want to go play load balancer for connected CPUs anyway, we might get
something much more important to do RSN.

(that applies to rt in general - go off and play load balancer in the
SCHED_OTHER slums?  Surely you jest, elite snobs don't do skut work,
they actually might get their hands dirty;)

Or, at user discretion, telling CPUPRI stuff that no load balancing also
means no rt balancing, i.e. the user assumes responsibility for ALL task
placement, so we don't need to call neutered functions or spend cycles
maintaining data we will have no use for until the user tells us he is
finished with these CPUs.

etc.

-Mike 

