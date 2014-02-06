Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832AbaBFAY3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 19:24:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22632 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753230AbaBFAY2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 19:24:28 -0500
Date: Wed, 05 Feb 2014 16:24:22 -0800 (PST)
Message-Id: <20140205.162422.857987635200528036.davem@redhat.com>
To: zoltan.kiss@citrix.com
Cc: ian.campbell@citrix.com, wei.liu2@citrix.com,
        xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jonathan.davies@citrix.com
Subject: Re: [PATCH net v3] xen-netback: Fix Rx stall due to race condition 
From: David Miller <davem@redhat.com>
In-Reply-To: <1391543677-24039-1-git-send-email-zoltan.kiss@citrix.com>
References: <1391543677-24039-1-git-send-email-zoltan.kiss@citrix.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zoltan Kiss <zoltan.kiss@citrix.com>
Date: Tue, 4 Feb 2014 19:54:37 +0000

> The recent patch to fix receive side flow control
> (11b57f90257c1d6a91cee720151b69e0c2020cf6: xen-netback: stop vif thread
> spinning if frontend is unresponsive) solved the spinning thread problem,
> however caused an another one. The receive side can stall, if:
> - [THREAD] xenvif_rx_action sets rx_queue_stopped to true
> - [INTERRUPT] interrupt happens, and sets rx_event to true
> - [THREAD] then xenvif_kthread sets rx_event to false
> - [THREAD] rx_work_todo doesn't return true anymore
> 
> Also, if interrupt sent but there is still no room in the ring, it take quite a
> long time until xenvif_rx_action realize it. This patch ditch that two variable,
> and rework rx_work_todo. If the thread finds it can't fit more skb's into the
> ring, it saves the last slot estimation into rx_last_skb_slots, otherwise it's
> kept as 0. Then rx_work_todo will check if:
> - there is something to send to the ring (like before)
> - there is space for the topmost packet in the queue
> 
> I think that's more natural and optimal thing to test than two bool which are
> set somewhere else.
> 
> Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
> Reviewed-by: Paul Durrant <paul.durrant@citrix.com>
> Acked-by: Wei Liu <wei.liu2@citrix.com>

Applied, thanks.
