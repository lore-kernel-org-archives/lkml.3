Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258AbaDNBkW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 21:40:22 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49110 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754171AbaDNBkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 21:40:17 -0400
Date: Sun, 13 Apr 2014 21:40:04 -0400 (EDT)
Message-Id: <20140413.214004.1087903132047842986.davem@davemloft.net>
To: sgalgano@adjacentlink.com
Cc: mst@redhat.com, jasowang@redhat.com, xemul@parallels.com,
        wuzhy@linux.vnet.ibm.com, therbert@google.com, yamato@redhat.com,
        richardcochran@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Brian.Adamson@nrl.navy.mil,
        jgiovatto@adjacentlink.com
Subject: Re: [PATCH v2] tuntap: add flow control to support back pressure
From: David Miller <davem@davemloft.net>
In-Reply-To: <534B3A33.9090401@adjacentlink.com>
References: <5347487B.4040608@adjacentlink.com>
	<20140413141745.GB17839@redhat.com>
	<534B3A33.9090401@adjacentlink.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 13 Apr 2014 18:40:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Galgano <sgalgano@adjacentlink.com>
Date: Sun, 13 Apr 2014 21:30:27 -0400

> Added optional per queue flow control support using IFF_FLOW_CONTROL. When the IFF_FLOW_CONTROL TUNSETIFF flag is specified it will set a per queue flag to indicate that the queue should be stopped using netif_tx_stop_queue(), rather than discarding frames once full. After reading a frame from the respective stopped queue, a netif_tx_wake_queue() is issued to signal resource availability.
> 
> The per queue TUN_FLOW_CONTROL flag is stored in struct tun_file. This provides the flexibility to enable flow control on all, none or some queues when using IFF_MULTI_QUEUE. When not using IFF_MULTI_QUEUE, IFF_FLOW_CONTROL will apply to the single queue. No changes were made to the default drop frame policy.
> 
> This change adds support for back pressure use cases.
> 
> Reported-by: Brian Adamson <brian.adamson@nrl.navy.mil>
> Tested-by: Joseph Giovatto <jgiovatto@djacentlink.com>
> Signed-off-by: Steven Galgano <sgalgano@adjacentlink.com>

Please format your commit messages to ~80 columns of text.

It won't be automatically formatted by GIT and in fact it looks ugly
with all the wrapping in text based tools.
