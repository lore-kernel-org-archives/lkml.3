Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751418Ab3IJTiw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 15:38:52 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:51838 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab3IJTiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 15:38:50 -0400
MIME-Version: 1.0
In-Reply-To: <522F6F96.8030803@gmail.com>
References: <1378720815-23964-1-git-send-email-jean.pihet@linaro.org>
	<1378720815-23964-4-git-send-email-jean.pihet@linaro.org>
	<522F6F96.8030803@gmail.com>
Date: Tue, 10 Sep 2013 21:38:49 +0200
Message-ID: <CAFrcx1=mOw5=kASC9O=xewWV8QeOy-ga0F9ZGbtcauDJQ2iGFQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] perf: parse the .debug_frame section in case
 .eh_frame is not present
From: Jean Pihet <jean.pihet@linaro.org>
To: David Ahern <dsahern@gmail.com>
Cc: Will Deacon <will.deacon@arm.com>, Jiri Olsa <jolsa@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Patch Tracking <patches@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 September 2013 21:14, David Ahern <dsahern@gmail.com> wrote:
> On 9/9/13 3:00 AM, Jean Pihet wrote:
>>
>> diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
>> index 7014373..54532b8 100644
>> --- a/tools/perf/config/Makefile
>> +++ b/tools/perf/config/Makefile
>> @@ -222,7 +222,7 @@ endif
>>
>>   FLAGS_UNWIND=$(LIBUNWIND_CFLAGS) $(CFLAGS) $(LIBUNWIND_LDFLAGS)
>> $(LDFLAGS) $(EXTLIBS) $(LIBUNWIND_LIBS)
>>   ifneq ($(call try-cc,$(SOURCE_LIBUNWIND),$(FLAGS_UNWIND),libunwind),y)
>> -  msg := $(warning No libunwind found, disabling post unwind support.
>> Please install libunwind-dev[el] >= 0.99);
>> +  msg := $(warning No libunwind found, disabling post unwind support.
>> Please install libunwind-dev[el] >= 1.1);
>>     NO_LIBUNWIND := 1
>>   endif # Libunwind support
>>   endif # NO_LIBUNWIND
>
>
> Is the 1.1 version required for x86 too?
Yes if the dwarf unwinding feature is used. I know it is not in use on
x86 as of now but could be in the future since the dwarf info brings
more details in the trace, cf. http://lwn.net/Articles/499116/.

>
> David

Jean
