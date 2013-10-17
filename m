Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762060Ab3JQCZv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 22:25:51 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57116 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757303Ab3JQCZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 22:25:50 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <525F4A77.1050400@jp.fujitsu.com>
Date: Thu, 17 Oct 2013 11:24:55 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Toshi Kani <toshi.kani@hp.com>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <sjenning@linux.vnet.ibm.com>, <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] Release device_hotplug_lock when store_mem_state returns
 EINVAL
References: <52579C69.1080304@jp.fujitsu.com> <1381509080.26234.32.camel@misato.fc.hp.com>
In-Reply-To: <1381509080.26234.32.camel@misato.fc.hp.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/10/12 1:31), Toshi Kani wrote:
> On Fri, 2013-10-11 at 15:36 +0900, Yasuaki Ishimatsu wrote:
>> When inserting a wrong value to /sys/devices/system/memory/memoryX/state file,
>> following messages are shown. And device_hotplug_lock is never released.
>>
>> ================================================
>> [ BUG: lock held when returning to user space! ]
>> 3.12.0-rc4-debug+ #3 Tainted: G        W
>> ------------------------------------------------
>> bash/6442 is leaving the kernel with locks still held!
>> 1 lock held by bash/6442:
>>   #0:  (device_hotplug_lock){+.+.+.}, at: [<ffffffff8146cbb5>] lock_device_hotplug_sysfs+0x15/0x50
>>
>> This issue was introdued by commit fa2be40 (drivers: base: use standard
>> device online/offline for state change).
>>
>> This patch releases device_hotplug_lcok when store_mem_state returns EINVAL.
>>
>> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
>> CC: Toshi Kani <toshi.kani@hp.com>
>> CC: Seth Jennings <sjenning@linux.vnet.ibm.com>
>> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> Good catch!
>
> Reviewed-by: Toshi Kani <toshi.kani@hp.com>

Thank you for your review.

Thanks,
Yasuaki Ishimatsu



>
> Thanks,
> -Toshi
>


