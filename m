Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758130Ab3CESFj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 13:05:39 -0500
Received: from spostino.sms.unimo.it ([155.185.44.3]:38111 "EHLO
	spostino.sms.unimo.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756296Ab3CESFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 13:05:37 -0500
From: Paolo valente <paolo.valente@unimore.it>
To: Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S. Miller" <davem@davemloft.net>, shemminger@vyatta.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, fchecconi@gmail.com,
        rizzo@iet.unipi.it, Paolo Valente <paolo.valente@unimore.it>
Subject: [PATCH BUGFIX 0/6] pkt_sched: fix little service anomalies and possible crashes of qfq+
Date: Tue,  5 Mar 2013 19:04:56 +0100
Message-Id: <1362506702-4985-1-git-send-email-paolo.valente@unimore.it>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <20130226.173700.882998504986475149.davem@davemloft.net>
References: <20130226.173700.882998504986475149.davem@davemloft.net>
UNIMORE-X-SA-Score: -2.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 26/02/2013 23:37, David Miller ha scritto:
> From: Paolo valente <paolo.valente@unimore.it>
> Date: Tue, 26 Feb 2013 18:02:46 +0100
> 
>> The portions of the code interested by each fix are small and do not
>> overlap with each other, so I decided to provide just one patch
>> (I hope that this was the right choice).
> 
> Please split this up into 6 patches, each with an appropriately
> verbose analysis and explanation of each bug being fixed, thanks.
> 
> 

Split, and inserted a detailed description of both the problem and the fix
in each patch.

Paolo valente (6):
  pkt_sched: properly cap timestamps in charge_actual_service
  pkt_sched: fix the update of eligible-group sets
  pkt_sched: serve activated aggregates immediately if the scheduler is
    empty
  pkt_sched: prevent budget from wrapping around after a dequeue
  pkt_sched: do not allow virtual time to jump if an aggregate is in
    service
  pkt_sched: remove a useless invocation of qfq_update_eligible

 net/sched/sch_qfq.c |   66 +++++++++++++++++++++++++++++++++++----------------
 1 file changed, 45 insertions(+), 21 deletions(-)

-- 
1.7.9.5

