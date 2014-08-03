Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163AbaHCJL1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 05:11:27 -0400
Received: from smtp.citrix.com ([66.165.176.89]:21529 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305AbaHCJLZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 05:11:25 -0400
X-IronPort-AV: E=Sophos;i="5.01,791,1400025600"; 
   d="scan'208";a="158251362"
Date: Sun, 3 Aug 2014 10:11:10 +0100
From: Wei Liu <wei.liu2@citrix.com>
To: David Miller <davem@davemloft.net>
CC: <wei.liu2@citrix.com>, <zoltan.kiss@citrix.com>, <konrad.wilk@oracle.com>,
        <boris.ostrovsky@oracle.com>, <david.vrabel@citrix.com>,
        <Ian.Campbell@citrix.com>, <paul.durrant@citrix.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xenproject.org>
Subject: Re: [PATCH] xen-netfront: Fix handling packets on compound pages
 with skb_segment
Message-ID: <20140803091110.GA7093@zion.uk.xensource.com>
References: <1406726730-17994-1-git-send-email-zoltan.kiss@citrix.com>
 <20140731.132520.1889577477638334755.davem@davemloft.net>
 <20140801110246.GB17947@zion.uk.xensource.com>
 <20140802.153337.1399638752235662112.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140802.153337.1399638752235662112.davem@davemloft.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 02, 2014 at 03:33:37PM -0700, David Miller wrote:
> From: Wei Liu <wei.liu2@citrix.com>
> Date: Fri, 1 Aug 2014 12:02:46 +0100
> 
> > On Thu, Jul 31, 2014 at 01:25:20PM -0700, David Miller wrote:
> >> If you were to have a 64-slot TX queue, you ought to be able to handle
> >> this theoretical 51 slot SKB.
> > 
> > There's two problems:
> > 1. IIRC a single page ring has 256 slots, allowing 64 slots packet
> >    yields 4 in-flight packets in worst case.
> > 2. Older netback could not handle this large number of slots and it's
> >    likely to deem the frontend malicious.
> > 
> > For #1, we don't actually care that much if guest screws itself by
> > generating 64 slot packets. #2 is more concerning.
> 
> How many slots can the older netback handle?

I listed those two problems in the context "if we were to lift this
limit in the latest net-next tree", so "older netback" actually refers
to netback from 3.10 to 3.16.

The current implementation allows the number of slots X:
 1. X <= 18, valid packet
 2. 18 < X < fatal_slot_count, dropped
 3. X >= fatal_slot_count, malicious frontend

fatal_slot_count has default value of 20.

Wei.

> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
