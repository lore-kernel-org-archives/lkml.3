Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104AbbAWBLg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 20:11:36 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:46154 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754188AbbAWBLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 20:11:21 -0500
From: Alexei Starovoitov <ast@plumgrid.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net 2/2] samples: bpf: relax test_maps check
Date: Thu, 22 Jan 2015 17:11:09 -0800
Message-Id: <1421975469-13035-3-git-send-email-ast@plumgrid.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1421975469-13035-1-git-send-email-ast@plumgrid.com>
References: <1421975469-13035-1-git-send-email-ast@plumgrid.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hash map is unordered, so get_next_key() iterator shouldn't
rely on particular order of elements. So relax this test.

Fixes: ffb65f27a155 ("bpf: add a testsuite for eBPF maps")
Reported-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Signed-off-by: Alexei Starovoitov <ast@plumgrid.com>
---
 samples/bpf/test_maps.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/samples/bpf/test_maps.c b/samples/bpf/test_maps.c
index e286b42..6299ee9 100644
--- a/samples/bpf/test_maps.c
+++ b/samples/bpf/test_maps.c
@@ -69,9 +69,9 @@ static void test_hashmap_sanity(int i, void *data)
 
 	/* iterate over two elements */
 	assert(bpf_get_next_key(map_fd, &key, &next_key) == 0 &&
-	       next_key == 2);
+	       (next_key == 1 || next_key == 2));
 	assert(bpf_get_next_key(map_fd, &next_key, &next_key) == 0 &&
-	       next_key == 1);
+	       (next_key == 1 || next_key == 2));
 	assert(bpf_get_next_key(map_fd, &next_key, &next_key) == -1 &&
 	       errno == ENOENT);
 
-- 
1.7.9.5

