Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751527AbaB1Dqm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 22:46:42 -0500
Received: from mga09.intel.com ([134.134.136.24]:12816 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957AbaB1Dqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 22:46:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,559,1389772800"; 
   d="scan'208";a="491296861"
Message-ID: <53100677.2060705@intel.com>
Date: Thu, 27 Feb 2014 19:45:59 -0800
From: John Fastabend <john.r.fastabend@intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Ding Tianhong <dingtianhong@huawei.com>
CC: Patrick McHardy <kaber@trash.net>, "David S. Miller" <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net RESEND] vlan: don't allow to add VLAN on VLAN device
References: <530FF7BF.4030706@huawei.com>
In-Reply-To: <530FF7BF.4030706@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/27/2014 6:43 PM, Ding Tianhong wrote:
> I run these steps:
>
> modprobe 8021q
> vconfig add eth2 20
> vconfig add eth2.20 20
> ifconfig eth2 xx.xx.xx.xx
>
> then the Call Trace happened:
>

[...]

> ========================================================================
>
> The reason is that if add vlan on vlan dev, the vlan dev will create vlan_info,
> then the notification will let the real dev to run dev_set_rx_mode() and hold
> netif_addr_lock, and then the real dev will call ndo_set_rx_mode(), if the real
> dev is vlan dev, the ndo_set_rx_mode() will hold netif_addr_lock again, so deadlock
> happened.
>
> Don't allow to add vlan on vlan dev to fix this problem.
>
> Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>
> ---

I'm not sure we can just disable stacked vlans. There might be something
using them today and they have worked in the past. Lets try to find a
better fix.

.John
