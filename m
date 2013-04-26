Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271Ab3DZWPt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 18:15:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43924 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751512Ab3DZWPs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 18:15:48 -0400
Message-ID: <517AFC6E.4020800@zytor.com>
Date: Fri, 26 Apr 2013 15:15:10 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        kernel-hardening@lists.openwall.com,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@intel.com>,
        Matthew Garrett <mjg@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Eric Northup <digitaleric@google.com>,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>
Subject: Re: [PATCH 6/6] x86: kaslr: report kernel offset on panic
References: <1367003005-5560-7-git-send-email-keescook@chromium.org> <20130426221301.GA26059@pd.tnic>
In-Reply-To: <20130426221301.GA26059@pd.tnic>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/2013 03:13 PM, Borislav Petkov wrote:
> On Fri, Apr 26, 2013 at 12:03:25PM -0700, Kees Cook wrote:
>> When the system panics, include the kernel offset in the report to assist
>> in debugging.
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> ---
>>  arch/x86/kernel/setup.c |   24 ++++++++++++++++++++++++
>>  1 file changed, 24 insertions(+)
>>
>> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
>> index fae9134..95a33b1 100644
>> --- a/arch/x86/kernel/setup.c
>> +++ b/arch/x86/kernel/setup.c
>> @@ -830,6 +830,18 @@ static void __init trim_low_memory_range(void)
>>  }
>>  	
>>  /*
>> + * Dump out kernel offset information on panic.
>> + */
>> +static int
>> +dump_kernel_offset(struct notifier_block *self, unsigned long v, void *p)
>> +{
>> +	pr_emerg("Kernel Offset: 0x%lx\n",
>> +		 (unsigned long)&_text - __START_KERNEL);
> 
> So what's wrong with subtracting the offset from the function addresses
> on the stack so that traces can show the addresses as they are in
> vmlinux, completely agnostic of any randomization?
> 

That really makes it harder to figure out what the heck the register
content may mean...

	-hpa

