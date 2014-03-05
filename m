Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314AbaCEMQl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 07:16:41 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:39611 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbaCEMQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 07:16:39 -0500
X-IronPort-AV: E=Sophos;i="4.97,592,1389744000"; 
   d="scan'208";a="106772862"
Date: Wed, 5 Mar 2014 12:16:37 +0000
From: Wei Liu <wei.liu2@citrix.com>
To: Zoltan Kiss <zoltan.kiss@citrix.com>
CC: <ian.campbell@citrix.com>, <wei.liu2@citrix.com>,
        <xen-devel@lists.xenproject.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <jonathan.davies@citrix.com>
Subject: Re: [PATCH net-next v6 1/10] xen-netback: Use skb->cb for pending_idx
Message-ID: <20140305121637.GF19620@zion.uk.xensource.com>
References: <1393972341-21135-1-git-send-email-zoltan.kiss@citrix.com>
 <1393972341-21135-2-git-send-email-zoltan.kiss@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1393972341-21135-2-git-send-email-zoltan.kiss@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2014 at 10:32:12PM +0000, Zoltan Kiss wrote:
> Storing the pending_idx at the first byte of the linear buffer never looked
> good, skb->cb is a more proper place for this. It also prevents the header to
> be directly grant copied there, and we don't have the pending_idx after we
> copied the header here, so it's time to change it.
> 

I think this is a valid change. But I would like you to define a
skb_cb_overlay just like the receive path does.

You can rename skb_cb_overlay in current code to skb_cb_overlay_rx and
add your skb_cb_overlay_tx.

Wei.
