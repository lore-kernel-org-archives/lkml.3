Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934AbaCMKUC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 06:20:02 -0400
Received: from smtp.citrix.com ([66.165.176.89]:39552 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753908AbaCMKRV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 06:17:21 -0400
X-IronPort-AV: E=Sophos;i="4.97,646,1389744000"; 
   d="scan'208";a="110950477"
Date: Thu, 13 Mar 2014 10:17:20 +0000
From: Wei Liu <wei.liu2@citrix.com>
To: Zoltan Kiss <zoltan.kiss@citrix.com>
CC: <ian.campbell@citrix.com>, <wei.liu2@citrix.com>,
        <xen-devel@lists.xenproject.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <jonathan.davies@citrix.com>
Subject: Re: [PATCH net-next] xen-netback: Schedule NAPI from dealloc thread
 instead of callback
Message-ID: <20140313101720.GA16807@zion.uk.xensource.com>
References: <1394658281-2488-1-git-send-email-zoltan.kiss@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1394658281-2488-1-git-send-email-zoltan.kiss@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 09:04:41PM +0000, Zoltan Kiss wrote:
> If there are unconsumed requests in the ring, but there isn't enough free
> pending slots, the NAPI instance deschedule itself. As the frontend won't send
> any more interrupts in this case, it is the task of whoever release the pending
> slots to schedule the NAPI instance in this case. Originally it was done in the
> callback, but it's better at the end of the dealloc thread, otherwise there is
> a risk that the NAPI instance just deschedule itself as the dealloc thread
> couldn't release any used slot yet. However, as there are a lot of pending
> packets, NAPI will be scheduled again, and it is very unlikely that the dealloc
> thread can't release enough slots in the meantime.
> 

So this patch restores the property that "only two parties access the
ring", right?

Wei.
