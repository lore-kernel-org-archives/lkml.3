Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757801Ab3JKMby (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 08:31:54 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:50213 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754060Ab3JKMbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 08:31:51 -0400
Message-ID: <5257EFB3.9030009@hitachi.com>
Date: Fri, 11 Oct 2013 21:31:47 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Namhyung Kim <namhyung@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>, lkml <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH -tip ] [BUGFIX] perf probe: fix to initialize fname always
 before use it
References: <20131011122317.9662.29736.stgit@kbuild-fedora.novalocal>
In-Reply-To: <20131011122317.9662.29736.stgit@kbuild-fedora.novalocal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnaldo,

I've found a bug in my previous patch which was already picked
in the perf/urgent branch. The buggy commit id is

e08cfd4bda7683cdbe6971c26cf23e2afdb1e7a8

And this is not related to the previous series of perf probe
updates.

Thank you,

(2013/10/11 21:23), Masami Hiramatsu wrote:
> Fix perf probe --list to initialize fname local var always before
> use it. This may cause a SEGV if there is a probe which is in
> the function body but not in any inline function.
> 
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Cc: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/util/probe-finder.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
> index c044052..e41b094 100644
> --- a/tools/perf/util/probe-finder.c
> +++ b/tools/perf/util/probe-finder.c
> @@ -1460,10 +1460,10 @@ int debuginfo__find_probe_point(struct debuginfo *self, unsigned long addr,
>  			goto post;
>  		}
>  
> +		fname = dwarf_decl_file(&spdie);
>  		if (addr == (unsigned long)baseaddr) {
>  			/* Function entry - Relative line number is 0 */
>  			lineno = baseline;
> -			fname = dwarf_decl_file(&spdie);
>  			goto post;
>  		}


-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


