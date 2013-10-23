Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828Ab3JWAIA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 20:08:00 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41888 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036Ab3JWAH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 20:07:59 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.9
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-2
Message-ID: <526712B2.7070108@jp.fujitsu.com>
Date: Wed, 23 Oct 2013 09:05:06 +0900
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: jerry.hoemann@hp.com
CC: hpa@linux.intel.com, ebiederm@xmission.com, vgoyal@redhat.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org, bp@alien8.de,
        akpm@linux-foundation.org, fengguang.wu@intel.com, jingbai.ma@hp.com
Subject: Re: [PATCH v4 0/3] x86, apic, kexec: Add disable_cpu_apic kernel
 parameter
References: <20131022150015.24240.39686.stgit@localhost6.localdomain6> <20131022220803.GA32387@anatevka.fc.hp.com>
In-Reply-To: <20131022220803.GA32387@anatevka.fc.hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/10/23 7:08), jerry.hoemann@hp.com wrote:
> On Wed, Oct 23, 2013 at 12:01:18AM +0900, HATAYAMA Daisuke wrote:
>> This patch set is to allow kdump 2nd kernel to wake up multiple CPUs
>> even if 1st kernel crashs on some AP, a continueing work from:
>>
>>    [PATCH v3 0/2] x86, apic, kdump: Disable BSP if boot cpu is AP
>>    https://lkml.org/lkml/2013/10/16/300.
>>
>> In this version, basic design has changed. Now users need to figure
>> out initial APIC ID of BSP in the 1st kernel and configures kernel
>> parameter for the 2nd kernel manually using disable_cpu_apic kernel
>> parameter to be newly introduced in this patch set. This design is
>> more flexible than the previous version in that we no longer have to
>> rely on ACPI/MP table to get initial APIC ID of BSP.
>>
>> Sorry, this patch set have not include in-source documentation
>> requested by Borislav Petkov yet, but I'll post it later separately,
>> which would be better to focus on documentation reviewing.
>>
>> ChangeLog
>>
>> v3 => v4)
>>
>> - Rebased on top of v3.12-rc6
>>
>> - Basic design has been changed. Now users need to figure out initial
>>    APIC ID of BSP in the 1st kernel and configures kernel parameter for
>>    the 2nd kernel manually using disable_cpu_apic kernel parameter to
>>    be newly introduced in this patch set. This design is more flexible
>>    than the previous version in that we no longer have to rely on
>>    ACPI/MP table to get initial APIC ID of BSP.
>
>
> Do you literally mean a human at each boot will have to configure
> the kdump configuration files for passing disable_cpu_apic?
> Or do you envision the setting of disable_cpu_apic being put into
> the kdump initialization scripts?
>
> thanks
>
> Jerry

Nearer to the former case, but this is not what a human should do. It's
a cumbersome task. I think, on fedora/RHEL system for example, kdump
service should check at each boot automatically.

-- 
Thanks.
HATAYAMA, Daisuke

