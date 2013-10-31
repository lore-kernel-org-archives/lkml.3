Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199Ab3JaEps (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 00:45:48 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44768 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743Ab3JaEpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 00:45:46 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.9
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-2
Message-ID: <5271DFEC.7070802@jp.fujitsu.com>
Date: Thu, 31 Oct 2013 13:43:24 +0900
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: jerry.hoemann@hp.com
CC: hpa@linux.intel.com, ebiederm@xmission.com, vgoyal@redhat.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org, bp@alien8.de,
        akpm@linux-foundation.org, fengguang.wu@intel.com, jingbai.ma@hp.com
Subject: Re: [PATCH v4 0/3] x86, apic, kexec: Add disable_cpu_apic kernel
 parameter
References: <20131022150015.24240.39686.stgit@localhost6.localdomain6> <20131022220803.GA32387@anatevka.fc.hp.com> <526712B2.7070108@jp.fujitsu.com> <20131031005812.GA15459@anatevka.fc.hp.com>
In-Reply-To: <20131031005812.GA15459@anatevka.fc.hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/10/31 9:58), jerry.hoemann@hp.com wrote:
> On Wed, Oct 23, 2013 at 09:05:06AM +0900, HATAYAMA Daisuke wrote:
>>>>
>>>> - Rebased on top of v3.12-rc6
>>>>
>>>> - Basic design has been changed. Now users need to figure out initial
>>>>    APIC ID of BSP in the 1st kernel and configures kernel parameter for
>>>>    the 2nd kernel manually using disable_cpu_apic kernel parameter to
>>>>    be newly introduced in this patch set. This design is more flexible
>>>>    than the previous version in that we no longer have to rely on
>>>>    ACPI/MP table to get initial APIC ID of BSP.
>>>
>>>
>>> Do you literally mean a human at each boot will have to configure
>>> the kdump configuration files for passing disable_cpu_apic?
>>> Or do you envision the setting of disable_cpu_apic being put into
>>> the kdump initialization scripts?
>>>
>>> thanks
>>>
>>> Jerry
>>
>> Nearer to the former case, but this is not what a human should do. It's
>> a cumbersome task. I think, on fedora/RHEL system for example, kdump
>> service should check at each boot automatically.
>>
>> HATAYAMA, Daisuke
>
>
> Daisuke,
>
> Are you planning on making changes to the kexec tools to automate
> the setting of disable_cpu_apic to the capture kernel? Or do you
> know someone who is planning this?
>
> I back ported the kernel side changes to a 4.2.32 based kernel.
> I tested the patch on a prototype system which exhibits a stable
> initial_apic_id for CPU 0.  While not something that would be suitable
> for customers, it does allow me to test the kernel portion of the patch.
>
> I will report the results of the testing later this week.
>

I'll do that after this patch is merged in kernel. But it is still under
reviewing.

-- 
Thanks.
HATAYAMA, Daisuke

