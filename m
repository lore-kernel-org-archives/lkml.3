Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872Ab3KSPAu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 10:00:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38888 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750980Ab3KSPAt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 10:00:49 -0500
Message-ID: <528B7D17.7000509@suse.cz>
Date: Tue, 19 Nov 2013 16:00:39 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: David Daney <david.daney@cavium.com>,
        Francois Bedard <Francois.Bedard@synopsys.com>
Subject: Re: [PATCH] ARC: extable: Enable sorting at build time
References: <1384497942-26810-1-git-send-email-vgupta@synopsys.com> <C2D7FE5348E1B147BCA15975FBA23075156936@IN01WEMBXA.internal.synopsys.com>
In-Reply-To: <C2D7FE5348E1B147BCA15975FBA23075156936@IN01WEMBXA.internal.synopsys.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 19.11.2013 12:08, Vineet Gupta napsal(a):
> Ping ? people OK if I take this via arc tree (after baking it in linux-next for
> some time).

It makes more sense to add it to the arc tree than kbuild. If that's
what you are asking?

Thanks,
Michal

> 
> -Vineet
> 
> On 11/15/2013 12:15 PM, Vineet Gupta wrote:
>> Avoids wasting cycles at boot specially on slower simulators
>>
>> Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
>> Cc: David Daney <david.daney@cavium.com>
>> Cc: Michal Marek <mmarek@suse.cz>
>> Cc: Francois Bedard <fbedard@synopsys.com>
>> Cc: linux-kernel@vger.kernel.org
>> ---
>>  arch/arc/Kconfig      | 1 +
>>  scripts/sortextable.c | 5 +++++
>>  2 files changed, 6 insertions(+)
>>
>> diff --git a/arch/arc/Kconfig b/arch/arc/Kconfig
>> index 91dbb2757afd..080580216301 100644
>> --- a/arch/arc/Kconfig
>> +++ b/arch/arc/Kconfig
>> @@ -8,6 +8,7 @@
>>  
>>  config ARC
>>  	def_bool y
>> +	select BUILDTIME_EXTABLE_SORT
>>  	select CLONE_BACKWARDS
>>  	# ARC Busybox based initramfs absolutely relies on DEVTMPFS for /dev
>>  	select DEVTMPFS if !INITRAMFS_SOURCE=""
>> diff --git a/scripts/sortextable.c b/scripts/sortextable.c
>> index 7c2310c5b996..e3fb1c36ed0f 100644
>> --- a/scripts/sortextable.c
>> +++ b/scripts/sortextable.c
>> @@ -31,6 +31,10 @@
>>  #include <tools/be_byteshift.h>
>>  #include <tools/le_byteshift.h>
>>  
>> +#ifndef EM_ARCOMPACT
>> +#define EM_ARCOMPACT	93
>> +#endif
>> +
>>  #ifndef EM_AARCH64
>>  #define EM_AARCH64	183
>>  #endif
>> @@ -244,6 +248,7 @@ do_file(char const *const fname)
>>  	case EM_S390:
>>  		custom_sort = sort_relative_table;
>>  		break;
>> +	case EM_ARCOMPACT:
>>  	case EM_ARM:
>>  	case EM_AARCH64:
>>  	case EM_MIPS:
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

