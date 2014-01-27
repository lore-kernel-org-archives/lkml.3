Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402AbaA0C4b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 21:56:31 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44487 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159AbaA0C43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 21:56:29 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.9
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-2
Message-ID: <52E5CA8D.7000602@jp.fujitsu.com>
Date: Mon, 27 Jan 2014 11:55:09 +0900
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] x86, apic: clean up handling of boot_cpu_physical_apicid
 in boot process
References: <52D7A8F0.70807@jp.fujitsu.com> <alpine.DEB.2.02.1401252000050.10325@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1401252000050.10325@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/01/26 13:02), David Rientjes wrote:
> On Thu, 16 Jan 2014, HATAYAMA Daisuke wrote:
> 
>> Hello,
>>
>> This patch deals with the issue of handling boot_cpu_physical_apicid
>> in boot process I avoided in disable_cpu_apicid patch because I
>> cannot guess how long it needs to take for the review of this fix.
>>
>> This patch is made on top of today's x86/apic branch of tip tree.
>> Its commit hash is 5b4d1dbc24bb6fd7179ada0f47be34e27e64decb
>>
> 
> This breaks with SGI 320/540:
> 
> arch/x86/platform/visws/visws_quirks.c: In function ‘MP_processor_info’:
> arch/x86/platform/visws/visws_quirks.c:169:3: error: ‘bios_cpu_physical_apicid’ undeclared (first use in this function)
> arch/x86/platform/visws/visws_quirks.c:169:3: note: each undeclared identifier is reported only once for each function it appears in
> 

Thanks. I'll retry with CONFIG_X86_VISWS...

obj-$(CONFIG_X86_VISWS) += visws_quirks.o

> It makes it pretty apparent that you want a different name for the new
> variable, bios_bsp_physical_apicid is just too close to
> boot_cpu_physical_apicid that even the author of the patch missed a
> conversion.
> 

``bsp'' and ``boot cpu'' are different, but certainly they are close
for most of people who don't need to focus the difference.

One idea is not to add bios_bsp_physical_apicid, just removing
assignment to boot_cpu_physical_apicid from MP_processor_info().
I guess currently no one uses apicid provided by MP table
since boot_cpu_physical_apicid is finally initialized in
init_apic_mappings().

> (It's also really sad that we can't make it __initdata since it's only
> valid at boot because of the hotplug stuff.)
> 


-- 
Thanks.
HATAYAMA, Daisuke

