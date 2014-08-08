Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759530AbaHHWHP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 18:07:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60429 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932555AbaHHVgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 17:36:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 18/24] sparc64: Add membar to Niagara2 memcpy code.
Date: Fri,  8 Aug 2014 14:35:11 -0700
Message-Id: <20140808213336.174664835@linuxfoundation.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <20140808213335.421758947@linuxfoundation.org>
References: <20140808213335.421758947@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit 5aa4ecfd0ddb1e6dcd1c886e6c49677550f581aa ]

This is the prevent previous stores from overlapping the block stores
done by the memcpy loop.

Based upon a glibc patch by Jose E. Marchesi

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sparc/lib/NG2memcpy.S |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/sparc/lib/NG2memcpy.S
+++ b/arch/sparc/lib/NG2memcpy.S
@@ -236,6 +236,7 @@ FUNC_NAME:	/* %o0=dst, %o1=src, %o2=len
 	 */
 	VISEntryHalf
 
+	membar		#Sync
 	alignaddr	%o1, %g0, %g0
 
 	add		%o1, (64 - 1), %o4


