Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757718AbaHGOST (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 10:18:19 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:56341 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754471AbaHGOSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 10:18:18 -0400
Date: Thu, 7 Aug 2014 18:18:13 +0400
From: Dmitry Popov <ixaphire@qrator.net>
To: Jisheng Zhang <jszhang@marvell.com>
Cc: <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: Weird NET_RX softirq behavior
Message-Id: <20140807181813.37b73927513266381d55ad0d@qrator.net>
In-Reply-To: <20140807171050.77819b10@xhacker>
References: <20140807171050.77819b10@xhacker>
X-Mailer: Sylpheed 3.4.2 (GTK+ 2.24.24; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Aug 2014 17:10:50 +0800
Jisheng Zhang <jszhang@marvell.com> wrote:

> 2. only one netdev in the system: eth0.

There should also be lo (loopback) at least.

> 4. But NET_RX seems abnormal
> ~ # cat /proc/softirqs 
>                     CPU0       CPU1       CPU2       CPU3       
>       NET_RX:     445587        322        983          0
> 
> I'm expecting NET_RX under CPU1, 2, 3 should be zero. Any suggestions
> about this abnormal behavior?

Do you have any loopback traffic? It could be handled by CPU1/2 explaining
non-zero NET_RX counters.
