Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932691AbaFEAqP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 20:46:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39765 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492AbaFDXVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:21:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eyal Shapira <eyalx.shapira@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 3.14 020/228] iwlwifi: mvm: rs: fix mimo delimiter in LQ cmd
Date: Wed,  4 Jun 2014 16:20:49 -0700
Message-Id: <20140604232348.742036892@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eyal Shapira <eyal@wizery.com>

commit d9088f60425e0acd8a8f05fdfcfdd288d3258641 upstream.

mimo_delim was always set to 0 instead of pointing to
the first SISO entry after MIMO rates.
This can cause keep transmitting in MIMO even when we shouldn't.
For example when the peer is requesting static SMPS.

Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/mvm/rs.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -2469,6 +2469,7 @@ static void rs_build_rates_table(struct
 	if (is_siso(&rate)) {
 		num_rates = RS_SECONDARY_SISO_NUM_RATES;
 		num_retries = RS_SECONDARY_SISO_RETRIES;
+		lq_cmd->mimo_delim = index;
 	} else if (is_legacy(&rate)) {
 		num_rates = RS_SECONDARY_LEGACY_NUM_RATES;
 		num_retries = RS_LEGACY_RETRIES_PER_RATE;


