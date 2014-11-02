Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561AbaKBSRG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 13:17:06 -0500
Received: from kastpost.cyber.ee ([193.40.6.70]:44172 "EHLO kastpost.cyber.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752488AbaKBSRD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 13:17:03 -0500
X-Greylist: delayed 406 seconds by postgrey-1.27 at vger.kernel.org; Sun, 02 Nov 2014 13:17:02 EST
Date: Sun, 2 Nov 2014 20:10:15 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: Joe Carnuccio <joe.carnuccio@qlogic.com>,
        Saurav Kashyap <saurav.kashyap@qlogic.com>
cc: Christoph Hellwig <hch@lst.de>, qla2xxx-upstream@qlogic.com,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: bisected regression: qla2xxx endianness on sparc64
Message-ID: <alpine.DEB.2.03.1411022004230.3979@cyber.ee>
User-Agent: Alpine 2.03 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Between 3.17 and 3.18-rc2, qla2xxx is broken on my sparc64 machines. It 
fails to boot (hangs in firmware rings init).

This is the result of bisect:

98aee70d19a7e3203649fa2078464e4f402a0ad8 is the first bad commit
commit 98aee70d19a7e3203649fa2078464e4f402a0ad8
Author: Joe Carnuccio <joe.carnuccio@qlogic.com>
Date:   Thu Sep 25 05:16:38 2014 -0400

     qla2xxx: Add endianizer to max_payload_size modifier.

     Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
     Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
     Signed-off-by: Christoph Hellwig <hch@lst.de>

:040000 040000 041c1a26dc2a7988900acc982e3bd65d3cf7e751 9700d09c3226fc352d44352f22b84f1be632d324 M  s

This may not be the only problem - when bisecting, I also came to commits 
that got past this step but hang after about 165 seconds of uptime while 
running userspace startup scripts. But let that be another issue at the 
moment.

-- 
Meelis Roos (mroos@linux.ee)
