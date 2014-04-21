Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984AbaDUS5Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 14:57:16 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:32867 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbaDUS5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 14:57:14 -0400
Date: Mon, 21 Apr 2014 14:57:11 -0400 (EDT)
Message-Id: <20140421.145711.1903592201158395025.davem@davemloft.net>
To: haiyangz@microsoft.com
Cc: netdev@vger.kernel.org, kys@microsoft.com, olaf@aepfle.de,
        jasowang@redhat.com, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org
Subject: Re: [PATCH net-next,1/2] hyperv: Remove recv_pkt_list and lock
From: David Miller <davem@davemloft.net>
In-Reply-To: <1398108376-4857-1-git-send-email-haiyangz@microsoft.com>
References: <1398108376-4857-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 21 Apr 2014 11:57:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>
Date: Mon, 21 Apr 2014 12:26:15 -0700

> @@ -401,8 +401,6 @@ static void rndis_filter_receive_data(struct rndis_device *dev,
>  	pkt->total_data_buflen = rndis_pkt->data_len;
>  	pkt->data = (void *)((unsigned long)pkt->data + data_offset);
>  
> -	pkt->is_data_pkt = true;
> -
>  	vlan = rndis_get_ppi(rndis_pkt, IEEE_8021Q_INFO);
>  	if (vlan) {
>  		pkt->vlan_tci = VLAN_TAG_PRESENT | vlan->vlanid |

This part of your change is not explained at all in your commit message.

Please resubmit this series with this hunk properly described and
accounted for.
