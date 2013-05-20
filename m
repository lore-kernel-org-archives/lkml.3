Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204Ab3ETFJQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 01:09:16 -0400
Received: from intranet.asianux.com ([58.214.24.6]:45741 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226Ab3ETFJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 01:09:14 -0400
X-Spam-Score: -100.8
Message-ID: <5199AFC9.8050607@asianux.com>
Date: Mon, 20 May 2013 13:08:25 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: james.l.morris@oracle.com, Rusty Russell <rusty@rustcorp.com.au>,
        dmitry.kasatkin@intel.com, "dhowells@redhat.com" <dhowells@redhat.com>,
        andriy.shevchenko@linux.intel.com
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] lib/mpi/mpicoder.c: looping issue, need stop when equal to
 zero, found by 'EXTRA_FLAGS=-W'.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


For 'while' looping, need stop when 'nbytes == 0', or will cause issue.
('nbytes' is size_t which is always bigger or equal than zero).

The related warning: (with EXTRA_CFLAGS=-W)
  lib/mpi/mpicoder.c:40:2: warning: comparison of unsigned expression >= 0 is always true [-Wtype-limits]


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 lib/mpi/mpicoder.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/mpi/mpicoder.c b/lib/mpi/mpicoder.c
index 5f9c44c..4cc6442 100644
--- a/lib/mpi/mpicoder.c
+++ b/lib/mpi/mpicoder.c
@@ -37,7 +37,7 @@ MPI mpi_read_raw_data(const void *xbuffer, size_t nbytes)
 	mpi_limb_t a;
 	MPI val = NULL;
 
-	while (nbytes >= 0 && buffer[0] == 0) {
+	while (nbytes > 0 && buffer[0] == 0) {
 		buffer++;
 		nbytes--;
 	}
-- 
1.7.7.6
