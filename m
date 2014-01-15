Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751535AbaAOKhZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 05:37:25 -0500
Received: from smtp.citrix.com ([66.165.176.89]:48773 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010AbaAOKhX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 05:37:23 -0500
X-IronPort-AV: E=Sophos;i="4.95,662,1384300800"; 
   d="scan'208";a="93031440"
Date: Wed, 15 Jan 2014 10:37:07 +0000
From: Wei Liu <wei.liu2@citrix.com>
To: Zoltan Kiss <zoltan.kiss@citrix.com>
CC: <ian.campbell@citrix.com>, <wei.liu2@citrix.com>,
        <xen-devel@lists.xenproject.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <jonathan.davies@citrix.com>
Subject: Re: [PATCH net-next] xen-netback: Rework rx_work_todo
Message-ID: <20140115103707.GI5698@zion.uk.xensource.com>
References: <1389727719-21439-1-git-send-email-zoltan.kiss@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1389727719-21439-1-git-send-email-zoltan.kiss@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 07:28:39PM +0000, Zoltan Kiss wrote:
> The recent patch to fix receive side flow control (11b57f) solved the spinning
> thread problem, however caused an another one. The receive side can stall, if:
> - xenvif_rx_action sets rx_queue_stopped to false
> - interrupt happens, and sets rx_event to true
> - then xenvif_kthread sets rx_event to false
> 

If you mean "rx_work_todo" returns false.

In this case

(!skb_queue_empty(&vif->rx_queue) && !vif->rx_queue_stopped) || vif->rx_event;

can still be true, can't it?

> Also, through rx_event a malicious guest can force the RX thread to spin. This
> patch ditch that two variable, and rework rx_work_todo. If the thread finds it

This seems to be a bigger problem. Can you elaborate?

Wei.

