Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906AbaCETRi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 14:17:38 -0500
Received: from smtp.citrix.com ([66.165.176.89]:44921 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752943AbaCETRg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 14:17:36 -0500
X-IronPort-AV: E=Sophos;i="4.97,594,1389744000"; 
   d="scan'208";a="108470031"
Message-ID: <5317784D.7090306@citrix.com>
Date: Wed, 5 Mar 2014 19:17:33 +0000
From: Zoltan Kiss <zoltan.kiss@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <netdev@vger.kernel.org>, <xen-devel@lists.xenproject.org>,
        <wei.liu2@citrix.com>, <ian.campbell@citrix.com>,
        <jonathan.davies@citrix.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH net-next v6 8/10] xen-netback: Add stat counters
 for frag_list skbs
References: <201403050217.s252HoVa004730@userz7021.oracle.com>
In-Reply-To: <201403050217.s252HoVa004730@userz7021.oracle.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.133]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've changed the numbers to actual patch names, thanks. Btw. your 
replies doesn't have In-reply-to header, it breaks sorting into threads.

Zoli

On 05/03/14 02:17, Konrad Rzeszutek Wilk wrote:
>
> On Mar 4, 2014 5:32 PM, Zoltan Kiss <zoltan.kiss@citrix.com> wrote:
>>
>> These counters help determine how often the guest sends a packet with more
>> than MAX_SKB_FRAGS frags.
>>
>> NOTE: if bisect brought you here, you should apply the series up until #9,
>
> s/#9/"the name of the patch.."
>
>> otherwise malicious guests can block other guests by not releasing their sent
>> packets.
>>
>> Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
>> ---
>> drivers/net/xen-netback/common.h    |    1 +
>> drivers/net/xen-netback/interface.c |    7 +++++++
>> drivers/net/xen-netback/netback.c   |    1 +
>> 3 files changed, 9 insertions(+)
>>
>> diff --git a/drivers/net/xen-netback/common.h b/drivers/net/xen-netback/common.h
>> index eac171e..d8a2298 100644
>> --- a/drivers/net/xen-netback/common.h
>> +++ b/drivers/net/xen-netback/common.h
>> @@ -170,6 +170,7 @@ struct xenvif {
>> unsigned long tx_zerocopy_sent;
>> unsigned long tx_zerocopy_success;
>> unsigned long tx_zerocopy_fail;
>> + unsigned long tx_frag_overflow;
>>
>> /* Miscellaneous private stuff. */
>> struct net_device *dev;
>> diff --git a/drivers/net/xen-netback/interface.c b/drivers/net/xen-netback/interface.c
>> index adfed30..ba5be2f 100644
>> --- a/drivers/net/xen-netback/interface.c
>> +++ b/drivers/net/xen-netback/interface.c
>> @@ -252,6 +252,13 @@ static const struct xenvif_stat {
>> "tx_zerocopy_fail",
>> offsetof(struct xenvif, tx_zerocopy_fail)
>> },
>> + /* Number of packets exceeding MAX_SKB_FRAG slots. You should use
>> + * a guest with the same MAX_SKB_FRAG
>> + */
>> + {
>> + "tx_frag_overflow",
>> + offsetof(struct xenvif, tx_frag_overflow)
>> + },
>> };
>>
>> static int xenvif_get_sset_count(struct net_device *dev, int string_set)
>>
>>
>> _______________________________________________
>> Xen-devel mailing list
>> Xen-devel@lists.xen.org
>> http://lists.xen.org/xen-devel

