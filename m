Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394Ab3KVAnR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 19:43:17 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55786 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753784Ab3KVAnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 19:43:15 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.9
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-2
Message-ID: <528EA874.9010609@jp.fujitsu.com>
Date: Fri, 22 Nov 2013 09:42:28 +0900
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: hpa@linux.intel.com, ebiederm@xmission.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, bp@alien8.de, akpm@linux-foundation.org,
        fengguang.wu@intel.com, jingbai.ma@hp.com
Subject: Re: [PATCH v6 2/3] x86, apic: Add disable_cpu_apicid kernel parameter
References: <20131121015951.2748.47826.stgit@localhost6.localdomain6> <20131121020044.2748.70221.stgit@localhost6.localdomain6> <20131121213300.GR16208@redhat.com>
In-Reply-To: <20131121213300.GR16208@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/11/22 6:33), Vivek Goyal wrote:
> On Thu, Nov 21, 2013 at 11:00:44AM +0900, HATAYAMA Daisuke wrote:
>
> [..]
>> @@ -2122,6 +2129,19 @@ void generic_processor_info(int apicid, int version)
>>   	bool boot_cpu_detected = physid_isset(boot_cpu_physical_apicid,
>>   				phys_cpu_present_map);
>>
>> +	if (disabled_cpu_apicid != BAD_APICID &&
>> +	    disabled_cpu_apicid != boot_cpu_physical_apicid &&
>
> Hi Hatayama,
>
> So we are comparing disabled_cpu_apicid with boot_cpu_physical_apicid
> to make sure that one can not disable the cpu we are booting on. Can
> we just read the apic id of booting cpu in local variable and compare
> against that?
>
> Something like as follows.
>
> 	if (disabled_cpu_apicid != BAD_APICID &&
> 	    disabled_cpu_apicid == apicid &&
> 	    disabled_cpu_apicid != read_apic_id()) {
> 		/* Disable cpu */	
> 	}
>
> If above works, you will not need first patch in the series?
>

Yes, I came up with the idea, too. But doing this means we leave two different
ways boot_cpu_physical_apicid is used at boot, which seemed incomplete as a
patch. Also, then we could even lost the reason why boot_cpu_physical_apicid
exists.

But, it's true that the 1st patch causes one more reviewing point. I'll
remove it and fix the 2nd patch just as you suggested here.

-- 
Thanks.
HATAYAMA, Daisuke

