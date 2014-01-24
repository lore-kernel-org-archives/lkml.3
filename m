Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151AbaAXSjo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 13:39:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37141 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997AbaAXSjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 13:39:43 -0500
Date: Fri, 24 Jan 2014 13:39:34 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: thomas.lendacky@amd.com
Subject: Fix ccp_run_passthru_cmd dma variable assignments
Message-ID: <20140124183934.GA3423@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	thomas.lendacky@amd.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are some suspicious looking lines of code in the new ccp driver, including
one that assigns a variable to itself, and another that overwrites a previous assignment.

This may have been a cut-and-paste error where 'src' was forgotten to be changed to 'dst'.
I have no hardware to test this, so this is untested.

Signed-off-by: Dave Jones <davej@fedoraproject.org>

diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
index 71ed3ade7e12..c266a7b154bb 100644
--- a/drivers/crypto/ccp/ccp-ops.c
+++ b/drivers/crypto/ccp/ccp-ops.c
@@ -1666,8 +1666,8 @@ static int ccp_run_passthru_cmd(struct ccp_cmd_queue *cmd_q,
 
 		op.dst.type = CCP_MEMTYPE_SYSTEM;
 		op.dst.u.dma.address = sg_dma_address(dst.sg_wa.sg);
-		op.src.u.dma.offset = dst.sg_wa.sg_used;
-		op.src.u.dma.length = op.src.u.dma.length;
+		op.dst.u.dma.offset = dst.sg_wa.sg_used;
+		op.dst.u.dma.length = op.src.u.dma.length;
 
 		ret = ccp_perform_passthru(&op);
 		if (ret) {
