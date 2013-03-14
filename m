Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654Ab3CNUyP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 16:54:15 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:37080 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841Ab3CNUyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 16:54:14 -0400
Date: Thu, 14 Mar 2013 13:53:07 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, davej@redhat.com, sasha.levin@oracle.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        caiqian@redhat.com, eric.dumazet@gmail.com, lizefan@huawei.com
Subject: [PATCH tip/core/urgent] Fix for hlist_entry_safe() regression
Message-ID: <20130314205307.GA27968@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031420-2876-0000-0000-00000663CABC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo

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

