Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926AbaBMPkL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 10:40:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40103 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751606AbaBMPkK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 10:40:10 -0500
Message-ID: <52FCE74A.4010000@zytor.com>
Date: Thu, 13 Feb 2014 07:39:54 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>, kvm <kvm@vger.kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [qemu64,+smep,+smap] Kernel panic - not syncing: No working init
 found.
References: <20140213124550.GA30497@localhost> <52FCDCE5.4010301@zytor.com>
In-Reply-To: <52FCDCE5.4010301@zytor.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2014 06:55 AM, H. Peter Anvin wrote:
> On 02/13/2014 04:45 AM, Fengguang Wu wrote:
>> Greetings,
>>
>> I find that when running
>>
>>         qemu-system-x86_64 -cpu qemu64,+smep,+smap
>>
>> Some kernels will 100% produce this error, where the error code
>> -13,-14 are -EACCES and -EFAULT:
>>
>> Any ideas?
>>
> 
> I notice this is a non-SMAP kernel:
> 
> # CONFIG_X86_SMAP is not set
> 
> If the kernel turns on SMAP in CR4 even though SMAP isn't enabled in the
> kernel, that is a kernel bug.  If Qemu enforces SMAP even if it is
> turned off in CR4, that would be a Qemu bug.  I have reproduced the
> failure locally and an am considering both possibilities now.
> 

So we do turn on the bit in CR4 even with SMAP compiled out.  This is a
bug.  However, I still get the same failure even with that bug fixed
(and qemu "info registers" verify that it is, indeed, not set) so I'm
wondering if there is a bug in Qemu as well.  However, staring at the
code in Qemu I don't see where that bug would be...

	-hpa


