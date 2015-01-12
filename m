Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176AbbALLNZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 06:13:25 -0500
Received: from us01smtprelay-2.synopsys.com ([198.182.60.111]:33157 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234AbbALLNW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 06:13:22 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Jiri Olsa <jolsa@redhat.com>
CC: "acme@redhat.com" <acme@redhat.com>,
        "namhyung@kernel.org" <namhyung@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "jolsa@kernel.org" <jolsa@kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "Alexey.Brodkin@synopsys.com" <Alexey.Brodkin@synopsys.com>
Subject: Re: [PATCH v2 5/5] perf tools: [uclibc] provide stub for
 pthread_attr_setaffinity_np
Thread-Topic: [PATCH v2 5/5] perf tools: [uclibc] provide stub for
 pthread_attr_setaffinity_np
Thread-Index: AQHQLlen5xqztihQaEK9LN7Zkyjhbg==
Date: Mon, 12 Jan 2015 11:13:17 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA2307565BCBA7D@IN01WEMBXA.internal.synopsys.com>
References: <1420888254-17504-1-git-send-email-vgupta@synopsys.com>
 <1420888254-17504-6-git-send-email-vgupta@synopsys.com>
 <20150112110443.GB26229@krava.redhat.com>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.12.196.223]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Monday 12 January 2015 04:35 PM, Jiri Olsa wrote:
> On Sat, Jan 10, 2015 at 04:40:54PM +0530, Vineet Gupta wrote:
>
> SNIP
>
>> [SNIP]
>>  	test-timerfd.bin		\
>>  	test-libdw-dwarf-unwind.bin	\
>> @@ -47,6 +48,9 @@ test-all.bin:
>>  test-hello.bin:
>>  	$(BUILD)
>>  
>> +test-pthread-attr-setaffinity-np.bin:
>> +	$(BUILD) -Werror
> this does not works for me unless I add -lpthread (check patch below)
> is it possible you pushed that through LDFLAGS?
>
> otherwise I'm getting following error:
> 	---
> 	In file included from bench/futex-hash.c:17:0:
> 	bench/futex.h:73:19: error: conflicting types for ‘pthread_attr_setaffinity_np’
> 	 static inline int pthread_attr_setaffinity_np(pthread_attr_t *attr,
> [snip]
> 			   ^
> 	In file included from bench/futex.h:72:0,
> 			 from bench/futex-requeue.c:17:
> 	/usr/include/pthread.h:407:12: note: previous declaration of ‘pthread_attr_setaffinity_np’ was here
> 	 extern int pthread_attr_setaffinity_np (pthread_attr_t *__attr,
> 		    ^
> 	make[1]: *** [bench/futex-requeue.o] Error 1
> 	make: *** [all] Error 2
> 	---
>
> my system is x86_64 on F20
>
> thanks,
> jirka
>
>
> diff --git a/tools/perf/config/feature-checks/Makefile b/tools/perf/config/feature-checks/Makefile
> index e9b99bb29348..42ac05aaf8ac 100644
> --- a/tools/perf/config/feature-checks/Makefile
> +++ b/tools/perf/config/feature-checks/Makefile
> @@ -49,7 +49,7 @@ test-hello.bin:
>  	$(BUILD)
>  
>  test-pthread-attr-setaffinity-np.bin:
> -	$(BUILD) -Werror
> +	$(BUILD) -Werror -lpthread
>  
>  test-stackprotector-all.bin:
>  	$(BUILD) -Werror -fstack-protector-all

Right - that fix is indeed needed to make it pass. Thing is, with my uClibc config
it always fails - so I couldn't make it fail because of this reason :-)

I'll add that hunk in v3.

Thx,
-Vineet
