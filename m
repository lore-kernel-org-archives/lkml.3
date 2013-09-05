Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890Ab3IESZe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 14:25:34 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:37865 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011Ab3IESZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 14:25:32 -0400
Date: Thu, 05 Sep 2013 14:25:30 -0400 (EDT)
Message-Id: <20130905.142530.732425484460470485.davem@davemloft.net>
To: Vineet.Gupta1@synopsys.com
Cc: netdev@vger.kernel.org, Alexey.Brodkin@synopsys.com,
        linux-kernel@vger.kernel.org, arc-linux-dev@synopsys.com
Subject: Re: [PATCH] ethernet/arc/arc_emac: Fix huge delays in large file
 copies
From: David Miller <davem@davemloft.net>
In-Reply-To: <1378295235-18928-1-git-send-email-vgupta@synopsys.com>
References: <1378295235-18928-1-git-send-email-vgupta@synopsys.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 05 Sep 2013 11:25:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Date: Wed, 4 Sep 2013 17:17:15 +0530

> copying large files to a NFS mounted host was taking absurdly large
> time.
> 
> Turns out that TX BD reclaim had a sublte bug.
> 
> Loop starts off from @txbd_dirty cursor and stops when it hits a BD
> still in use by controller. However when it stops it needs to keep the
> cursor at that very BD to resume scanning in next iteration. However it
> was erroneously incrementing the cursor, causing the next scan(s) to
> fail too, unless the BD chain was completely drained out.
> 
> [ARCLinux]$ ls -l -sh /disk/log.txt
>  17976 -rw-r--r--    1 root     root       17.5M Sep  /disk/log.txt
> 
> ========== Before =====================
> [ARCLinux]$ time cp /disk/log.txt /mnt/.
> real    31m 7.95s
> user    0m 0.00s
> sys     0m 0.10s
> 
> ========== After =====================
> [ARCLinux]$ time cp /disk/log.txt /mnt/.
> real    0m 24.33s
> user    0m 0.00s
> sys     0m 0.19s
> 
> Signed-off-by: Vineet Gupta <vgupta@synopsys.com>

Applied.
