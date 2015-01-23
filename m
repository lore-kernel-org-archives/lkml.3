Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034AbbAWBLW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 20:11:22 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:42137 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754905AbbAWBLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 20:11:19 -0500
From: Alexei Starovoitov <ast@plumgrid.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net 0/2] bpf: fix two bugs
Date: Thu, 22 Jan 2015 17:11:07 -0800
Message-Id: <1421975469-13035-1-git-send-email-ast@plumgrid.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Holzheu caught two issues (in bpf syscall and in the test).
Fix them. Details in corresponding patches.

Alexei Starovoitov (2):
  bpf: rcu lock must not be held when calling copy_to_user()
  samples: bpf: relax test_maps check

 kernel/bpf/syscall.c    |   25 +++++++++++++++++--------
 samples/bpf/test_maps.c |    4 ++--
 2 files changed, 19 insertions(+), 10 deletions(-)

-- 
1.7.9.5

