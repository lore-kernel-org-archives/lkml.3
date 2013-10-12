Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528Ab3JLHLF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 03:11:05 -0400
Received: from smtprelay0254.hostedemail.com ([216.40.44.254]:54630 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753351Ab3JLHLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 03:11:03 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1461:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1981:2194:2199:2393:2559:2562:2729:2828:3138:3139:3140:3141:3142:3352:3865:3866:3867:3871:3874:4225:4321:4605:5007:7652:7903:10004:10400:10848:11026:11657:11658:11914:12043:12296:12438:12517:12519:12555:13069:13095:13311:13357:13972,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: key89_7d347f5949f04
X-Filterd-Recvd-Size: 2987
Message-ID: <1381561860.8864.5.camel@joe-AO722>
Subject: [PATCH] ixgbevf: Fix the debugging output when device is not
 registered
From: Joe Perches <joe@perches.com>
To: Ethan Zhao <ethan.kernel@gmail.com>
Cc: "Skidmore, Donald C" <donald.c.skidmore@intel.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>
Date: Sat, 12 Oct 2013 00:11:00 -0700
In-Reply-To: <CABawtvMB9J+wxJNZzROvWcUO4UXMwZxpugCRMEHtk3CPqZLh5Q@mail.gmail.com>
References: <1381460298-1097-1-git-send-email-ethan.kernel@gmail.com>
	 <20131011153544.GA14715@kroah.com>
	 <CAErSpo7KHk66uxqerQfo60OLU=WVO6zMtfH24L8QPy9RcMHJ6g@mail.gmail.com>
	 <20131011161210.GB32305@kroah.com>
	 <F6FB0E698C9B3143BDF729DF222866466FD67CA7@ORSMSX110.amr.corp.intel.com>
	 <CABawtvMB9J+wxJNZzROvWcUO4UXMwZxpugCRMEHtk3CPqZLh5Q@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A message can be output with an unidentified eth%d port
when the ixgbevf device is not registered.

ie: ixgbevf: eth%d: ixgbevf_init_interrupt_scheme: etc...

Fix this by using the generic netdev_name() helper
to emit "(unregistered net_device)" instead of "eth%d".

Neaten the format string that emits this too.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index 59a62bb..1b48a55 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -2010,10 +2010,10 @@ static int ixgbevf_init_interrupt_scheme(struct ixgbevf_adapter *adapter)
 		goto err_alloc_queues;
 	}
 
-	hw_dbg(&adapter->hw, "Multiqueue %s: Rx Queue count = %u, "
-	       "Tx Queue count = %u\n",
-	       (adapter->num_rx_queues > 1) ? "Enabled" :
-	       "Disabled", adapter->num_rx_queues, adapter->num_tx_queues);
+	hw_dbg(&adapter->hw,
+	       "Multiqueue %s: Rx Queue count = %u, Tx Queue count = %u\n",
+	       (adapter->num_rx_queues > 1) ? "Enabled" : "Disabled",
+	       adapter->num_rx_queues, adapter->num_tx_queues);
 
 	set_bit(__IXGBEVF_DOWN, &adapter->state);
 
@@ -3645,7 +3645,7 @@ static void __exit ixgbevf_exit_module(void)
 char *ixgbevf_get_hw_dev_name(struct ixgbe_hw *hw)
 {
 	struct ixgbevf_adapter *adapter = hw->back;
-	return adapter->netdev->name;
+	return netdev_name(adapter->netdev);
 }
 
 #endif


