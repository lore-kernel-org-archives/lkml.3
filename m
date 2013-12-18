Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab3LRKNW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 05:13:22 -0500
Received: from service87.mimecast.com ([91.220.42.44]:55976 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab3LRKNU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 05:13:20 -0500
Message-ID: <52B1753A.7060501@arm.com>
Date: Wed, 18 Dec 2013 10:13:14 +0000
From: Chris Redpath <chris.redpath@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "bsegall@google.com" <bsegall@google.com>
CC: Peter Zijlstra <peterz@infradead.org>, "pjt@google.com" <pjt@google.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "alex.shi@linaro.org" <alex.shi@linaro.org>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Chris Redpath <Chris.Redpath@arm.com>
Subject: Re: [PATCH 2/2] sched: update runqueue clock before migrations away
References: <1386593950-26475-1-git-send-email-chris.redpath@arm.com>	<1386593950-26475-3-git-send-email-chris.redpath@arm.com>	<20131210114825.GF12849@twins.programming.kicks-ass.net>	<52A71605.5090509@arm.com>	<20131210151428.GH12849@twins.programming.kicks-ass.net>	<52A7397F.4000806@arm.com>	<20131212182414.GF2480@laptop.programming.kicks-ass.net>	<52B05B09.5090807@arm.com> <xm26vbynmk2y.fsf@sword-of-the-dawn.mtv.corp.google.com>
In-Reply-To: <xm26vbynmk2y.fsf@sword-of-the-dawn.mtv.corp.google.com>
X-OriginalArrivalTime: 18 Dec 2013 10:13:15.0659 (UTC) FILETIME=[C4163DB0:01CEFBD9]
X-MC-Unique: 113121810131803401
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/12/13 18:03, bsegall@google.com wrote:
> __synchronize_entity_decay will decay load_avg_contrib in order to
> figure out how much to remove from old_cfs_rq->blocked_load.
> update_entity_load_avg will update the underlying runnable_avg_sum/period that
> is used to update load_avg_contrib.
>
> (Normally we update runnable_avg_sum, which updates load_avg_contrib via
> __update_entity_load_avg_contrib. Here we go in the reverse direction
> because we don't hold the right rq locks at the right times.)
>

Thanks Ben, got it now. The only question remaining for me to figure out 
is if I need to include the missed tick time in the contrib decay or not 
- I definitely need to include it in the negative decay count we send 
through a migration. I'll go and check the places we use the removed 
load and update blocked load again.

