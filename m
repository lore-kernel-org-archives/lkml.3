Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756725Ab3ASBZv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 20:25:51 -0500
Received: from mail.kernel.org ([198.145.19.201]:57168 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756634Ab3ASBWB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 20:22:01 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Mark Rustad <mark.d.rustad@intel.com>,
        Bhanu Prakash Gollapudi <bprakash@broadcom.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 02/16] tcm_fc: Do not indicate retry capability to initiators
Date: Fri, 18 Jan 2013 17:21:40 -0800
Message-Id: <20130119012139.003350211@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130119012138.680057206@linuxfoundation.org>
References: <20130119012138.680057206@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Rustad <mark.d.rustad@intel.com>

commit f2eeba214bcd0215b7f558cab6420e5fd153042b upstream.

When generating a PRLI response to an initiator, clear the
FCP_SPPF_RETRY bit in the response.

Signed-off-by: Mark Rustad <mark.d.rustad@intel.com>
Reviewed-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
Acked by Robert Love <robert.w.love@intel.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/tcm_fc/tfc_sess.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/target/tcm_fc/tfc_sess.c
+++ b/drivers/target/tcm_fc/tfc_sess.c
@@ -434,10 +434,10 @@ static int ft_prli_locked(struct fc_rpor
 
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


