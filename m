Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168Ab3FXPu2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 11:50:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12880 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006Ab3FXPu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 11:50:27 -0400
Date: Mon, 24 Jun 2013 17:43:56 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, Imre Deak <imre.deak@intel.com>,
        Julian Anastasov <ja@ssi.bg>, Lukas Czerner <lczerner@redhat.com>,
        Ralf Baechle <ralf@linux-mips.org>, Samuel Ortiz <samuel@sortiz.org>,
        Simon Horman <horms@verge.net.au>, Tejun Heo <tj@kernel.org>,
        Wensong Zhang <wensong@linux-vs.org>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] introduce wait_event_common()
Message-ID: <20130624154356.GA29728@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

The changes in include/linux/wait.h are the same.

However 1/2 has to update the callers of __wait_event_interruptible().
The fix is very simple:

	-	__wait_event_interruptible(wq, cond, ret);
	+	ret = __wait_event_interruptible(wq, cond);

but obviously untested.

Oleg.

 arch/mips/kernel/rtlx.c         |   17 ++--
 include/linux/wait.h            |  183 +++++++++++++++------------------------
 kernel/wait.c                   |   13 +++
 net/irda/af_irda.c              |    5 +-
 net/netfilter/ipvs/ip_vs_sync.c |    5 +-
 5 files changed, 95 insertions(+), 128 deletions(-)

