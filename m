Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102Ab3G1DJn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 23:09:43 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:52096 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968Ab3G1DJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 23:09:41 -0400
Date: Sat, 27 Jul 2013 20:09:40 -0700 (PDT)
Message-Id: <20130727.200940.1407377271115722165.davem@davemloft.net>
To: jasowang@redhat.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, basil.gor@gmail.com,
        mst@redhat.com
Subject: Re: [PATCH net-next V2] tuntap: hardware vlan tx support
From: David Miller <davem@davemloft.net>
In-Reply-To: <1374728433-19843-1-git-send-email-jasowang@redhat.com>
References: <1374728433-19843-1-git-send-email-jasowang@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Sat, 27 Jul 2013 20:09:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Thu, 25 Jul 2013 13:00:33 +0800

> Inspired by commit f09e2249c4f5c7c13261ec73f5a7807076af0c8e (macvtap: restore
> vlan header on user read). This patch adds hardware vlan tx support for
> tuntap. This is done by copying vlan header directly into userspace in
> tun_put_user() instead of doing it through __vlan_put_tag() in
> dev_hard_start_xmit(). This eliminates one unnecessary memmove() in
> vlan_insert_tag() for 802.1ad and 802.1q traffic.
> 
> pktgen test shows about 20% improvement for 802.1q traffic:
> 
> Before:
>   662149pps 317Mb/sec (317831520bps) errors: 0
> After:
>   801033pps 384Mb/sec (384495840bps) errors: 0
> 
> Cc: Basil Gor <basil.gor@gmail.com>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Applied, thanks Jason.
