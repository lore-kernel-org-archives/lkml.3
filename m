Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516AbaK2B13 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 20:27:29 -0500
Received: from mx1.HRZ.Uni-Dortmund.DE ([129.217.128.51]:62822 "EHLO
	unimail.uni-dortmund.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbaK2B12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 20:27:28 -0500
X-Greylist: delayed 1628 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Nov 2014 20:27:27 EST
Date: Sat, 29 Nov 2014 01:59:34 +0100
From: Andrej Gelenberg <andrej.gelenberg@udo.edu>
To: linux-kernel@vger.kernel.org
Cc: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: ath: phy1: DMA failed to stop in 10 ms
Message-ID: <20141129015934.1d2925d5@bigpc>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hallo,

i got some problems with my Qualcomm Atheros AR9485 wlan pcie card. I
use my card as access point (with hotspotd) on amd64 machine. I use
self compiled vanilla kernel 3.17.4 and a get a lot of 
"DMA failed to stop" messages in my kernel log. I found some reports on
similar errors for *wrt, ubuntu and other distros in various
operation modes (ap and client). Increasing the timeout in mac.c to 100
ms do not help. iommu=soft do not help either and GART iommu is not an
option (usb don't work for me with amd_iommu=off). I found this patch:
https://dev.openwrt.org/browser/trunk/package/mac80211/patches/552-ath9k_rx_dma_stop_check.patch?rev=34910 ,
which seems to apply to my problem, but i am not sure if it is a proper
solution.

Regards,
Andrej Gelenberg

PS: here some kernel logs:

Nov 29 01:12:08 [kernel] [  956.514069] ath: phy1: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020 DMADBG_7=0x0002ad00
Nov 29 01:12:08 [kernel] [  956.514089] ath: phy1: Could not stop RX, we could be confusing the DMA engine when we start RX up
Nov 29 01:12:08 [kernel] [  956.514091] ------------[ cut here ]------------
Nov 29 01:12:08 [kernel] [  956.514096] WARNING: CPU: 2 PID: 242 at drivers/net/wireless/ath/ath9k/recv.c:498 ath_stoprecv+0x137/0x150 [ath9k]()
Nov 29 01:12:08 [kernel] [  956.514097] Modules linked in: bluetooth ath9k ath9k_common ath9k_hw ath loop fglrx(PO) led_class firewire_ohci firewire_core cdc_acm serio_raw 3c59x wmi [last unloaded: ath]
Nov 29 01:12:08 [kernel] [  956.514106] CPU: 2 PID: 242 Comm: kworker/u16:8 Tainted: P        W  O   3.17.4+ #97
Nov 29 01:12:08 [kernel] [  956.514107] Hardware name: To be filled by O.E.M. To be filled by O.E.M./SABERTOOTH 990FX, BIOS 1604 10/16/2012
Nov 29 01:12:08 [kernel] [  956.514110] Workqueue: phy1 ath_reset_work [ath9k]
Nov 29 01:12:08 [kernel] [  956.514112]  0000000000000009 ffff880810713d00 ffffffff81ba31e8 0000000000000000
Nov 29 01:12:08 [kernel] [  956.514113]  ffff880810713d38 ffffffff8111be9c ffff8808075499e0 ffff88080a60a018
Nov 29 01:12:08 [kernel] [  956.514115]  0000000000000000 ffff88080a60a360 ffff8808075499e0 ffff880810713d48
Nov 29 01:12:08 [kernel] [  956.514117] Call Trace:
Nov 29 01:12:08 [kernel] [  956.514122]  [<ffffffff81ba31e8>] dump_stack+0x4d/0x6f
Nov 29 01:12:08 [kernel] [  956.514125]  [<ffffffff8111be9c>] warn_slowpath_common+0x8c/0xc0
Nov 29 01:12:08 [kernel] [  956.514127]  [<ffffffff8111bf8a>] warn_slowpath_null+0x1a/0x20
Nov 29 01:12:08 [kernel] [  956.514130]  [<ffffffffc0164237>] ath_stoprecv+0x137/0x150 [ath9k]
Nov 29 01:12:08 [kernel] [  956.514132]  [<ffffffffc015dfea>] ath_prepare_reset+0x4a/0x70 [ath9k]
Nov 29 01:12:08 [kernel] [  956.514135]  [<ffffffffc016170b>] ath_reset_internal+0x9b/0x1d0 [ath9k]
Nov 29 01:12:08 [kernel] [  956.514138]  [<ffffffffc0161860>] ath_reset+0x20/0x40 [ath9k]
Nov 29 01:12:08 [kernel] [  956.514140]  [<ffffffff81132ac0>] ? pwq_dec_nr_in_flight+0x50/0xb0
Nov 29 01:12:08 [kernel] [  956.514143]  [<ffffffffc0161895>] ath_reset_work+0x15/0x20 [ath9k]
Nov 29 01:12:08 [kernel] [  956.514145]  [<ffffffff81132c65>] process_one_work+0x145/0x3f0
Nov 29 01:12:08 [kernel] [  956.514147]  [<ffffffff8113358b>] worker_thread+0x6b/0x490
Nov 29 01:12:08 [kernel] [  956.514149]  [<ffffffff81133520>] ? init_pwq.part.32+0x10/0x10
Nov 29 01:12:08 [kernel] [  956.514151]  [<ffffffff81137c9b>] kthread+0xdb/0x100
Nov 29 01:12:08 [kernel] [  956.514153]  [<ffffffff81137bc0>] ? kthread_create_on_node+0x1a0/0x1a0
Nov 29 01:12:08 [kernel] [  956.514155]  [<ffffffff81bac1ac>] ret_from_fork+0x7c/0xb0
Nov 29 01:12:08 [kernel] [  956.514157]  [<ffffffff81137bc0>] ? kthread_create_on_node+0x1a0/0x1a0
Nov 29 01:12:08 [kernel] [  956.514159] ---[ end trace e94ce9b429eb9bb7 ]---
Nov 29 01:12:14 [kernel] [  961.748265] ath: phy1: Failed to stop TX DMA, queues=0x00c!
Nov 29 01:12:14 [kernel] [  961.759785] ath: phy1: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020 DMADBG_7=0x0000a400
Nov 29 01:12:14 [kernel] [  961.759809] ath: phy1: Could not stop RX, we could be confusing the DMA engine when we start RX up
Nov 29 01:12:23 [kernel] [  971.465967] ath: phy1: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020 DMADBG_7=0x0002ad00
Nov 29 01:12:23 [kernel] [  971.465993] ath: phy1: Could not stop RX, we could be confusing the DMA engine when we start RX up
Nov 29 01:12:54 [kernel] [ 1002.393560] ath: phy1: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020 DMADBG_7=0x0000ad00
Nov 29 01:12:54 [kernel] [ 1002.393580] ath: phy1: Could not stop RX,
we could be confusing the DMA engine when we start RX up

...

[ 1953.389445] ath: phy1: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020 DMADBG_7=0x0002a800
[ 1953.389477] ath: phy1: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1963.618985] ath: phy1: Failed to stop TX DMA, queues=0x004!
[ 1963.630517] ath: phy1: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020 DMADBG_7=0x0000a400
[ 1963.630546] ath: phy1: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 1992.904614] ath: phy1: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020 DMADBG_7=0x0000ad00
[ 1992.904643] ath: phy1: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 2071.259582] ath: phy1: Failed to stop TX DMA, queues=0x104!
[ 2071.271109] ath: phy1: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020 DMADBG_7=0x0000a400
[ 2071.271134] ath: phy1: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 2076.884579] ath: phy1: Failed to stop TX DMA, queues=0x004!
[ 2076.896107] ath: phy1: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020 DMADBG_7=0x0000a400
[ 2076.896131] ath: phy1: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 2082.517123] ath: phy1: Failed to stop TX DMA, queues=0x004!
[ 2082.528633] ath: phy1: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020 DMADBG_7=0x0000a400
[ 2082.528661] ath: phy1: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 2097.981066] ath: phy1: Failed to stop TX DMA, queues=0x004!
[ 2097.992571] ath: phy1: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020 DMADBG_7=0x0002a800
[ 2097.992596] ath: phy1: Could not stop RX, we could be confusing the DMA engine when we start RX up
[ 2133.206513] ath: phy1: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x02000020 DMADBG_7=0x0002ad00
[ 2133.206541] ath: phy1: Could not stop RX, we could be confusing the
DMA engine when we start RX up
