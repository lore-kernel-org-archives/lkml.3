Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373AbaDCSWd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 14:22:33 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46014 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337AbaDCSWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 14:22:05 -0400
Date: Thu, 03 Apr 2014 14:23:38 -0400 (EDT)
Message-Id: <20140403.142338.566501064461610448.davem@davemloft.net>
To: zoltan.kiss@citrix.com
Cc: ian.campbell@citrix.com, wei.liu2@citrix.com,
        xen-devel@lists.xenproject.org, paul.durrant@citrix.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jonathan.davies@citrix.com
Subject: Re: [PATCH net-next v3 2/2] xen-netback: Grant copy the header
 instead of map and memcpy
From: David Miller <davem@davemloft.net>
In-Reply-To: <1396458298-30041-2-git-send-email-zoltan.kiss@citrix.com>
References: <1396458298-30041-1-git-send-email-zoltan.kiss@citrix.com>
	<1396458298-30041-2-git-send-email-zoltan.kiss@citrix.com>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 03 Apr 2014 11:22:05 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zoltan Kiss <zoltan.kiss@citrix.com>
Date: Wed, 2 Apr 2014 18:04:58 +0100

> An old inefficiency of the TX path that we are grant mapping the first slot,
> and then copy the header part to the linear area. Instead, doing a grant copy
> for that header straight on is more reasonable. Especially because there are
> ongoing efforts to make Xen avoiding TLB flush after unmap when the page were
> not touched in Dom0. In the original way the memcpy ruined that.
> The key changes:
> - the vif has a tx_copy_ops array again
> - xenvif_tx_build_gops sets up the grant copy operations
> - we don't have to figure out whether the header and first frag are on the same
>   grant mapped page or not
> Note, we only grant copy PKT_PROT_LEN bytes from the first slot, the rest (if
> any) will be on the first frag, which is grant mapped. If the first slot is
> smaller than PKT_PROT_LEN, then we grant copy that, and later __pskb_pull_tail
> will pull more from the frags (if any)
> 
> Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>

Applied.
