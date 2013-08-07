Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756951Ab3HGDYH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 23:24:07 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35108 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756870Ab3HGDYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 23:24:04 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <5201BDB9.8050301@jp.fujitsu.com>
Date: Wed, 7 Aug 2013 12:23:37 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Toshi Kani <toshi.kani@hp.com>
CC: <rafael.j.wysocki@intel.com>, <linux-acpi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ACPI, cpu hotplug: move try_offline_node() after acpi_unmap_lsapic()
References: <5200CBBF.1090904@jp.fujitsu.com> <1375808178.10300.181.camel@misato.fc.hp.com>
In-Reply-To: <1375808178.10300.181.camel@misato.fc.hp.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/08/07 1:56), Toshi Kani wrote:
> On Tue, 2013-08-06 at 19:11 +0900, Yasuaki Ishimatsu wrote:
>> try_offline_node() checks that all cpus related with removed node have been
>> removed by using cpu_present_bits. If all cpus related with removed node have
>> been removed, try_offline_node() clears the node information.
>>
>> But try_offline_node() called from acpi_processor_remove() never clears
>> the node information. For disabling cpu_present_bits, acpi_unmap_lsapic()
>> need be called. But acpi_unmap_lsapic() is called after try_offline_node()
>> runs. So when try_offline_node() runs, the cpu's cpu_present_bits is always
>> set.
>>
>> This patch moves try_offline_node() after acpi_unmap_lsapic().
>>
>> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
>
> The change looks good to me.
>
> Acked-by: Toshi Kani <toshi.kani@hp.com>

Thanks, Toshi!

> BTW, do you know why try_offline_node() has to use stop_machine()?

I don't know the reason.

Thanks,
Yasuaki Ishimatsu



>
> Thanks,
> -Toshi
>


