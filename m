Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968AbaLAN1x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 08:27:53 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:39288 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532AbaLAN1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 08:27:51 -0500
X-IronPort-AV: E=Sophos;i="5.07,493,1413244800"; 
   d="scan'208";a="198382904"
Message-ID: <547C6CC4.9070605@citrix.com>
Date: Mon, 1 Dec 2014 13:27:32 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>, <seth.forshee@canonical.com>
CC: <zoltan.kiss@linaro.org>, <eric.dumazet@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stefan.bader@canonical.com>, <david.vrabel@citrix.com>,
        <xen-devel@lists.xenproject.org>, <boris.ostrovsky@oracle.com>
Subject: Re: [Xen-devel] [PATCH] xen-netfront: Remove BUGs on paged skb data
 which crosses a page boundary
References: <1416968904-70874-1-git-send-email-seth.forshee@canonical.com> <20141126.122812.223757363894961994.davem@davemloft.net>
In-Reply-To: <20141126.122812.223757363894961994.davem@davemloft.net>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/11/14 17:28, David Miller wrote:
> From: Seth Forshee <seth.forshee@canonical.com>
> Date: Tue, 25 Nov 2014 20:28:24 -0600
> 
>> These BUGs can be erroneously triggered by frags which refer to
>> tail pages within a compound page. The data in these pages may
>> overrun the hardware page while still being contained within the
>> compound page, but since compound_order() evaluates to 0 for tail
>> pages the assertion fails. The code already iterates through
>> subsequent pages correctly in this scenario, so the BUGs are
>> unnecessary and can be removed.
>>
>> Fixes: f36c374782e4 ("xen/netfront: handle compound page fragments on transmit")
>> Cc: <stable@vger.kernel.org> # 3.7+
>> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> 
> Can I get some Xen developer reviews?

Sorry for the delay, I've been on holiday.

Reviewed-by: David Vrabel <david.vrabel@citrix.com>

Thanks.

David
