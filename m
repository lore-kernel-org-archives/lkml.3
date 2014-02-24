Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750AbaBXPbW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 10:31:22 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:41653 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181AbaBXPbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 10:31:20 -0500
X-IronPort-AV: E=Sophos;i="4.97,535,1389744000"; 
   d="scan'208";a="103565992"
Message-ID: <530B65C5.4040201@citrix.com>
Date: Mon, 24 Feb 2014 15:31:17 +0000
From: Zoltan Kiss <zoltan.kiss@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: <wei.liu2@citrix.com>, <xen-devel@lists.xenproject.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <jonathan.davies@citrix.com>
Subject: Re: [PATCH net-next v5 0/9] xen-netback: TX grant mapping with SKBTX_DEV_ZEROCOPY
 instead of copy
References: <1390253069-25507-1-git-send-email-zoltan.kiss@citrix.com> <1392803434.23084.97.camel@kazak.uk.xensource.com>
In-Reply-To: <1392803434.23084.97.camel@kazak.uk.xensource.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.68.14.50]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/02/14 09:50, Ian Campbell wrote:
> On Mon, 2014-01-20 at 21:24 +0000, Zoltan Kiss wrote:
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
>> know when the skb is freed up. That is the way KVM solved the same problem,
>> and based on my initial tests it can do the same for us. Avoiding the extra
>> copy boosted up TX throughput from 6.8 Gbps to 7.9 (I used a slower
>> Interlagos box, both Dom0 and guest on upstream kernel, on the same NUMA node,
>> running iperf 2.0.5, and the remote end was a bare metal box on the same 10Gb
>> switch)
>> Based on my investigations the packet get only copied if it is delivered to
>> Dom0 stack,
> This is not quite complete/accurate since you previously told me that it
> is copied in the NAT/routed rather than bridged network topologies.
>
> Please can you cover that aspect here too.
Ok.

Zoli
