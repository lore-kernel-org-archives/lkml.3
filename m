Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265Ab3ASULw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 15:11:52 -0500
Received: from zfrontend2.aha.ru ([195.2.83.148]:32996 "EHLO aha.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752186Ab3ASULv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 15:11:51 -0500
From: "werner" <w.landgraf@ru.ru>
Subject: Re: Linux 3.8-rc1: compiling problem in perf-event-p6.o
To: Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org
X-Mailer: CommuniGate Pro WebUser Interface v.4.3.12
Date: Sat, 19 Jan 2013 16:11:45 -0400
Message-ID: <web-836074559@zbackend1.aha.ru>
In-Reply-To: <50F75349.2050609@infradead.org>
References: <web-834819484@zbackend1.aha.ru>
 <50F75349.2050609@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This didn't happen on 3.6  (3.7 I had no time to check 
out), although I continue to use the same c compiler and 
libraries.  So it should be caused by any change of the 
subroutine perf_event_p6  made in the last time.  Also, 
everything else of the kernel compiled, just not that 
subroutine.   Anyway the kernel should compile correctly 
with all recent versions of the c compiler, so one should 
search and fix that.   The maintainer of that subroutine 
should be notified, and check the last changes since 3.6 .

Also, I always compile the WHOLE kernel, not only changed 
subroutines. Perhaps in any other subroutine was changed 
something of global variables in any other subroutine, 
what is now incompatible with subroutine perf_event_p6

W.Landgraf



=============================================
On Wed, 16 Jan 2013 17:26:33 -0800
  Randy Dunlap <rdunlap@infradead.org> wrote:
> On 01/15/13 06:50, werner wrote:
>> We are now on -rc3 and someone should correct this, 
>>finally
>> 
>> This is a regression, it was not before, on 3.6
>> 
>> This messes up any compilation of the whole kernel, it 
>>results in don't be produced vmlinuz
>> 
>> arch/x86/kernel/cpu/perf_event_p6.o   depends on so much 
>>things that I don't get it switched off, I suppose it's 
>>necesary for the most systems
>> 
>> 
>> W.Landgraf
>> 
>> 
>> 
>> 
>> 
>> 
>> =================
>> The problem continues with 3.8-rc
>> 
>> This is grave, no vmlinuz is produced.
>> 
>> 
>> wl
>> 
>>   CC arch/x86/kernel/cpu/perf_event.o
>>   CC arch/x86/kernel/cpu/perf_event_amd.o
>>   CC arch/x86/kernel/cpu/perf_event_p6.o
>> arch/x86/kernel/cpu/perf_event_p6.c:22: error: 
>>p6_hw_cache_event_ids causes a section type conflict
>> make[3]: [arch/x86/kernel/cpu/perf_event_p6.o] Error 1 
>>(ignored)
>>   CC arch/x86/kernel/cpu/perf_event_knc.o
>>   CC arch/x86/kernel/cpu/perf_event_p4.o
>>   CC arch/x86/kernel/cpu/perf_event_intel_lbr.o
>> 
>> ================================================
>> There ocurs a compiling error in perf-event-p6.o , any 
>>regression, unfortunately I lost the compiling list but I 
>>think it was any incompatibility / redefinition with 
>>something else, pls check and correct that, if not 
>>already done
>> W.Landgraf
> 
> Hi,
> 
> I don't see this problem on 3.8-rc1 or -rc3.
> Maybe a difference/problem in gcc??
> 
> 
> -- 
> ~Randy
> 
> 

"werner" <w.landgraf@ru.ru>
---
Professional hosting for everyone - http://www.host.ru
