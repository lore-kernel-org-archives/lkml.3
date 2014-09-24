Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188AbaIXKPq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 06:15:46 -0400
Received: from outbound-smtp04.blacknight.com ([81.17.249.35]:38096 "EHLO
	outbound-smtp04.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751680AbaIXKPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 06:15:44 -0400
Message-ID: <542299CF.1040502@nexus-software.ie>
Date: Wed, 24 Sep 2014 11:15:43 +0100
From: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, pure.logic@nexus-software.ie
Subject: Re: [PATCH] x86: Quark: Switch of CR4.PGE TLB flush use CR3 instead
References: <1411514784-14885-1-git-send-email-pure.logic@nexus-software.ie> <20140924071221.GB990@gmail.com>
In-Reply-To: <20140924071221.GB990@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/09/14 08:12, Ingo Molnar wrote:
>
> * Bryan O'Donoghue <pure.logic@nexus-software.ie> wrote:
>
>> Quark x1000 advertises PGE via the standard CPUID method
>> PGE bits exist in Quark X1000's PTEs. In order to flush
>> an individual PTE it is necessary to reload CR3 irrespective
>> of the PTE.PGE bit.
>>
>> See Quark Core_DevMan_001.pdf section 6.4.11
>>
> How was this bug found?
>
> I'm wondering, how was Linux ever booted on an Intel Quark CPU
> successfully if PGE does not work as advertised? Getting TLB
> flushes wrong is a surefire way to crash the kernel. Was any
> related instability observed?
>
> Thanks,
>
> 	Ingo

Hi Ingo.

Resending this email...

The received wisdom from the silicon people prior to launch meant it was 
never a problem for the Quark/Galileo BSP.

In the reference BSP code for Galileo, which I was involved in making, 
this fix is already in place. So pretty much everybody running Linux on 
Quark is doing it with the modified 3.8.7 kernel shipping with the 
Galileo BSP.

So far there's no related instability - since we've never really run any 
torture tests with the wrong TLB flush method in-place.

To get properly Quark X1000 support out-of-the-box in Vanilla Linux 
though the TLB flush will need to change.


Best,
Bryan


