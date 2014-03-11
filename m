Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178AbaCKQHc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 12:07:32 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:29338 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435AbaCKQHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 12:07:30 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-02-531f34bf735d
From: Lukasz Pawelczyk <l.pawelczyk@partner.samsung.com>
To: Casey Schaufler <casey@schaufler-ca.com>,
        James Morris <james.l.morris@oracle.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: r.krypa@samsung.com, t.swierczek@samsung.com,
        Lukasz Pawelczyk <l.pawelczyk@partner.samsung.com>
Subject: [PATCH 0/3] Proposed changes to ptrace in smack
Date: Tue, 11 Mar 2014 17:07:03 +0100
Message-id: <1394554026-23924-1-git-send-email-l.pawelczyk@partner.samsung.com>
X-Mailer: git-send-email 1.8.5.3
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNJMWRmVeSWpSXmKPExsVy+t/xK7r7TeSDDa6tUbG4t+0Xm0Xf4yCL
	WQfXslpc3jWHzeJDzyM2i7eTVjBb/Lo9hdWB3ePj01ssHgff7WHy6NuyitHj6P5FbB6fN8kF
	sEZx2aSk5mSWpRbp2yVwZew8UVJwkK3iwcGH7A2MM1m7GDk5JARMJDbeP8AIYYtJXLi3nq2L
	kYtDSGApo8TsxT8ZIZxeJomWI1dZQKrYBCwk9k27wQqSEBGYzygx/8diIIeDg1kgTeLmB3sQ
	Uxiopnl/DEg5i4CqRNu7eWCtvAL+EjuvPIdarCDRsmwX+wRG7gWMDKsYRVNLkwuKk9JzjfSK
	E3OLS/PS9ZLzczcxQgLk6w7GpcesDjEKcDAq8fDOVJIPFmJNLCuuzD3EKMHBrCTC+1ETKMSb
	klhZlVqUH19UmpNafIiRiYNTqoHxdvObWEc+sWKBA6Zfehd8K1ed2fRa9emE1FbnDHeJcynv
	/A7zlL6duCOOQcjqzcuK9rKedy1n8rj71v14WlhjYFITz/9t1e7Nt0QmGO7XWxHTviSlYe8P
	49YrGVbMt6yXZnJUhjn1fe2X2nxhgcdKnWu1E6R3/TB+m9zwa2nv/MjNvqerL5xXYinOSDTU
	Yi4qTgQA6pgaou4BAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a follow up of an e-mail discussion you had with Rafal Krypa on
December.  This patch set implements "ptrace" smackfs interface, like
you proposed, for tuning of Smack behavior for ptrace. It also fixes
some issues around ptrace in Smack that were found in the process.

Lukasz Pawelczyk (3):
  Smack: fix the subject/object order in smack_ptrace_traceme()
  Smack: unify all ptrace accesses in the smack
  Smack: adds smackfs/ptrace interface

 Documentation/security/Smack.txt |  10 ++++
 security/smack/smack.h           |  10 ++++
 security/smack/smack_access.c    |  38 +++++++++++---
 security/smack/smack_lsm.c       | 106 +++++++++++++++++++++++++++++++++------
 security/smack/smackfs.c         |  74 +++++++++++++++++++++++++++
 5 files changed, 216 insertions(+), 22 deletions(-)

-- 
1.8.5.3

