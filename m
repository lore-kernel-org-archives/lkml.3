Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272AbaAWNGQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 08:06:16 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:34072 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbaAWNGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 08:06:15 -0500
X-IronPort-AV: E=Sophos;i="4.95,706,1384300800"; 
   d="scan'208";a="93672771"
Message-ID: <52E113AE.5060405@citrix.com>
Date: Thu, 23 Jan 2014 13:05:50 +0000
From: Zoltan Kiss <zoltan.kiss@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, <ian.campbell@citrix.com>,
        <wei.liu2@citrix.com>, <xen-devel@lists.xenproject.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <jonathan.davies@citrix.com>
Subject: Re: [Xen-devel] [PATCH v3] xen/grant-table: Avoid m2p_override during
 mapping
References: <1390244288-3186-1-git-send-email-zoltan.kiss@citrix.com> <a6736948-c67e-4509-89a8-42ec9693830f@email.android.com>
In-Reply-To: <a6736948-c67e-4509-89a8-42ec9693830f@email.android.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.133]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/01/14 21:22, Konrad Rzeszutek Wilk wrote:
> Zoltan Kiss <zoltan.kiss@citrix.com> wrote:
>> The grant mapping API does m2p_override unnecessarily: only gntdev
>> needs it,
>> for blkback and future netback patches it just cause a lock contention,
>> as
>> those pages never go to userspace. Therefore this series does the
>> following:
>> - the original functions were renamed to __gnttab_[un]map_refs, with a
>> new
>>   parameter m2p_override
>> - based on m2p_override either they follow the original behaviour, or
>> just set
>>   the private flag and call set_phys_to_machine
>> - gnttab_[un]map_refs are now a wrapper to call __gnttab_[un]map_refs
>> with
>>   m2p_override false
>> - a new function gnttab_[un]map_refs_userspace provides the old
>> behaviour
>
> You don't say anything about the 'return ret' changed to 'return 0'.
>
> Any particular reason for that?

That's the only possible return value there, so it just makes it more 
obvious. I'll add a description about that.

Zoli

