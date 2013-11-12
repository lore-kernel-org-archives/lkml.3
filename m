Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856Ab3KLPuF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 10:50:05 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:51958 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280Ab3KLPuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 10:50:02 -0500
Message-ID: <52824E28.8090102@gmail.com>
Date: Tue, 12 Nov 2013 08:50:00 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] perf trace: Beautify fifth argument of mmap() as
 fd
References: <1384237500-22991-1-git-send-email-namhyung@kernel.org>
In-Reply-To: <1384237500-22991-1-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/13, 11:24 PM, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
>
> The fifth argument of mmap syscall is fd and it often contains -1 as a
> value for anon mappings.  Without this patch it doesn't show the file
> name as well as it shows -1 as 4294967295.
>
> Cc: David Ahern <dsahern@gmail.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>   tools/perf/builtin-trace.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
> index c3008b1c369c..aeb6296a76bd 100644
> --- a/tools/perf/builtin-trace.c
> +++ b/tools/perf/builtin-trace.c
> @@ -951,7 +951,8 @@ static struct syscall_fmt {
>   	{ .name	    = "mmap",	    .hexret = true,
>   	  .arg_scnprintf = { [0] = SCA_HEX,	  /* addr */
>   			     [2] = SCA_MMAP_PROT, /* prot */
> -			     [3] = SCA_MMAP_FLAGS, /* flags */ }, },
> +			     [3] = SCA_MMAP_FLAGS, /* flags */
> +			     [4] = SCA_FD, 	  /* fd */ }, },
>   	{ .name	    = "mprotect",   .errmsg = true,
>   	  .arg_scnprintf = { [0] = SCA_HEX, /* start */
>   			     [2] = SCA_MMAP_PROT, /* prot */ }, },
>

Looks good to me.

Acked-by: David Ahern <dsahern@gmail.com>
