Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886Ab3KCO33 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 09:29:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34369 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753448Ab3KCO32 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 09:29:28 -0500
Message-ID: <52765DBC.1090208@redhat.com>
Date: Sun, 03 Nov 2013 09:29:16 -0500
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Josh Boyer <jwboyer@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Russ Anderson <rja@sgi.com>
Subject: Re: [PATCH] x86: Allow NR_CPUS=1024
References: <20131101141148.GH8652@hansolo.jdub.homelinux.org> <20131103101825.GA6605@gmail.com>
In-Reply-To: <20131103101825.GA6605@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/03/2013 05:18 AM, Ingo Molnar wrote:
> 
> * Josh Boyer <jwboyer@redhat.com> wrote:
> 
>> The current range for SMP configs is 2 - 512, or a full 4096 in the case 
>> of MAXSMP.  There are machines that have 1024 CPUs in them today and 
>> configuring a kernel for that means you are forced to set MAXSMP.  This 
>> adds additional unnecessary overhead.  While that overhead might be 
>> considered tiny for large machines, it isn't necessarily so if you are 
>> building a kernel that runs across a wide variety of machines.  We 
>> increase the range to 1024 to help with this.
>>
>> Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>
>> ---
>>  arch/x86/Kconfig | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>> index f67e839..d726b2d 100644
>> --- a/arch/x86/Kconfig
>> +++ b/arch/x86/Kconfig
>> @@ -825,7 +825,7 @@ config MAXSMP
>>  config NR_CPUS
>>  	int "Maximum number of CPUs" if SMP && !MAXSMP
>>  	range 2 8 if SMP && X86_32 && !X86_BIGSMP
>> -	range 2 512 if SMP && !MAXSMP
>> +	range 2 1024 if SMP && !MAXSMP
>>  	default "1" if !SMP
>>  	default "4096" if MAXSMP
>>  	default "32" if SMP && (X86_NUMAQ || X86_SUMMIT || X86_BIGSMP || X86_ES7000)
> 
> Any reason not to allow it to go up to 4096? The original concern was that 
> CPUS=4096 wasn't working very well and you had to select MAXSMP 
> deliberately and keep all the pieces.
> 
> But today it's all pretty robust so I see no reason why not to allow up to 
> 4096 CPUs.

Adding Russ from SGI as they are one of the consumers of a large CPU count.

I have no objections to raising this to 4096 FWIW.  I think it is a good idea,
and it is long overdue.

P.

> 
> Thanks,
> 
> 	Ingo
