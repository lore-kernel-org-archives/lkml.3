Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932362AbaDBOln (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 10:41:43 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:18170 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932183AbaDBOll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 10:41:41 -0400
X-IronPort-AV: E=Sophos;i="4.97,780,1389744000"; 
   d="scan'208";a="116118143"
Message-ID: <533C21A2.7030504@citrix.com>
Date: Wed, 2 Apr 2014 15:41:38 +0100
From: Zoltan Kiss <zoltan.kiss@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>,
        Ian Campbell <Ian.Campbell@citrix.com>
CC: <jonathan.davies@citrix.com>, <wei.liu2@citrix.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <paul.durrant@citrix.com>, <xen-devel@lists.xenproject.org>
Subject: Re: [Xen-devel] [PATCH net-next v2 2/2] xen-netback: Grant copy the
 header instead of map and memcpy
References: <1396278539-27639-1-git-send-email-zoltan.kiss@citrix.com>	<1396278539-27639-2-git-send-email-zoltan.kiss@citrix.com> <1396352440.8667.117.camel@kazak.uk.xensource.com> <533C0C9F.8030205@citrix.com>
In-Reply-To: <533C0C9F.8030205@citrix.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.133]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/14 14:11, David Vrabel wrote:
> On 01/04/14 12:40, Ian Campbell wrote:
>> On Mon, 2014-03-31 at 16:08 +0100, Zoltan Kiss wrote:
>>>
>>>   		__skb_put(skb, data_len);
>>> +		vif->tx_copy_ops[*copy_ops].source.u.ref = txreq.gref;
>>> +		vif->tx_copy_ops[*copy_ops].source.domid = vif->domid;
>>> +		vif->tx_copy_ops[*copy_ops].source.offset = txreq.offset;
>>> +
>>> +		vif->tx_copy_ops[*copy_ops].dest.u.gmfn =
>>> +			virt_to_mfn(skb->data);
>>> +		vif->tx_copy_ops[*copy_ops].dest.domid = DOMID_SELF;
>>> +		vif->tx_copy_ops[*copy_ops].dest.offset =
>>> +			offset_in_page(skb->data);
>>> +
>>> +		vif->tx_copy_ops[*copy_ops].len = data_len;
>>> +		vif->tx_copy_ops[*copy_ops].flags = GNTCOPY_source_gref;
>>
>> We have gnttab_set_map_op. Should we have gnttap_set_copy_op too?
>
> A set of 3 might be useful I think.
>
> gnttab_set_copy_op_ref_to_gfn()
> gnttab_set_copy_op_gfn_to_ref()
> gnttab_set_copy_op_ref_to_ref()
I doubt it would increase clarity in any way, but I'll send a patch on 
top of these.

Zoli
