Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758545Ab3APAIp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 19:08:45 -0500
Received: from mail.kernel.org ([198.145.19.201]:43039 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758513Ab3AOWdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:33:09 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 150/221] iwlwifi: fix PCIe interrupt handle return value
Date: Tue, 15 Jan 2013 10:51:17 -0800
Message-Id: <20130115185008.880257833@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 392d4cad7907f6cb4ffc85e135a01abfddc89027 upstream.

By accident, commit eb6476441bc2fecf6232a87d0313a85f8e3da7f4
("iwlwifi: protect use_ict with irq_lock") changed the return
value of the iwl_pcie_isr() function in case it handles an
interrupt -- it now returns IRQ_NONE instead of IRQ_HANDLED.

Put back the correct return value.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/pcie/rx.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/rx.c
@@ -971,6 +971,7 @@ static irqreturn_t iwl_isr(int irq, void
 	else if (test_bit(STATUS_INT_ENABLED, &trans_pcie->status) &&
 		 !trans_pcie->inta)
 		iwl_enable_interrupts(trans);
+	return IRQ_HANDLED;
 
 none:
 	/* re-enable interrupts here since we don't have anything to service. */


