Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751Ab3IMTVC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 15:21:02 -0400
Received: from mail-ye0-f182.google.com ([209.85.213.182]:58378 "EHLO
	mail-ye0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753933Ab3IMTVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 15:21:00 -0400
Date: Fri, 13 Sep 2013 16:20:51 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        eranian@google.com, paulus@samba.org, hpa@zytor.com,
        peterz@infradead.org, efault@gmx.de, fweisbec@gmail.com,
        adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de
Subject: Re: perf/compat: Sharpen the libaudit dependencies test
Message-ID: <20130913192051.GA26865@ghostprotocols.net>
References: <tip-w28d1o3uslden0k57653kda7@git.kernel.org>
 <20130912132706.GD23826@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130912132706.GD23826@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Sep 12, 2013 at 03:27:06PM +0200, Ingo Molnar escreveu:
> There are older libaudit versions that don't have an audit_errno_to_name() 
> method, resulting in a builtin-trace.c build error:
> 
>   builtin-trace.c: In function ‘trace__sys_exit’:
>   builtin-trace.c:794: warning: implicit declaration of function ‘audit_errno_to_name’
> 
> Expand the libaudit test to detect this.

Lets sharpen it a bit more ;-)
 
CHK libaudit
<stdin>: In function ‘main’:
<stdin>:5:9: error: ‘error’ undeclared (first use in this function)
<stdin>:5:9: note: each undeclared identifier is reported only once for each function it appears in
<stdin>:5:15: error: expected ‘)’ before ‘message’
make: Entering directory `/home/git/linux/tools/perf'
config/Makefile:238: No libaudit.h found, disables 'trace' tool, please install audit-libs-devel or libaudit-dev

We need this folded in to buind it, so that the test works:

diff --git a/tools/perf/config/feature-tests.mak b/tools/perf/config/feature-tests.mak
index 5608add..7f550c1 100644
--- a/tools/perf/config/feature-tests.mak
+++ b/tools/perf/config/feature-tests.mak
@@ -210,7 +210,7 @@ define SOURCE_LIBAUDIT
 
 int main(void)
 {
-	printf("error message: %s\n", audit_errno_to_name(0));
+	printf(\"error message: %s\n\", audit_errno_to_name(0));
 	return audit_open();
 }
 endef

Applying, thanks!

- Arnaldo

> 
> diff --git a/tools/perf/config/feature-tests.mak b/tools/perf/config/feature-tests.mak
> index 708fb8e..5608add 100644
> --- a/tools/perf/config/feature-tests.mak
> +++ b/tools/perf/config/feature-tests.mak
> @@ -210,6 +210,7 @@ define SOURCE_LIBAUDIT
>  
>  int main(void)
>  {
> +	printf("error message: %s\n", audit_errno_to_name(0));
>  	return audit_open();
>  }
>  endef
