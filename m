Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050AbaANPr3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 10:47:29 -0500
Received: from botnar.kaiser.cx ([176.28.20.183]:53596 "EHLO botnar.kaiser.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751923AbaANPqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 10:46:18 -0500
X-Greylist: delayed 1479 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Jan 2014 10:46:17 EST
Date: Tue, 14 Jan 2014 16:21:28 +0100
From: Martin Kaiser <martin@kaiser.cx>
To: netdev@vger.kernel.org
Cc: David Miller <davem@davemloft.net>, shahed.shaikh@qlogic.com,
        linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH -next] qlcnic: fix compiler warning
Message-ID: <20140114152127.GA13575@reykholt.kaiser.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

re-sent as requested by David M.
(I understand the concerns about portability that were raised. At the moment, I don't have a possiblity to do
further rework and testing)

Add an explicit cast to fix the following warning
(seen on Debian Wheezy, gcc 4.7.2)

CC [M]  drivers/net/wireless/rtlwifi/rtl8192ce/trx.o
    drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c: In function ‘qlcnic_send_filter’:
    drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c:349:3: warning:                   
    passing argument 2 of ‘ether_addr_equal’ from incompatible pointer type [enabled by default]
    In file included from include/linux/if_vlan.h:16:0,                                         
    from drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c:9:
    include/linux/etherdevice.h:244:20: note: expected ‘const u8 *’ but argument is of type ‘u64 *’

Signed-off-by: Martin Kaiser <martin@kaiser.cx>
Acked-by: Shahed Shaikh <shahed.shaikh@qlogic.com>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
index 6373f60..3557154 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
@@ -346,7 +346,7 @@ static void qlcnic_send_filter(struct qlcnic_adapter *adapter,
        head = &(adapter->fhash.fhead[hindex]);

        hlist_for_each_entry_safe(tmp_fil, n, head, fnode) {
-               if (ether_addr_equal(tmp_fil->faddr, &src_addr) &&
+               if (ether_addr_equal(tmp_fil->faddr, (const u8 *)&src_addr) &&
                    tmp_fil->vlan_id == vlan_id) {
                        if (jiffies > (QLCNIC_READD_AGE * HZ + tmp_fil->ftime))
                                qlcnic_change_filter(adapter, &src_addr,

