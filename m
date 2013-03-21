Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933334Ab3CUOXK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 10:23:10 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:58750 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757636Ab3CUOXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 10:23:08 -0400
Date: Thu, 21 Mar 2013 07:22:54 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, davej@redhat.com, sasha.levin@oracle.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        caiqian@redhat.com, eric.dumazet@gmail.com, lizefan@huawei.com
Subject: [GIT PULL tip/core/urgent] Fix for hlist_entry_safe() regression
Message-ID: <20130321142254.GA2992@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130314205307.GA27968@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130314205307.GA27968@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032114-7182-0000-0000-000005E3E822
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Reposting with corrected subject line.]

Hello, Ingo,

This series contains a single commit that fixes a regression in
hlist_entry_safe().  This macro references its argument twice, which
can cause NULL-pointer errors.  This commit applies a gcc statement
expression, creating a temporary variable to avoid the double reference.
This has been posted to LKML at https://lkml.org/lkml/2013/3/9/75.

Kudos to CAI Qian, whose testing uncovered this, to Eric Dumazet, who
spotted root cause, and to Li Zefan, who tested this commit.

This commit is available in the git repository at:

git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/urgent

							Thanx, Paul

----------------------------------------------------------------
Paul E. McKenney (1):
      list: Fix double fetch of pointer in hlist_entry_safe()

 include/linux/list.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

