Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924Ab3HSCaK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 22:30:10 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44727 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179Ab3HSCaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 22:30:08 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.9
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-2
Message-ID: <5211831B.6090704@jp.fujitsu.com>
Date: Mon, 19 Aug 2013 11:29:47 +0900
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Jingbai Ma <jingbai.ma@hp.com>, Fenghua Yu <fenghua.yu@intel.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Mitchell, Lisa (MCLinux in Fort Collins)" <lisa.mitchell@hp.com>,
        "H. Peter Anvin" <hpa@zytor.com>, bhelgaas@google.com,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [Help Test] kdump, x86, acpi: Reproduce CPU0 SMI corruption issue
 after unsetting BSP flag
References: <5200BFB3.2050202@jp.fujitsu.com> <520A10A3.5080303@hp.com> <520B4A22.2030800@hp.com> <87ob90839p.fsf@xmission.com>
In-Reply-To: <87ob90839p.fsf@xmission.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/08/15 4:45), Eric W. Biederman wrote:
> Jingbai Ma <jingbai.ma@hp.com> writes:
>
>> I found a side effect of unsetting BSP flag.
>> It affected system rebooting, once the BSP flags been removed, and issue
>> reboot command, system will hang after message:
>> Restarting system.
>> And have to do a hardware reset to recover it.
>>
>> I have reproduced this problem on the following systems:
>> HP EliteBook 6930p
>> HP Compaq DC7700
>> HP ProLiant DL980 (4 sockets, 40 cores)
>>
>> I have an idea: To avoid such kind of issue, we can unset BSP flag in
>> the first kernel during crash processing, and restore it in the second
>> kernel in the APs initializing.
>
> The premise was clearing BSP would not be an issue.  If we could
> reliably count on unsetting the BSP during crash processing we could
> just switch to the BSP and be done totally avoid this problem.
>
> Given that there are reald world issues with clearing the BSP flag,
> I believe the alternate suggestion was to simply never attempt to start
> the bootstrap processor during processor bring up.
>
> If as normal we are running on the bootstrap processor everything will
> work the same, but if we are in the kdump scenario we will be short one
> core.  Being short one core seems like a reasonable tradeoff between
> reliability and performance.
>
> Eric

Sorry Eric, I'm not clear to what you mean by ``short one core''...
Which are you suggesting? Disabling BSP if crash happens on AP is reasonable?
Or restricting cpus to a single one only just as the current kdump
configuration is reasonable?

-- 
Thanks.
HATAYAMA, Daisuke

