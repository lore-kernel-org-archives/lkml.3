Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495Ab3IWJPM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 05:15:12 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:58325 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994Ab3IWJPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 05:15:11 -0400
X-AuditID: 9c930179-b7c8bae000006c65-1a-5240069ddc02
From: Namhyung Kim <namhyung@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH] perf tools: Use per-file CFLAGS in Makefile
References: <1379297476-20793-1-git-send-email-namhyung@kernel.org>
	<20130920230132.GK9574@pd.tnic>
Date: Mon, 23 Sep 2013 18:15:09 +0900
In-Reply-To: <20130920230132.GK9574@pd.tnic> (Borislav Petkov's message of
	"Sat, 21 Sep 2013 01:01:32 +0200")
Message-ID: <878uynrjaa.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Borislav,

On Sat, 21 Sep 2013 01:01:32 +0200, Borislav Petkov wrote:
> On Mon, Sep 16, 2013 at 11:11:16AM +0900, Namhyung Kim wrote:
>> -$(OUTPUT)util/scripting-engines/trace-event-perl.o: util/scripting-engines/trace-event-perl.c $(OUTPUT)PERF-CFLAGS
>> -	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) $(PERL_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-shadow -Wno-undef -Wno-switch-default $<
>> -
>> -$(OUTPUT)scripts/perl/Perf-Trace-Util/Context.o: scripts/perl/Perf-Trace-Util/Context.c $(OUTPUT)PERF-CFLAGS
>> -	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) $(PERL_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-nested-externs -Wno-undef -Wno-switch-default $<
>> -
>> -$(OUTPUT)util/scripting-engines/trace-event-python.o: util/scripting-engines/trace-event-python.c $(OUTPUT)PERF-CFLAGS
>> -	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) $(PYTHON_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-shadow $<
>> -
>> -$(OUTPUT)scripts/python/Perf-Trace-Util/Context.o: scripts/python/Perf-Trace-Util/Context.c $(OUTPUT)PERF-CFLAGS
>> -	$(QUIET_CC)$(CC) -o $@ -c $(CFLAGS) $(PYTHON_EMBED_CCOPTS) -Wno-redundant-decls -Wno-strict-prototypes -Wno-unused-parameter -Wno-nested-externs $<
>
> What happened with the trailing -W options in each target above?
> Looks like they've been dropped because I can't find them in the new
> definitions...

I replaced them to a single -w option since all we want to do is
suppress any warning, right?

Thanks,
Namhyung
