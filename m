Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803AbaHETtF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 15:49:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39901 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753636AbaHETtE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 15:49:04 -0400
Date: Tue, 5 Aug 2014 21:46:28 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <levinsasha928@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/7] /proc/PID/*maps* fixes/cleanups
Message-ID: <20140805194627.GA30693@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes:

	1-4: Update the changelogs, join "introduce the stable
	     proc_maps_private->mm" and "change m_start() to rely on
	     priv->mm" into a single "shift "priv->task = NULL" from
	     m_start() to m_stop()".

	     Resulting code is the same. Kirill and Cyrill, you seem
	     to agree with these changes, I'll appreciate your acks.

	5-7: New. Seems to work, please review.

Todo:

	- Cleanup the tail_vma horror in m_start

	- Update task_nommu.c in the same way

	- Fix lock_trace() users

Oleg.

 fs/proc/base.c     |   36 ++++++++------
 fs/proc/internal.h |    3 +
 fs/proc/task_mmu.c |  136 ++++++++++++++++++++++++++-------------------------
 3 files changed, 93 insertions(+), 82 deletions(-)

