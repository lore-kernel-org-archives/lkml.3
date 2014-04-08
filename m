Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757442AbaDHPlT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 11:41:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50244 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756891AbaDHPlR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 11:41:17 -0400
Date: Tue, 8 Apr 2014 17:41:01 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Vladimir Nikulichev <nvs@tbricks.com>
Cc: Namhyung Kim <namhyung@kernel.org>, linux-perf-users@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Correctly handle symbols in VDSO
Message-ID: <20140408154101.GA21094@krava.brq.redhat.com>
References: <D6A5CDD8-F8F1-4C9D-8BCF-83A739FD6A2F@tbricks.com>
 <87eh19y8cm.fsf@sejong.aot.lge.com>
 <3C60FB26-A78B-4E37-B4A6-E6F7283CEB4C@tbricks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3C60FB26-A78B-4E37-B4A6-E6F7283CEB4C@tbricks.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2014 at 07:24:22PM +0400, Vladimir Nikulichev wrote:
> Hi Namhyung,
> 
> On Apr 7, 2014, at 10:14 AM, Namhyung Kim <namhyung@kernel.org> wrote:
> 
> > Just one question below..
> > 
> >> 
> >> ---------------------------------------------------------------------------------------------------------------------------
> >> 
> >> perf tools: Adjust symbols in VDSO
> >> 
> >> Signed-off-by: Vladimir Nikulichev <nvs@tbricks.com>
> >> 
> >> diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
> >> index 3b7dbf5..9c8b23b 100644
> >> --- a/tools/perf/util/symbol-elf.c
> >> +++ b/tools/perf/util/symbol-elf.c
> >> @@ -6,6 +6,7 @@
> >> #include <inttypes.h>
> >> 
> >> #include "symbol.h"
> >> +#include "vdso.h"
> >> #include <symbol/kallsyms.h>
> >> #include "debug.h"
> >> 
> >> @@ -618,6 +619,8 @@ int symsrc__init(struct symsrc *ss, struct dso *dso, const char *name,
> >> 		GElf_Shdr shdr;
> >> 		ss->adjust_symbols = (ehdr.e_type == ET_EXEC ||
> >> 				ehdr.e_type == ET_REL ||
> >> +				(dso->symsrc_filename == NULL &&
> > 
> > Is this really needed?  Just checking is_vdso_map() seems to work well
> > for me.  Did you have a specific reason to add it?
> > 
> 
> Nothing specific, just to don't call string operations in most cases. But here it is only a matter of coding style, of course.
> Attaching shorter version of the patch.
> 
> ----------------------------
> 
> perf tools: Adjust symbols in VDSO

hi,
could you please put explanation from first email
into the patch changelog?

cc-ing lkml

thanks,
jirka
