Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857Ab3KHJ1U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 04:27:20 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:50677 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756665Ab3KHJ1O convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Fri, 8 Nov 2013 04:27:14 -0500
Message-Id: <527CBC7D020000780010117C@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Fri, 08 Nov 2013 09:27:09 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <linux-kernel@vger.kernel.org>
Cc: "Matthew Daley" <mattjd@gmail.com>, <kyungsik.lee@lge.com>,
        <akpm@linux-foundation.org>
Subject: [PATCH] unlz4: always set an error return code on failures
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"ret", being set to -1 early on, gets cleared by the first invocation
of lz4_decompress()/lz4_decompress_unknownoutputsize(), and hence
subsequent failures wouldn't be noticed by the caller without setting
it back to -1 right after those calls.

Reported-by: Matthew Daley <mattjd@gmail.com>
Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: Kyungsik Lee <kyungsik.lee@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>

--- a/lib/decompress_unlz4.c
+++ b/lib/decompress_unlz4.c
@@ -141,6 +141,7 @@ STATIC inline int INIT unlz4(u8 *input, 
 			goto exit_2;
 		}
 
+		ret = -1;
 		if (flush && flush(outp, dest_len) != dest_len)
 			goto exit_2;
 		if (output)



