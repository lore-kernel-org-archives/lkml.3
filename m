Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751216AbaK1MpY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 07:45:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36217 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751172AbaK1MpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 07:45:19 -0500
Date: Fri, 28 Nov 2014 13:44:26 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>, Milian Wolff <mail@milianw.de>
Subject: Re: [PATCH v2 2/2] perf record: Show precise number of samples
Message-ID: <20141128124426.GE27703@krava.brq.redhat.com>
References: <1417158708-31401-2-git-send-email-namhyung@kernel.org>
 <1417158859-31538-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417158859-31538-1-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2014 at 04:14:19PM +0900, Namhyung Kim wrote:
> After perf record finishes, it prints file size and number of samples
> in the file but this info is wrong since it assumes typical sample
> size of 24 bytes and divides file size by the value.
> 
> However as we post-process recorded samples for build-id, it can show
> correct number like below.  If build-id post-processing is not requested
> just omit the wrong number of samples.
> 
>   $ perf record noploop 1
>   [ perf record: Woken up 1 times to write data ]
>   [ perf record: Captured and wrote 0.159 MB perf.data (3989 samples) ]
> 
>   $ perf report --stdio -n
>   # To display the perf.data header info, please use --header/--header-only options.
>   #
>   # Samples: 3K of event 'cycles'
>   # Event count (approx.): 3771330663
>   #
>   # Overhead       Samples  Command  Shared Object     Symbol
>   # ........  ............  .......  ................  ..........................
>   #
>       99.90%          3982  noploop  noploop           [.] main
>        0.09%             1  noploop  ld-2.17.so        [.] _dl_check_map_versions
>        0.01%             1  noploop  [kernel.vmlinux]  [k] setup_arg_pages
>        0.00%             5  noploop  [kernel.vmlinux]  [k] intel_pmu_enable_all
> 
> Reported-by: Milian Wolff <mail@milianw.de>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>

eeeey great, I mean.. finally ;-) 

Reviewed-by: Jiri Olsa <jolsa@kernel.org>

thanks,
jirka
