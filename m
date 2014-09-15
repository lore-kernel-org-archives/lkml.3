Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760227AbaIOXPE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 19:15:04 -0400
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:60125 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754781AbaIOXPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 19:15:00 -0400
Date: Tue, 16 Sep 2014 02:14:54 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Neil Horman <nhorman@tuxdriver.com>
cc: Steffen Klassert <klassert@mathematik.tu-chemnitz.de>,
        netdev@vger.kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: bisected regression: 3c59x corrupts packets in 3.17-rc5
Message-ID: <alpine.LRH.2.11.1409160209280.21050@adalberg.ut.ee>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Somewhere between 3.17.0-rc3 and 3.17.0-rc5 I started seeing dropped ssh 
connections to a couple of test servers with dual AthlonMP (32-bit) and 
3C90x family of NICs (3Com Corporation 3c980-C 10/100baseTX NIC 
[Python-T] (rev 78) in one server and 3Com Corporation 3c905C-TX/TX-M 
[Tornado] (rev 78) in the other server). Bisect leads to the following 
commit:

98ea232cf63961fad734cc8c5e07e8915ec73073 is the first bad commit
commit 98ea232cf63961fad734cc8c5e07e8915ec73073
Author: Neil Horman <nhorman@tuxdriver.com>
Date:   Thu Sep 4 06:13:38 2014 -0400

    3c59x: avoid panic in boomerang_start_xmit when finding page address:
    ...

-- 
Meelis Roos (mroos@linux.ee)
