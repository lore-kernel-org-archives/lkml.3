Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608Ab3FKM7N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 08:59:13 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:31378 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127Ab3FKMz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 08:55:27 -0400
X-AuditID: cbfee61b-b7f8e6d00000524c-07-51b71e3d0516
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
To: linux-security-module@vger.kernel.org
Cc: m.szyprowski@samsung.com, kyungmin.park@samsung.com, r.krypa@samsung.com,
        linux-kernel@vger.kernel.org, casey@schaufler-ca.com,
        Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [RFCv2] security: smack: add a hash table to quicken smk_find_entry()
Date: Tue, 11 Jun 2013 14:55:12 +0200
Message-id: <1370955313-3605-1-git-send-email-t.stanislaws@samsung.com>
X-Mailer: git-send-email 1.7.10
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMJMWRmVeSWpSXmKPExsVy+t9jAV1bue2BBju3Klvc2/aLzeJs0xt2
	i8u75rBZfOh5xGax9shddou3k1YwW8xrf8nqwO7Rt2UVo8fR/YvYPD5vkgtgjuKySUnNySxL
	LdK3S+DK+PzwM0vBFLaKudOvsDYwfmPpYuTkkBAwkZhzdScThC0mceHeerYuRi4OIYFFjBJ3
	p+1mhXC6mCTW9+9iBaliA+o4tuQzI4gtIqApcWw6RAezwDZGiY4XU8FGCQv4SUxrXwq2gkVA
	VWL39f9gDbwC7hIHny1jhVgnL/H0fh/bBEbuBYwMqxhFUwuSC4qT0nON9IoTc4tL89L1kvNz
	NzGCg+KZ9A7GVQ0WhxgFOBiVeHgTGLcFCrEmlhVX5h5ilOBgVhLhNRPeHijEm5JYWZValB9f
	VJqTWnyIUZqDRUmc92CrdaCQQHpiSWp2ampBahFMlomDU6qBsfEMm/6fKZv+hYXeKVlS/uHd
	AQWTbxdTX//Y2z5tVy6Ljs2J/Wmcu3ZuSbghane+KPhS9zLDSNGCw3wKORqvEpte6l6Y9XDX
	Ta0e5zmiz74GvLXMu7tCf82fGcpbfN6cfVY5U3TpreAib/NCgR2hXx+rlflKp5nYZom2ywou
	cWy9fTNLViTRTYmlOCPRUIu5qDgRAIFbudkGAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,
I have updated the patch after Casey's review.
The fixes from the recent version are:
- update naming according to Casey's guidelines
- fix coding style issues
- use hlist interface instead of double-linked list to reduce memory
  usage and to speed-up initialization
- drop Dan Bernstein hash function in favor of more standard full_name_hash
- adjust the number of hash slots basing on measurements

Regards,
Tomasz Stanislawski

Tomasz Stanislawski (1):
  security: smack: add a hash table to quicken smk_find_entry()

 security/smack/smack.h        |    5 +++++
 security/smack/smack_access.c |   30 +++++++++++++++++++++++++++---
 security/smack/smack_lsm.c    |   12 ++++++------
 3 files changed, 38 insertions(+), 9 deletions(-)

-- 
1.7.9.5

