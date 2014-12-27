Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751321AbaL0FhW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2014 00:37:22 -0500
Received: from mail-oi0-f44.google.com ([209.85.218.44]:47193 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbaL0FhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2014 00:37:19 -0500
MIME-Version: 1.0
In-Reply-To: <549D9446.6050506@gmail.com>
References: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
 <1419405333-27952-12-git-send-email-namhyung@kernel.org> <549D9446.6050506@gmail.com>
From: Namhyung Kim <namhyung@kernel.org>
Date: Sat, 27 Dec 2014 14:36:59 +0900
X-Google-Sender-Auth: nhdV_p54NkeD0fiB-1I3pQvbSiE
Message-ID: <CAM9d7chd48vLK4ZjL=3ESGFKPRmvcSw=_e-AefNXzr2KX8_kRw@mail.gmail.com>
Subject: Re: [PATCH 11/37] perf tools: Introduce thread__comm_time() helpers
To: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 27, 2014 at 2:00 AM, David Ahern <dsahern@gmail.com> wrote:
> On 12/24/14 12:15 AM, Namhyung Kim wrote:
>>
>> @@ -139,6 +161,16 @@ const char *thread__comm_str(const struct thread
>> *thread)
>>         return comm__str(comm);
>>   }
>>
>> +const char *thread__comm_time_str(const struct thread *thread, u64
>> timestamp)
>> +{
>> +       const struct comm *comm = thread__comm_time(thread, timestamp);
>> +
>> +       if (!comm)
>> +               return NULL;
>> +
>> +       return comm__str(comm);
>> +}
>> +
>
>
> thread__comm_str_time()? time_str suggests a time-based string as opposed to
> a comm_str based on time.

Will change - my naming sense is always awful.  I'd be happy to hear
any naming suggestion. ;-)

Thanks,
Namhyung
