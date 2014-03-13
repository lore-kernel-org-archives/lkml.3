Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776AbaCMK4a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 06:56:30 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:51517 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753483AbaCMK43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 06:56:29 -0400
X-IronPort-AV: E=Sophos;i="4.97,646,1389744000"; 
   d="scan'208";a="109514706"
Message-ID: <53218EDA.8040904@citrix.com>
Date: Thu, 13 Mar 2014 10:56:26 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: Zoltan Kiss <zoltan.kiss@citrix.com>, <xen-devel@lists.xenproject.org>,
        <jonathan.davies@citrix.com>, <wei.liu2@citrix.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH net-next v7 4/9] xen-netback: Introduce TX
 grant mapping
References: <1394142511-14827-1-git-send-email-zoltan.kiss@citrix.com>	<1394142511-14827-5-git-send-email-zoltan.kiss@citrix.com> <1394706812.25873.28.camel@kazak.uk.xensource.com>
In-Reply-To: <1394706812.25873.28.camel@kazak.uk.xensource.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/03/14 10:33, Ian Campbell wrote:
> On Thu, 2014-03-06 at 21:48 +0000, Zoltan Kiss wrote:
>> @@ -135,13 +146,31 @@ struct xenvif {
>>  	pending_ring_idx_t pending_cons;
>>  	u16 pending_ring[MAX_PENDING_REQS];
>>  	struct pending_tx_info pending_tx_info[MAX_PENDING_REQS];
>> +	grant_handle_t grant_tx_handle[MAX_PENDING_REQS];
>>  
>>  	/* Coalescing tx requests before copying makes number of grant
>>  	 * copy ops greater or equal to number of slots required. In
>>  	 * worst case a tx request consumes 2 gnttab_copy.
>>  	 */
>>  	struct gnttab_copy tx_copy_ops[2*MAX_PENDING_REQS];
>> -
>> +	struct gnttab_map_grant_ref tx_map_ops[MAX_PENDING_REQS];
>> +	struct gnttab_unmap_grant_ref tx_unmap_ops[MAX_PENDING_REQS];
> 
> I wonder if we should break some of these arrays into separate
> allocations? Wasn't there a problem with sizeof(struct xenvif) at one
> point?

alloc_netdev() falls back to vmalloc() if the kmalloc failed so there's
no need to split these structures.

David
