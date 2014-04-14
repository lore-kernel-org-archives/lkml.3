Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754990AbaDNRZk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 13:25:40 -0400
Received: from smtp.citrix.com ([66.165.176.89]:38834 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828AbaDNRZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 13:25:38 -0400
X-IronPort-AV: E=Sophos;i="4.97,858,1389744000"; 
   d="scan'208";a="120936562"
Message-ID: <534C1A0E.1080307@citrix.com>
Date: Mon, 14 Apr 2014 18:25:34 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: <v.maffione@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>,
        <boris.ostrovsky@oracle.com>
Subject: Re: [Xen-devel] [PATCH] drivers: net: xen-netfront: fix array initialization
 bug
References: <1397296540-3007-1-git-send-email-v.maffione@gmail.com>	<20140412.165152.1877473530496221304.davem@davemloft.net>	<534BAD7C.6090107@citrix.com> <20140414.125131.1934050779129550948.davem@davemloft.net>
In-Reply-To: <20140414.125131.1934050779129550948.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/04/14 17:51, David Miller wrote:
> From: David Vrabel <david.vrabel@citrix.com>
> Date: Mon, 14 Apr 2014 10:42:20 +0100
> 
>> On 12/04/14 21:51, David Miller wrote:
>>> From: Vincenzo Maffione <v.maffione@gmail.com>
>>> Date: Sat, 12 Apr 2014 11:55:40 +0200
>>>
>>>> This patch fixes the initialization of an array used in the TX
>>>> datapath that was mistakenly initialized together with the
>>>> RX datapath arrays. An out of range array access could happen
>>>> when RX and TX rings had different sizes.
>>>>
>>>> Signed-off-by: Vincenzo Maffione <v.maffione@gmail.com>
>>>
>>> Good catch, applied, thanks.
>>
>> Thanks.  You can queue this for net-next since the Tx and Rx rings are
>> the same constant size.
> 
> I was able to determine when I reviewed this patch that the size in bytes
> of the rings are the same (PAGE_SIZE), but I couldn't ascertain whether
> the individual ring entries in the TX ring and RX ring are the same size.
> 
> Are they?

Yes.  It's not at all obvious, but each ends up with 256 entries.

Tx entries are 12 bytes and Rx entries are 8 bytes.  The ring macros
reserve some space in the shared page for the producer/consumer indexes
/and/ round down the number to the next power of two.

David

