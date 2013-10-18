Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755696Ab3JRP5H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 11:57:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12576 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835Ab3JRP5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 11:57:04 -0400
Date: Fri, 18 Oct 2013 17:49:47 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Smith <dsmith@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Martin Cermak <mcermak@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/6] uprobes: fix fork() with the pending ret-probe(s)
Message-ID: <20131018154947.GA15002@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

This series fixes the serious bug reported by Martin and David
and cc's stable. See the changelog in 5/6.

The changes are minimal, I am sending v2 just in case before I
ask to pull.

v2:

	2/6: whitespace fix

	4/6: update the changelog to explain why we do not cleanup
	     the child's stack instead

	5/6: check area != NULL before dup xol_area

	1-5: add the acks from Srikar. I assume he agrees with 6/6
	     as well.


Oleg.

 include/linux/uprobes.h |    4 +-
 kernel/events/uprobes.c |  156 ++++++++++++++++++++++++++++++++++++-----------
 kernel/fork.c           |    2 +-
 3 files changed, 123 insertions(+), 39 deletions(-)

