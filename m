Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860AbaHFSZI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 14:25:08 -0400
Received: from smtp.citrix.com ([66.165.176.89]:58234 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754641AbaHFSZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 14:25:07 -0400
X-IronPort-AV: E=Sophos;i="5.01,813,1400025600"; 
   d="scan'208";a="159402360"
Message-ID: <53E272FF.6030603@citrix.com>
Date: Wed, 6 Aug 2014 19:25:03 +0100
From: Zoltan Kiss <zoltan.kiss@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Wei Liu <wei.liu2@citrix.com>
CC: Ian Campbell <Ian.Campbell@citrix.com>,
        David Vrabel <david.vrabel@citrix.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>
Subject: Re: [PATCH net-next 1/2] xen-netback: Using a new state bit instead
 of carrier
References: <1407165658-20146-1-git-send-email-zoltan.kiss@citrix.com> <1407165658-20146-2-git-send-email-zoltan.kiss@citrix.com> <20140805124545.GD11230@zion.uk.xensource.com>
In-Reply-To: <20140805124545.GD11230@zion.uk.xensource.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/14 13:45, Wei Liu wrote:
> On Mon, Aug 04, 2014 at 04:20:57PM +0100, Zoltan Kiss wrote:
>> This patch introduces a new state bit VIF_STATUS_CONNECTED to track whether the
>> vif is in a connected state. Using carrier will not work with the next patch
>> in this series, which aims to turn the carrier temporarily off if the guest
>> doesn't seem to be able to receive packets.
>>
>> Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
>> Signed-off-by: David Vrabel <david.vrabel@citrix.com>
>> Cc: netdev@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> Cc: xen-devel@lists.xenproject.org
>>
>> v2:
>> - rename the bitshift type to "enum state_bit_shift" here, not in the next patch
>>
>> diff --git a/drivers/net/xen-netback/common.h b/drivers/net/xen-netback/common.h
>> index 28c9822..4a92fc1 100644
>> --- a/drivers/net/xen-netback/common.h
>> +++ b/drivers/net/xen-netback/common.h
>> @@ -198,6 +198,11 @@ struct xenvif_queue { /* Per-queue data for xenvif */
>>   	struct xenvif_stats stats;
>>   };
>>
>> +enum state_bit_shift {
>> +	/* This bit marks that the vif is connected */
>> +	VIF_STATUS_CONNECTED
>
> This bit shift applies to vif.  In the following patch you introduce two
> more bits specifically for queues. IMHO we should avoid mixing things
> up. What about having two enums
>
>    enum vif_state_bit_shift {}
>    enum queue_state_bit_shift {}

I think it would be a bit overdoing it, this enum type is never used in 
declaration.

