Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766Ab3LPQOC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 11:14:02 -0500
Received: from smtp.citrix.com ([66.165.176.89]:10543 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754736Ab3LPQOA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 11:14:00 -0500
X-IronPort-AV: E=Sophos;i="4.95,495,1384300800"; 
   d="scan'208";a="84968640"
Message-ID: <52AF26B8.2090409@citrix.com>
Date: Mon, 16 Dec 2013 16:13:44 +0000
From: Zoltan Kiss <zoltan.kiss@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: annie li <annie.li@oracle.com>
CC: <ian.campbell@citrix.com>, <wei.liu2@citrix.com>,
        <xen-devel@lists.xenproject.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <jonathan.davies@citrix.com>
Subject: Re: [Xen-devel] [PATCH net-next v2 0/9] xen-netback: TX grant mapping
 with SKBTX_DEV_ZEROCOPY instead of copy
References: <1386892097-15502-1-git-send-email-zoltan.kiss@citrix.com> <52AE9E7E.7040502@oracle.com>
In-Reply-To: <52AE9E7E.7040502@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.133]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/12/13 06:32, annie li wrote:
>
> On 2013/12/13 7:48, Zoltan Kiss wrote:
>> A long known problem of the upstream netback implementation that on
>> the TX
>> path (from guest to Dom0) it copies the whole packet from guest memory
>> into
>> Dom0. That simply became a bottleneck with 10Gb NICs, and generally
>> it's a
>> huge perfomance penalty. The classic kernel version of netback used grant
>> mapping, and to get notified when the page can be unmapped, it used page
>> destructors. Unfortunately that destructor is not an upstreamable
>> solution.
>> Ian Campbell's skb fragment destructor patch series [1] tried to solve
>> this
>> problem, however it seems to be very invasive on the network stack's
>> code,
>> and therefore haven't progressed very well.
>> This patch series use SKBTX_DEV_ZEROCOPY flags to tell the stack it
>> needs to
>> know when the skb is freed up. That is the way KVM solved the same
>> problem,
>> and based on my initial tests it can do the same for us. Avoiding the
>> extra
>> copy boosted up TX throughput from 6.8 Gbps to 7.9 (I used a slower
>> Interlagos box, both Dom0 and guest on upstream kernel, on the same
>> NUMA node,
>> running iperf 2.0.5, and the remote end was a bare metal box on the
>> same 10Gb
>> switch)
> Sounds good.
> Is the TX throughput gotten between one vm and one bare metal box? or
> between multiple vms and bare metal? Do you have any test results with
> netperf?
One VM and a bare metal box. I've used only iperf.

Regards,

Zoli

