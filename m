Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070Ab3BCPT2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 10:19:28 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34201 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753646Ab3BCOzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:55:35 -0500
Message-Id: <20130203144646.963643033@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:47:17 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Mark Rustad <mark.d.rustad@intel.com>,
        Bhanu Prakash Gollapudi <bprakash@broadcom.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 033/128] tcm_fc: Do not indicate retry capability to initiators
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Rustad <mark.d.rustad@intel.com>

commit f2eeba214bcd0215b7f558cab6420e5fd153042b upstream.

When generating a PRLI response to an initiator, clear the
FCP_SPPF_RETRY bit in the response.

Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
Reviewed-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
Acked by Robert Love <robert.w.love@intel.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/target/tcm_fc/tfc_sess.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/tcm_fc/tfc_sess.c b/drivers/target/tcm_fc/tfc_sess.c
index 12d6fa2..59f2b46 100644
--- a/drivers/target/tcm_fc/tfc_sess.c
+++ b/drivers/target/tcm_fc/tfc_sess.c
@@ -396,10 +396,10 @@ static int ft_prli_locked(struct fc_rport_priv *rdata, u32 spp_len,
 
 	/*
 	 * OR in our service parameters with other provider (initiator), if any.
-	 * TBD XXX - indicate RETRY capability?
 	 */
 fill:
 	fcp_parm = ntohl(spp->spp_params);
+	fcp_parm &= ~FCP_SPPF_RETRY;
 	spp->spp_params = htonl(fcp_parm | FCP_SPPF_TARG_FCN);
 	return FC_SPP_RESP_ACK;
 }


