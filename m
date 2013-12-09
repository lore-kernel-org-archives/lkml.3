Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761469Ab3LISCF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 13:02:05 -0500
Received: from mail-ve0-f175.google.com ([209.85.128.175]:65013 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761361Ab3LISCE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 13:02:04 -0500
MIME-Version: 1.0
In-Reply-To: <20131209171719.GA16631@krava.brq.redhat.com>
References: <1386411461-21510-1-git-send-email-jean.pihet@linaro.org>
	<1386411461-21510-3-git-send-email-jean.pihet@linaro.org>
	<20131209171719.GA16631@krava.brq.redhat.com>
Date: Mon, 9 Dec 2013 19:02:02 +0100
Message-ID: <CAFrcx1khWGXJOyyqOBedyZsmLWYdhmkGsn0FhNt6hwCYhf5qfA@mail.gmail.com>
Subject: Re: [PATCH 2/2] perf: unwinding: use the per-feature check flags
From: Jean Pihet <jean.pihet@linaro.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Ingo Molnar <mingo@kernel.org>, Arnaldo <acme@ghostprotocols.net>,
        Will Deacon <will.deacon@arm.com>, Patch Tracking <patches@linaro.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On 9 December 2013 18:17, Jiri Olsa <jolsa@redhat.com> wrote:
> On Sat, Dec 07, 2013 at 11:17:41AM +0100, Jean Pihet wrote:
>> Use the per-feature check flags for the unwinding feature in order
>> to correctly compile the libunwind and libunwind-debug-frame feature
>> checks.
>>
>> Tested on x86_64, ARMv7 and ARMv8 with and without LIBUNWIND_DIR set
>> in 'make -C tools/perf'
>>
>> Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
>> Cc: Jiri Olsa <jolsa@redhat.com>
>
> SNIP
>
>> +BUILD = $(CC) $(CFLAGS) -o $(OUTPUT)$@ $@.c $(LDFLAGS)
>>
>>  ###############################
>>
>>  test-all:
>> -     $(BUILD) -Werror -fstack-protector -fstack-protector-all -O2 -Werror -D_FORTIFY_SOURCE=2 -ldw -lelf -lnuma $(LIBUNWIND_LIBS) -lelf -laudit -I/usr/include/slang -lslang $(shell pkg-config --libs --cflags gtk+-2.0 2>/dev/null) $(FLAGS_PERL_EMBED) $(FLAGS_PYTHON_EMBED) -DPACKAGE='"perf"' -lbfd -ldl
>> +     $(BUILD) -Werror -fstack-protector -fstack-protector-all -O2 -Werror -D_FORTIFY_SOURCE=2 -ldw -lelf -lnuma -lelf -laudit -I/usr/include/slang -lslang $(shell pkg-config --libs --cflags gtk+-2.0 2>/dev/null) $(FLAGS_PERL_EMBED) $(FLAGS_PYTHON_EMBED) -DPACKAGE='"perf"' -lbfd -ldl
>
> hum, the test-all build command should have every possible flags we use, right?
> including LIBUNWIND_CFLAGS, LIBUNWIND_LDFLAGS
Oh yes you are right. I am overlooked the test-all feature (which
never builds on my modest embedded systems).
$(LIBUNWIND_LIBS) should be replaced by $(LIBUNWIND_CFLAGS)
$(LIBUNWIND_LDFLAGS), is that a reasonable approach?

>
> also, this patch no longer applies on acme's perf/core
I am using a recent mainline (3.12-rc2).

Let me correct the patch on acme's perf/core. Is that OK?

Thx for reviewing!
Jean

>
> jirka
