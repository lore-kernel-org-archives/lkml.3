Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034AbaDQRvR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 13:51:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19475 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001AbaDQRvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 13:51:12 -0400
Message-ID: <5350147A.10403@redhat.com>
Date: Thu, 17 Apr 2014 12:50:50 -0500
From: David Milburn <dmilburn@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130917 Thunderbird/17.0.9
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Alexander Gordeev <agordeev@redhat.com>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org
Subject: Re: [PATCH 1/1] ahci: Do not receive interrupts sent by dummy ports
References: <cover.1397750166.git.agordeev@redhat.com> <dbaed51ffe73dec1966eba256c3b42ed22ed58f3.1397750166.git.agordeev@redhat.com> <20140417170641.GR15326@htj.dyndns.org>
In-Reply-To: <20140417170641.GR15326@htj.dyndns.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2014 12:06 PM, Tejun Heo wrote:
> On Thu, Apr 17, 2014 at 06:06:15PM +0200, Alexander Gordeev wrote:
>> In multiple MSI mode all AHCI ports (including dummy) get
>> assigned separate MSI vectors and (as result of execution
>> pci_enable_msi_exact() function) separate IRQ numbers,
>> (mapped to the MSI vectors).
>>
>> Therefore, although interrupts from dummy ports are not
>> desired they are still enabled. We do not request IRQs
>> for dummy ports, but that only means we do not assign
>> AHCI-specific ISRs to corresponding IRQ numbers.
>>
>> As result, dummy port interrupts still could come and
>> traverse all the way from the PCI device to the kernel,
>> causing unnecessary overhead.
>>
>> This update disables IRQs for dummy ports and prevents
>> the described issue.
>>
>> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
>> Cc: Tejun Heo <tj@kernel.org>
>> Cc: David Milburn <dmilburn@redhat.com>
>> Cc: linux-ide@vger.kernel.org
>
> David, can you please test the patch?
>


Hi,

I have re-tested successfully, this patch prevents the crash
when using kdump, and I boot tested a system that boots off
ahci and has dummy ports present, no problems seen.

Thanks,
David


