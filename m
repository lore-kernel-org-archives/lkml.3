Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821AbaKEDEW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 22:04:22 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:35750 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbaKEDEV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 22:04:21 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 2/8] perf tools: Add gzip decompression support for kernel module
References: <1415063674-17206-1-git-send-email-namhyung@kernel.org>
	<1415063674-17206-3-git-send-email-namhyung@kernel.org>
	<20141104141508.GG18464@kernel.org>
Date: Wed, 05 Nov 2014 12:04:19 +0900
In-Reply-To: <20141104141508.GG18464@kernel.org> (Arnaldo Carvalho de Melo's
	message of "Tue, 4 Nov 2014 11:15:08 -0300")
Message-ID: <87d292xs98.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Nov 2014 11:15:08 -0300, Arnaldo Carvalho de Melo wrote:
> Em Tue, Nov 04, 2014 at 10:14:28AM +0900, Namhyung Kim escreveu:
>> Now my Archlinux box shows module symbols correctly.
>
> Now my RHEL6 box doesn't build:
>
>> +++ b/tools/perf/util/dso.c
>> @@ -141,17 +141,13 @@ int dso__read_binary_type_filename(const struct dso *dso,
>>  	return ret;
>
>>  static const struct {
>>  	const char *fmt;
>>  	int (*decompress)(const char *input, int output);
>>  } compressions[] = {
>> -	{ "gz", decompress_dummy },
>> +#ifdef HAVE_ZLIB_SUPPORT
>> +	{ "gz", gzip_decompress_to_file },
>> +#endif
>>  	{ NULL, },
>>  };
>
>   CC       /tmp/build/perf/util/dso.o
> cc1: warnings being treated as errors
> util/dso.c:151: error: missing initializer
> util/dso.c:151: error: (near initialization for
> ‘compressions[1].decompress’)
> make[1]: *** [/tmp/build/perf/util/dso.o] Error 1
> make: Leaving directory `/home/gita/perf-3.18.0-rc1/tools/perf'
> make: *** [install] Error 2
> [acme@zoo linux]$
>
> Will try and fix it, nevermind :-)

Also fixed and pushed to perf/vmlinux-v7 branch.

Thanks,
Namhyung
