Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502AbaCETN7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 14:13:59 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:41673 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbaCETN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 14:13:57 -0500
X-IronPort-AV: E=Sophos;i="4.97,594,1389744000"; 
   d="scan'208";a="106939057"
Message-ID: <53177772.60304@citrix.com>
Date: Wed, 5 Mar 2014 19:13:54 +0000
From: Zoltan Kiss <zoltan.kiss@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Wei Liu <wei.liu2@citrix.com>
CC: <ian.campbell@citrix.com>, <xen-devel@lists.xenproject.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <jonathan.davies@citrix.com>
Subject: Re: [PATCH net-next v6 1/10] xen-netback: Use skb->cb for pending_idx
References: <1393972341-21135-1-git-send-email-zoltan.kiss@citrix.com> <1393972341-21135-2-git-send-email-zoltan.kiss@citrix.com> <20140305121637.GF19620@zion.uk.xensource.com>
In-Reply-To: <20140305121637.GF19620@zion.uk.xensource.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.133]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/14 12:16, Wei Liu wrote:
> On Tue, Mar 04, 2014 at 10:32:12PM +0000, Zoltan Kiss wrote:
>> Storing the pending_idx at the first byte of the linear buffer never looked
>> good, skb->cb is a more proper place for this. It also prevents the header to
>> be directly grant copied there, and we don't have the pending_idx after we
>> copied the header here, so it's time to change it.
>>
>
> I think this is a valid change. But I would like you to define a
> skb_cb_overlay just like the receive path does.
>
> You can rename skb_cb_overlay in current code to skb_cb_overlay_rx and
> add your skb_cb_overlay_tx.

Ok

