Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955AbaKDOPR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 09:15:17 -0500
Received: from mail.kernel.org ([198.145.19.201]:53518 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751841AbaKDOPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 09:15:13 -0500
Date: Tue, 4 Nov 2014 11:15:08 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 2/8] perf tools: Add gzip decompression support for
 kernel module
Message-ID: <20141104141508.GG18464@kernel.org>
References: <1415063674-17206-1-git-send-email-namhyung@kernel.org>
 <1415063674-17206-3-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1415063674-17206-3-git-send-email-namhyung@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Nov 04, 2014 at 10:14:28AM +0900, Namhyung Kim escreveu:
> Now my Archlinux box shows module symbols correctly.

Now my RHEL6 box doesn't build:

> +++ b/tools/perf/util/dso.c
> @@ -141,17 +141,13 @@ int dso__read_binary_type_filename(const struct dso *dso,
>  	return ret;

>  static const struct {
>  	const char *fmt;
>  	int (*decompress)(const char *input, int output);
>  } compressions[] = {
> -	{ "gz", decompress_dummy },
> +#ifdef HAVE_ZLIB_SUPPORT
> +	{ "gz", gzip_decompress_to_file },
> +#endif
>  	{ NULL, },
>  };

  CC       /tmp/build/perf/util/dso.o
cc1: warnings being treated as errors
util/dso.c:151: error: missing initializer
util/dso.c:151: error: (near initialization for
‘compressions[1].decompress’)
make[1]: *** [/tmp/build/perf/util/dso.o] Error 1
make: Leaving directory `/home/gita/perf-3.18.0-rc1/tools/perf'
make: *** [install] Error 2
[acme@zoo linux]$

Will try and fix it, nevermind :-)

- Arnaldo
