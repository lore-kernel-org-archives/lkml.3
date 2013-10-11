Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320Ab3JKS2w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 14:28:52 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:61923 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558Ab3JKS2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 14:28:51 -0400
Date: Fri, 11 Oct 2013 15:28:33 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH V6 1/8] perf tools: validate kcore module addresses
Message-ID: <20131011182833.GQ28369@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Oct 09, 2013 at 03:01:11PM +0300, Adrian Hunter escreveu:
> -static bool kcore_filename_from_kallsyms_filename(char *kcore_filename,
> -						  const char *kallsyms_filename)
> +static bool filename_from_kallsyms_filename(char *filename,
> +					    const char *basename,
> +					    const char *kallsyms_filename)

In Fedora12:

  CC       /tmp/build/perf/util/symbol.o
cc1: warnings being treated as errors
util/symbol.c: In function ‘filename_from_kallsyms_filename’:
util/symbol.c:937: error: declaration of ‘__xpg_basename’ shadows a
global declaration
/usr/include/libgen.h:35: error: shadowed declaration is here
make[1]: *** [/tmp/build/perf/util/symbol.o] Error 1
make: *** [install] Error 2
make: Leaving directory `/home/acme/git/linux/tools/perf'
[acme@fedora12 linux]$ 

Fixing it up renaming it to base_name,


Oops, one more:

  CC       /tmp/build/perf/util/symbol-elf.o
cc1: warnings being treated as errors
util/symbol-elf.c: In function ‘kcore__add_phdr’:
util/symbol-elf.c:1167: error: declaration of ‘index’ shadows a global
declaration
/usr/include/string.h:487: error: shadowed declaration is here
util/symbol-elf.c: In function ‘kcore_extract__create’:
util/symbol-elf.c:1202: error: declaration of ‘index’ shadows a global
declaration
/usr/include/string.h:487: error: shadowed declaration is here
make[1]: *** [/tmp/build/perf/util/symbol-elf.o] Error 1
make: *** [install] Error 2
make: Leaving directory `/home/acme/git/linux/tools/perf'
[acme@fedora12 linux]$

Will switch to 'idx'.

- Arnaldo

----- End forwarded message -----
