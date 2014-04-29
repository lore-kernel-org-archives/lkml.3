Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964852AbaD2OYO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 10:24:14 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:43337 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbaD2OYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 10:24:12 -0400
Message-ID: <535FB607.7070604@gmail.com>
Date: Tue, 29 Apr 2014 08:24:07 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org
CC: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] perf tests: Add static build make test
References: <1398760413-7574-1-git-send-email-jolsa@kernel.org>
In-Reply-To: <1398760413-7574-1-git-send-email-jolsa@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/29/14, 2:33 AM, Jiri Olsa wrote:
> Adding test for building static perf build into the automated
> suite. Also available via following commands:
>
>    $ make -f tests/make make_static
>    - make_static: cd . && make -f Makefile DESTDIR=/tmp/tmp.7u5MlB4njo LDFLAGS=-static
>    $ make -f tests/make make_static_O
>    - make_static_O: cd . && make -f Makefile O=/tmp/tmp.Ay6r3wEmtX DESTDIR=/tmp/tmp.vK0KQwO0Vi LDFLAGS=-static
>
> Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>   tools/perf/tests/make | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/tools/perf/tests/make b/tools/perf/tests/make
> index 5daeae1..2f92d6e 100644
> --- a/tools/perf/tests/make
> +++ b/tools/perf/tests/make
> @@ -46,6 +46,7 @@ make_install_man    := install-man
>   make_install_html   := install-html
>   make_install_info   := install-info
>   make_install_pdf    := install-pdf
> +make_static         := LDFLAGS=-static
>
>   # all the NO_* variable combined
>   make_minimal        := NO_LIBPERL=1 NO_LIBPYTHON=1 NO_NEWT=1 NO_GTK2=1
> @@ -87,6 +88,7 @@ run += make_install_bin
>   # run += make_install_info
>   # run += make_install_pdf
>   run += make_minimal
> +run += make_static
>
>   ifneq ($(call has,ctags),)
>   run += make_tags
>

Acked-by: David Ahern <dsahern@gmail.com>
