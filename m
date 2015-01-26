Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777AbbAZQ7X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 11:59:23 -0500
Received: from outbound-smtp04.blacknight.com ([81.17.249.35]:36560 "EHLO
	outbound-smtp04.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753420AbbAZQ7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 11:59:21 -0500
Message-ID: <54C67267.3060406@nexus-software.ie>
Date: Mon, 26 Jan 2015 16:59:19 +0000
From: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Andy Shevchenko <andy.shevchenko@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, dvhart@infradead.org,
        boon.leong.ong@intel.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/1] x86: Add Isolated Memory Regions for Quark X1000
References: <1422281727-32610-1-git-send-email-pure.logic@nexus-software.ie>	<1422281727-32610-2-git-send-email-pure.logic@nexus-software.ie> <CAHp75VfAPjermaPYu2FwoRCycKsU48m=uXq=JqwQ6Bi31kV0hg@mail.gmail.com>
In-Reply-To: <CAHp75VfAPjermaPYu2FwoRCycKsU48m=uXq=JqwQ6Bi31kV0hg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/01/15 16:37, Andy Shevchenko wrote:

>> +config X86_INTEL_QUARK
>> +       bool "Intel Quark platform support"
>> +       depends on X86_32
>> +       depends on X86_EXTENDED_PLATFORM
>> +       depends on X86_PLATFORM_DEVICES
>> +       depends on PCI
>> +       depends on PCI_GOANY
>> +       depends on X86_IO_APIC
>> +       select IOSF_MBI
>> +       select INTEL_IMR
>> +       ---help---
>> +         Select to include support for Quark X1000 SoC.
>> +         Say Y here if you have a Quark based system such as the Arduino
>> +         compatible Intel Galileo.
>> +
>
> Does it mean we introduce a minimal support for the platform.

I'd call it minimal support yes since the IMR memory map needs to be 
sanitized before you run DMA.

All shipping versions of Galileo will need to have IMRs sanitized to 
reliably run Linux - or any other kernel for that matter - with DMA.

> So, I mean if user enables this in the kernel config and runs rebuilt
> kernel on the Quark it will work, will it?

Yes. Do you mean to add a stronger comment indicating IMR is mandatory ?
No issue with that.

> If so, IMR is mandatory stuff or not? What else is mandatory?

IMR is the only mandatory addition.

> So, I'm not sure the above is a part of the patch. Would it be a prepend?

Hmm - what do you mean by that ?

<snip>

No issue with the rest of the review - thanks for the time.

--
BOD
