Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456Ab3INFtM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 01:49:12 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:42529 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025Ab3INFtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 01:49:10 -0400
Date: Sat, 14 Sep 2013 07:49:06 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        eranian@google.com, paulus@samba.org, hpa@zytor.com,
        peterz@infradead.org, efault@gmx.de, fweisbec@gmail.com,
        adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de
Subject: Re: perf/compat: Sharpen the libaudit dependencies test
Message-ID: <20130914054906.GA364@gmail.com>
References: <tip-w28d1o3uslden0k57653kda7@git.kernel.org>
 <20130912132706.GD23826@gmail.com>
 <20130913192051.GA26865@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130913192051.GA26865@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@ghostprotocols.net> wrote:

> Em Thu, Sep 12, 2013 at 03:27:06PM +0200, Ingo Molnar escreveu:
> > There are older libaudit versions that don't have an audit_errno_to_name() 
> > method, resulting in a builtin-trace.c build error:
> > 
> >   builtin-trace.c: In function ‘trace__sys_exit’:
> >   builtin-trace.c:794: warning: implicit declaration of function ‘audit_errno_to_name’
> > 
> > Expand the libaudit test to detect this.
> 
> Lets sharpen it a bit more ;-)
>  
> CHK libaudit
> <stdin>: In function ‘main’:
> <stdin>:5:9: error: ‘error’ undeclared (first use in this function)
> <stdin>:5:9: note: each undeclared identifier is reported only once for each function it appears in
> <stdin>:5:15: error: expected ‘)’ before ‘message’
> make: Entering directory `/home/git/linux/tools/perf'
> config/Makefile:238: No libaudit.h found, disables 'trace' tool, please install audit-libs-devel or libaudit-dev
> 
> We need this folded in to buind it, so that the test works:
> 
> diff --git a/tools/perf/config/feature-tests.mak b/tools/perf/config/feature-tests.mak
> index 5608add..7f550c1 100644
> --- a/tools/perf/config/feature-tests.mak
> +++ b/tools/perf/config/feature-tests.mak
> @@ -210,7 +210,7 @@ define SOURCE_LIBAUDIT
>  
>  int main(void)
>  {
> -	printf("error message: %s\n", audit_errno_to_name(0));
> +	printf(\"error message: %s\n\", audit_errno_to_name(0));

indeed, I only tested that it turned the feature off :-/

Thanks,

	Ingo
