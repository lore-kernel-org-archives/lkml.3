Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977Ab3IEQrG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 12:47:06 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:34004 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888Ab3IEQrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 12:47:05 -0400
Date: Thu, 05 Sep 2013 12:47:02 -0400 (EDT)
Message-Id: <20130905.124702.1612563649224221301.davem@davemloft.net>
To: jasowang@redhat.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, mst@redhat.com,
        richardcochran@gmail.com, sergei.shtylyov@cogentembedded.com
Subject: Re: [PATCH V2 net-next 2/2] tuntap: orphan frags before trying to
 set tx timestamp
From: David Miller <davem@davemloft.net>
In-Reply-To: <1378374840-39130-2-git-send-email-jasowang@redhat.com>
References: <1378374840-39130-1-git-send-email-jasowang@redhat.com>
	<1378374840-39130-2-git-send-email-jasowang@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 05 Sep 2013 09:47:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Thu,  5 Sep 2013 17:54:00 +0800

> sock_tx_timestamp() will clear all zerocopy flags of skb which may lead the
> frags never to be orphaned. This will break guest to guest traffic when zerocopy
> is enabled. Fix this by orphaning the frags before trying to set tx time stamp.
> 
> The issue were introduced by commit eda297729171fe16bf34fe5b0419dfb69060f623
> (tun: Support software transmit time stamping).
> 
> Cc: Richard Cochran <richardcochran@gmail.com>
> Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> Acked-by: Richard Cochran <richardcochran@gmail.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Applied.

I also queued both of these patches to -stable.

Thanks.
