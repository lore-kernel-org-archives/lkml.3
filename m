Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960AbaAPGX0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 01:23:26 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:54801 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbaAPGXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 01:23:24 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.9
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-2
Message-ID: <52D77A49.5060905@jp.fujitsu.com>
Date: Thu, 16 Jan 2014 15:20:57 +0900
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: mingo@kernel.org, hpa@linux.intel.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/apic] x86, apic: Make disabled_cpu_apicid static read_mostly,
 fix typos
References: <20140115182511.GA22737@gmail.com> <tip-5b4d1dbc24bb6fd7179ada0f47be34e27e64decb@git.kernel.org> <52D763BC.8050909@jp.fujitsu.com> <52D773F7.7000108@zytor.com>
In-Reply-To: <52D773F7.7000108@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/01/16 14:53), H. Peter Anvin wrote:
> On 01/15/2014 08:44 PM, HATAYAMA Daisuke wrote:
>>
>> This is not typo in my intention.
>>
>> generic_processor_info() has two more cases where it ignores cpus.
>> In either cases, printed messages are tagged with "ACPI" because this
>> function is called when parsing ACPI MADT table in acpi_boot_init();
>> this function is also being used to parse other kind of tables but
>> the "ACPI" tag would mean that the function was first for ACPI only.
>>
>
> But it has nothing to do with ACPI -- it is an APIC ID from the command
> line -- so that would be actively misleading.
>
> 	-hpa
>

I never disagree to the fix itself. I wanted to explain why I wrote so.

I thought it was better to unify tags in the same function because they
should bleong to the same component, here I mean ACPI, but it's better
to avoid the confusion, which is bigger impact.

-- 
Thanks.
HATAYAMA, Daisuke

