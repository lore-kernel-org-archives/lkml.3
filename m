Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250Ab3HFNeG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 09:34:06 -0400
Received: from rrzmta2.uni-regensburg.de ([194.94.155.52]:56767 "EHLO
	rrzmta2.uni-regensburg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915Ab3HFNeE convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:2:1>);
	Tue, 6 Aug 2013 09:34:04 -0400
Message-Id: <52011762020000A1000122AD@gwsmtp1.uni-regensburg.de>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Tue, 06 Aug 2013 15:33:54 +0200
From: "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
To: <linux-kernel@vger.kernel.org>
Cc: "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
Subject: message (3.0.80) "kernel: [440682.559851] blk_rq_check_limits:
 over max size limit."
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I just did some block device tuning according to some expert's advice which resulted in multipath failures. I'm not going to discuss this as I'll have to investigate further, but I'd like to point out that the messages like "[440682.559851] blk_rq_check_limits: over max size limit." lack the affected device!

It's quite hard to debug if you have more than 90 disks attached:
Aug  6 14:58:08 h06 multipathd: 65:240: mark as failed
Aug  6 14:58:08 h06 multipathd: SAP_T11_I03-E3: remaining active paths: 4
Aug  6 14:58:08 h06 multipathd: 68:48: mark as failed
Aug  6 14:58:08 h06 multipathd: SAP_T11_I03-E3: remaining active paths: 3
Aug  6 14:58:08 h06 multipathd: 8:208: mark as failed
Aug  6 14:58:08 h06 multipathd: SAP_T11_I03-E4: remaining active paths: 3
Aug  6 14:58:08 h06 multipathd: 67:80: mark as failed
Aug  6 14:58:08 h06 multipathd: SAP_T11_I03-E4: remaining active paths: 2
Aug  6 14:58:08 h06 kernel: [440682.559851] blk_rq_check_limits: over max size limit.
Aug  6 14:58:08 h06 kernel: [440682.559891] blk_rq_check_limits: over max size limit.
Aug  6 14:58:08 h06 kernel: [440682.559916] blk_rq_check_limits: over max size limit.
Aug  6 14:58:08 h06 kernel: [440682.559928] blk_rq_check_limits: over max size limit.
Aug  6 14:58:08 h06 kernel: [440682.559966] blk_rq_check_limits: over max size limit.
Aug  6 14:58:08 h06 kernel: [440682.559996] blk_rq_check_limits: over max size limit.
Aug  6 14:58:08 h06 kernel: [440682.560016] blk_rq_check_limits: over max size limit.
Aug  6 14:58:08 h06 kernel: [440682.560037] blk_rq_check_limits: over max size limit.
Aug  6 14:58:08 h06 kernel: [440682.560058] blk_rq_check_limits: over max size limit.
Aug  6 14:58:08 h06 kernel: [440682.560106] blk_rq_check_limits: over max size limit.
Aug  6 14:58:08 h06 kernel: [440682.560149] blk_rq_check_limits: over max size limit.
Aug  6 14:58:08 h06 kernel: [440682.560176] blk_rq_check_limits: over max size limit.
Aug  6 14:58:08 h06 kernel: [440682.560189] blk_rq_check_limits: over max size limit.
Aug  6 14:58:08 h06 kernel: [440682.560223] blk_rq_check_limits: over max size limit.
Aug  6 14:58:08 h06 kernel: [440682.560257] blk_rq_check_limits: over max size limit.
Aug  6 14:58:08 h06 kernel: [440682.560277] blk_rq_check_limits: over max size limit.
Aug  6 14:58:08 h06 kernel: [440682.560296] blk_rq_check_limits: over max size limit.
Aug  6 14:58:08 h06 kernel: [440682.560319] blk_rq_check_limits: over max size limit.
Aug  6 14:58:08 h06 kernel: [440682.560333] device-mapper: multipath: Failing path 65:240.
Aug  6 14:58:08 h06 kernel: [440682.560346] device-mapper: multipath: Failing path 68:48.
Aug  6 14:58:08 h06 kernel: [440682.560429] device-mapper: multipath: Failing path 67:80.
Aug  6 14:58:08 h06 kernel: [440682.560436] device-mapper: multipath: Failing path 8:208.
Aug  6 14:58:08 h06 kernel: [440682.561345] sd 2:0:0:7: alua: port group 01 state N non-preferred supports tolusNA
Aug  6 14:58:08 h06 kernel: [440682.561500] sd 3:0:2:7: alua: port group 01 state N non-preferred supports tolusNA
Aug  6 14:58:08 h06 kernel: [440682.562075] sd 2:0:4:7: alua: port group 01 state N non-preferred supports tolusNA
Aug  6 14:58:08 h06 kernel: [440682.562257] sd 3:0:4:7: alua: port group 01 state N non-preferred supports tolusNA
Aug  6 14:58:08 h06 kernel: [440682.562393] sd 3:0:8:7: alua: port group 01 state N non-preferred supports tolusNA
Aug  6 14:58:08 h06 kernel: [440682.676078] sd 3:0:2:7: alua: port group 01 switched to state A
Aug  6 14:58:08 h06 kernel: [440682.676091] sd 2:0:0:7: alua: port group 01 switched to state A
Aug  6 14:58:08 h06 kernel: [440682.676108] blk_rq_check_limits: over max size limit.
Aug  6 14:58:08 h06 kernel: [440682.676112] blk_rq_check_limits: over max size limit.
Aug  6 14:58:08 h06 kernel: [440682.676115] blk_rq_check_limits: over max size limit.

Is this problem fixed in a newer kernel?

For the curious: I tuned queue/max_sectors_kb for the paths in a multipath device, but didn't tune the multipath device itself...

Regards,
Ulrich
P.S.: Plese keep CC: as I'm not subscribed to the list

