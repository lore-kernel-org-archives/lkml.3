Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285Ab3EVIqx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 04:46:53 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:57766 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755098Ab3EVIqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 04:46:30 -0400
Message-ID: <1369212383.5916.28.camel@marge.simpson.net>
Subject: Re: [PATCH RFC] sched/rt: preserve global runtime/period ratio in
 do_balance_runtime()
From: Mike Galbraith <bitbucket@online.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Peter Boonstoppel <pboonstoppel@nvidia.com>,
        Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Walmsley <pwalmsley@nvidia.com>
Date: Wed, 22 May 2013 10:46:23 +0200
In-Reply-To: <20130522081601.GP26912@twins.programming.kicks-ass.net>
References: <5FBF8E85CA34454794F0F7ECBA79798F37ADA53CA7@HQMAIL04.nvidia.com>
	 <20130522081601.GP26912@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:PgW5ZqjPerH38D5ypM4Exxx8zskQN7GC9XXXMdACAfC
 zrUPr3/GUV8iYcAZTOLeVGpx5WyuinlUqRIIYe05AWk0V1gloq
 HTHV5L7/eEYFhLCO/nA//CPPm9tEds3MfjFWO2c0+PaUqew2x7
 K5u9P/VmM1xtc31GLtviNqW80H9WI7Y2AuMpChX5CSLO2/eChM
 5b23jjlwWrYZpAtAr0EsqzKuXb+oGAjRb+pCjvcNBUw393T8kP
 hI1T2O3aBZ/di9izBi9wrJn/n0qN1xcyi1vD4ZtYEnwrSpDWCg
 fXi4rDgMGGNr87wk7vbAvah/rJtd69idqNWbhV2ieEQwQdNDUX
 xaaaqnm/m4+VBvdnmJRytGVn18sFV8vE3gU3wDeN4VmI+XYRhP
 c3Ym9OKuGltrA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-05-22 at 10:16 +0200, Peter Zijlstra wrote:

> I thought we already had a knob for that; RT_RUNTIME_SHARE. And as Mike
> said, we might consider flipping the default on that.


sched,rt: disable rt_runtime borrowing by default

Make the default RT_RUNTIME_SHARE setting reflect the most common
throttle role, that of safety mechanism to protect the box.

Signed-off-by: Mike Galbraith <bitbucket@online.de>

diff --git a/kernel/sched/features.h b/kernel/sched/features.h
index 99399f8..0945d38 100644
--- a/kernel/sched/features.h
+++ b/kernel/sched/features.h
@@ -57,7 +57,7 @@ SCHED_FEAT(NONTASK_POWER, true)
 SCHED_FEAT(TTWU_QUEUE, true)
 
 SCHED_FEAT(FORCE_SD_OVERLAP, false)
-SCHED_FEAT(RT_RUNTIME_SHARE, true)
+SCHED_FEAT(RT_RUNTIME_SHARE, false)
 SCHED_FEAT(LB_MIN, false)
 
 /*



