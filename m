Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbbAVQBW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 11:01:22 -0500
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:38325 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbbAVQBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 11:01:21 -0500
Date: Thu, 22 Jan 2015 17:01:15 +0100
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Alexei Starovoitov <ast@kernel.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] samples/bpf: Fix test_maps/bpf_get_next_key() test
Message-ID: <20150122170115.6a75520e@holzheu>
Organization: IBM
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012216-0021-0000-0000-000002A4A6ED
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks like the "test_maps" test case expects to get the keys in
the wrong order when iterating over the elements:

test_maps: samples/bpf/test_maps.c:79: test_hashmap_sanity: Assertion
`bpf_get_next_key(map_fd, &key, &next_key) == 0 && next_key == 2' failed.
Aborted

Fix this and test for the correct order.  

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
---
 samples/bpf/test_maps.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/samples/bpf/test_maps.c
+++ b/samples/bpf/test_maps.c
@@ -69,9 +69,9 @@ static void test_hashmap_sanity(int i, v
 
 	/* iterate over two elements */
 	assert(bpf_get_next_key(map_fd, &key, &next_key) == 0 &&
-	       next_key == 2);
-	assert(bpf_get_next_key(map_fd, &next_key, &next_key) == 0 &&
 	       next_key == 1);
+	assert(bpf_get_next_key(map_fd, &next_key, &next_key) == 0 &&
+	       next_key == 2);
 	assert(bpf_get_next_key(map_fd, &next_key, &next_key) == -1 &&
 	       errno == ENOENT);
 

