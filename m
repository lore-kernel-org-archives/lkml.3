Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759957Ab3CZSJ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 14:09:29 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:34350 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759843Ab3CZSJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 14:09:26 -0400
MIME-Version: 1.0
Date: Tue, 26 Mar 2013 11:09:25 -0700
Message-ID: <CAOxq_8P+vxcRKCmuttCh4NA8ZdavFu8R8SzV37WEjW9E5BVu0g@mail.gmail.com>
Subject: RX/dropped counter values for tagged packets
From: Ani Sinha <ani@aristanetworks.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hello everyone :

Please bear with me if you think I said something wrong.

I was looking at the netif_receive_skb() code and it seems to me that
for vlan tagged packets, the counters are manipulated at two different
places. One is from vlan_do_receive() where the receive counters are
incremented. The other counter (the dropped counter) is incremented at
the very end of netif_receive_skb() when there are no takers for this
packet. The dropped counts are incremented for skb->dev->rx_dropped
whereas the receive counts are incremented for the vlan device
specific private stat counter values. When the numbers are reported on
/proc/net/dev (from where ifconfig gets the numbers), these two stat
counters are combined together (see dev_get_stats() where rx_dropped
is added to the device private stat numbers). So if no one is
receiving the tagged packets, it will be reported both as received and
dropped! I wonder whether I am analyzing it wrong or whether no one
has noticed this before or whether this is intentional.

Any  clarification will be greatly appreciated. Again, I could be
wrong looking at the code, so please bear with me.

Thanks
ani
