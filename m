Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407AbaGKLs3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 07:48:29 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:38230 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbaGKLs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 07:48:27 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-34-53bfcf07a61e
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, dmitry.kasatkin@gmail.com,
        Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH v1 0/3] fixes for missing security.ima on new empty files
Date: Fri, 11 Jul 2014 14:46:58 +0300
Message-id: <cover.1405078844.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOJMWRmVeSWpSXmKPExsVy+t/xq7rs5/cHG7z9aG5x6+9eZosvS+ss
	9uw9yWLxcsY8dovLu+awWXzoecRmcf7vcVaLTysmMTtweOycdZfd48GhzSweuxd8ZvLo27KK
	0ePzJjmPTU/eMgWwRXHZpKTmZJalFunbJXBlbGrezFrwh72i/cFZxgbGN6xdjJwcEgImEk//
	zWaDsMUkLtxbD2RzcQgJLGWUeNvRwQSSEBLoZJLYvZwFxGYT0JPY0PyDHcQWEciRmHTmAjNI
	A7PAQkaJ/1OXgk0VFvCU2NG8H8xmEVCVeHr8Dlgzr4ClxO7mxYwQ2+QkTh6bzDqBkXsBI8Mq
	RtHU0uSC4qT0XEO94sTc4tK8dL3k/NxNjJDA+bKDcfExq0OMAhyMSjy8GrW7g4VYE8uKK3MP
	MUpwMCuJ8Jqf3R8sxJuSWFmVWpQfX1Sak1p8iJGJg1OqgTG7zpm190az5yZF1x9nn/bqLcj8
	p3FyUczc3DfrN/wJjRW/w8Ww9s+VhQ4PZeLjjivOcbMM3RsQHLNp0W6RLJW/3t13Xkr5b7J4
	v89a72LPXaV/l+JlVpgcZ7Hhq2oq3msvEBLN8bc5+qND1iTGD9m5v5tcJ33dNHW9IIOVScYX
	hl1RQq02e5VYijMSDbWYi4oTAf8uHc/6AQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset fixes the problem of missing security.ima on new empty files.
Detailed descriptions of problems are in the following patch descriptions.
First two patches fixes the problem. Third patch makes use of FILE_CREATED
flag from VFS, which was not available at the time IMA appraisal came to the
kernel.

- Dmitry

Dmitry Kasatkin (3):
  ima: provide flag to identify new empty files
  evm: skip integrity verification for newly created files
  ima: pass 'opened' flag to identify newly created files

 fs/namei.c                            |  2 +-
 fs/nfsd/vfs.c                         |  2 +-
 include/linux/ima.h                   |  4 ++--
 security/integrity/evm/evm_main.c     |  6 +++++-
 security/integrity/ima/ima.h          |  4 ++--
 security/integrity/ima/ima_appraise.c |  9 ++++++---
 security/integrity/ima/ima_main.c     | 26 ++++++++++++++------------
 security/integrity/integrity.h        |  1 +
 8 files changed, 32 insertions(+), 22 deletions(-)

-- 
1.9.1

