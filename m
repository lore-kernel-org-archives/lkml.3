Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753668AbaAWNNP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 08:13:15 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:59364 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752888AbaAWNNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 08:13:11 -0500
X-IronPort-AV: E=Sophos;i="4.95,706,1384300800"; 
   d="scan'208";a="93674915"
Message-ID: <52E11563.1090707@citrix.com>
Date: Thu, 23 Jan 2014 13:13:07 +0000
From: Zoltan Kiss <zoltan.kiss@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: <ian.campbell@citrix.com>, <wei.liu2@citrix.com>,
        <xen-devel@lists.xenproject.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <jonathan.davies@citrix.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>
Subject: Re: [PATCH net-next v5 0/9] xen-netback: TX grant mapping with SKBTX_DEV_ZEROCOPY
 instead of copy
References: <1390253069-25507-1-git-send-email-zoltan.kiss@citrix.com> <20140122.175031.873909526743971037.davem@davemloft.net>
In-Reply-To: <20140122.175031.873909526743971037.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.133]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/01/14 01:50, David Miller wrote:
> From: Zoltan Kiss <zoltan.kiss@citrix.com>
> Date: Mon, 20 Jan 2014 21:24:20 +0000
>
>> A long known problem of the upstream netback implementation that on the TX
>> path (from guest to Dom0) it copies the whole packet from guest memory into
>> Dom0. That simply became a bottleneck with 10Gb NICs, and generally it's a
>> huge perfomance penalty. The classic kernel version of netback used grant
>> mapping, and to get notified when the page can be unmapped, it used page
>> destructors. Unfortunately that destructor is not an upstreamable solution.
>> Ian Campbell's skb fragment destructor patch series [1] tried to solve this
>> problem, however it seems to be very invasive on the network stack's code,
>> and therefore haven't progressed very well.
>> This patch series use SKBTX_DEV_ZEROCOPY flags to tell the stack it needs to
>> know when the skb is freed up.
>
> This series does not apply to net-next due to some other recent changes.
>
> Please respin, thanks.

It is already based on two predecessor patches, one which is already 
accepted but not applied yet:

[PATCH net-next v2] xen-netback: Rework rx_work_todo

And the other one is hopefully will be accepted very soon:

[PATCH v5] xen/grant-table: Avoid m2p_override during mapping

Zoli

