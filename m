Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649Ab3GJOUa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 10:20:30 -0400
Received: from smtp26.sms.unimo.it ([155.185.44.26]:36136 "EHLO
	smtp26.sms.unimo.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131Ab3GJOU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 10:20:29 -0400
X-Greylist: delayed 2016 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Jul 2013 10:20:29 EDT
From: Paolo Valente <paolo.valente@unimore.it>
To: Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S. Miller" <davem@davemloft.net>, shemminger@vyatta.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, fchecconi@gmail.com,
        rizzo@iet.unipi.it, David Laight <David.Laight@ACULAB.COM>,
        Paolo Valente <paolo.valente@unimore.it>
Subject: [PATCH 0/2]  pkt_sched: sch_qfq: efficiency and codestyle improvements
Date: Wed, 10 Jul 2013 15:46:07 +0200
Message-Id: <1373463969-11285-1-git-send-email-paolo.valente@unimore.it>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <20130305.235006.1904081547083683406.davem@davemloft.net>
References: <20130305.235006.1904081547083683406.davem@davemloft.net>
UNIMORE-X-SA-Score: -2.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
this patchset tries to address the two issues raised by Dave in
http://marc.info/?l=linux-kernel&m=136254542019113&w=2

The first of these issues has been also raised by
David Laight:
http://marc.info/?l=linux-kernel&m=136256446624557&w=2

> Although two topics for possibly resolving later:
> 
> 1) That 1ULL bit mask fix is quite expensive on 32-bit, it would
>     probably be cheaper to test for that case using a helper function
>     that nops out on 64-bit.  Although this is not so important.
> 
I have tried to find a simple solution, based on the properties of the mask.
It is in the first patch.

> 2) That static inline forward declaration is ugly, better to remove
>     the inline tag (let the compiler handle it) or move the function
>     above all the call sites.
> 
Done by the second patch.

Paolo Valente (2):
  pkt_sched: sch_qfq: improve efficiency of make_eligible
  pkt_sched: sch_qfq: remove forward declaration of qfq_update_agg_ts

 net/sched/sch_qfq.c | 127 ++++++++++++++++++++++++++--------------------------
 1 file changed, 63 insertions(+), 64 deletions(-)

-- 
1.8.1.2

