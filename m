Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757114Ab3JOBnW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 21:43:22 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33609 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756959Ab3JOBnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 21:43:21 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <525C9D86.1020502@jp.fujitsu.com>
Date: Tue, 15 Oct 2013 10:42:30 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <toshi.kani@hp.com>,
        <sjenning@linux.vnet.ibm.com>
Subject: Re: [PATCH] Release device_hotplug_lock when store_mem_state returns
 EINVAL
References: <52579C69.1080304@jp.fujitsu.com> <20131011155454.GA32305@kroah.com>
In-Reply-To: <20131011155454.GA32305@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

(2013/10/12 0:54), Greg KH wrote:
> On Fri, Oct 11, 2013 at 03:36:25PM +0900, Yasuaki Ishimatsu wrote:
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
> Is this needed in 3.12-final, and possibly older kernel releases as well
> (3.10, 3.11, etc.)?  Or is it ok for 3.13?

The patch is needed in 3.12 because this problem has occurred since 3.12-rc1.

Thanks,
Yasuaki Ishimatsu

>
> thanks,
>
> greg k-h
>


