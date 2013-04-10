Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556Ab3DJSnj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 14:43:39 -0400
Received: from carbon.coolservecorp.net ([184.82.167.18]:49502 "EHLO
	carbon.coolservecorp.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975Ab3DJSni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 14:43:38 -0400
Message-ID: <5165B284.9020700@grapecom.com>
Date: Wed, 10 Apr 2013 21:42:12 +0300
From: Elijah Ragozin <illia.ragozin@grapecom.com>
Organization: Grapecom
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jason Cooper <jason@lakedaemon.net>
CC: Russell King <linux@arm.linux.org.uk>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH RESEND v2 1/1] ARM Feroceon: fix kexec by setting outer_cache.inv_all
References: <51631B12.2010908@grapecom.com> <51631BAF.40408@grapecom.com> <20130410164805.GA28693@titan.lakedaemon.net>
In-Reply-To: <20130410164805.GA28693@titan.lakedaemon.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - carbon.coolservecorp.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - grapecom.com
X-Get-Message-Sender-Via: carbon.coolservecorp.net: authenticated_id: illia.ragozin+grapecom.com/only user confirmed/virtual account not confirmed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10.04.2013 19:48, Jason Cooper wrote:
> On Mon, Apr 08, 2013 at 10:34:07PM +0300, Elijah Ragozin wrote:
>> On Feroceon the L2 cache becomes non-coherent with the CPU
>> when the L1 caches are disabled. Thus the L2 needs to be invalidated
>> after both L1 caches are disabled.
>>
>> On kexec before the starting the code for relocation the kernel,
>> the L1 caches are disabled in cpu_froc_fin (cpu_v7_proc_fin for Feroceon),
>> but after L2 cache is never invalidated, because inv_all is not set
>> in cache-feroceon-l2.c.
>> So kernel relocation and decompression may has (and usually has) errors.
>> Setting the function enables L2 invalidation and fixes the issue.
>>
>> Signed-off-by: Illia Ragozin <illia.ragozin@grapecom.com>
>> ---
>>   arch/arm/mm/cache-feroceon-l2.c | 1 +
>>   1 file changed, 1 insertion(+)
> fwiw,
>
> Acked-by: Jason Cooper <jason@lakedaemon.net>
>
> Please put this in Russell King's patch tracker so he can pull it in.
>
> thx,
>
> Jason.
>

Jason,

thank you for reviewing and acking,
I just put the patch to the Russell King's patch tracker.

-- 
Best Regards,
Illia Ragozin.

