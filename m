Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268Ab3JBJm2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 05:42:28 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:42613 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979Ab3JBJmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 05:42:25 -0400
Date: Wed, 2 Oct 2013 11:42:20 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Namhyung Kim <namhyung@gmail.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH] perf tool: simplify a git command in PERF-VERSION-GEN
Message-ID: <20131002094220.GA9358@gmail.com>
References: <1380702502-9171-1-git-send-email-artagnon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380702502-9171-1-git-send-email-artagnon@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ramkumar Ramachandra <artagnon@gmail.com> wrote:

> Replace a complex git log invocation with a simpler git rev-parse
> invocation.
> 
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Namhyung Kim <namhyung@gmail.com>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
> ---
>  tools/perf/util/PERF-VERSION-GEN | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/perf/util/PERF-VERSION-GEN b/tools/perf/util/PERF-VERSION-GEN
> index 15a77b7..b23d11b 100755
> --- a/tools/perf/util/PERF-VERSION-GEN
> +++ b/tools/perf/util/PERF-VERSION-GEN
> @@ -18,7 +18,7 @@ TAG=
>  if test -d ../../.git -o -f ../../.git
>  then
>  	TAG=$(git describe --abbrev=0 --match "v[0-9].[0-9]*" 2>/dev/null )
> -	CID=$(git log -1 --abbrev=4 --pretty=format:"%h" 2>/dev/null) && CID="-g$CID"
> +	CID=$(git rev-parse --short HEAD 2>/dev/null) && CID="-g$CID"

This shaves 4 milliseconds off the build time as well.

Acked-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo
