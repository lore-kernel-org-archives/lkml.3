Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425AbaFBQx6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 12:53:58 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:48856 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbaFBQx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 12:53:57 -0400
MIME-Version: 1.0
In-Reply-To: <1401727474-19370-1-git-send-email-nasa4836@gmail.com>
References: <87sintf4lj.fsf@sejong.aot.lge.com> <1401727474-19370-1-git-send-email-nasa4836@gmail.com>
From: Jianyu Zhan <nasa4836@gmail.com>
Date: Tue, 3 Jun 2014 00:53:16 +0800
Message-ID: <CAHz2CGVjpJX59W-uV_nLvsQ70GdR1ePDkjsV5FRA0dGecA7gxA@mail.gmail.com>
Subject: Re: [PATCH] perf: fix 'make help' message error
To: namhyung@kernel.org, a.p.zijlstra@chello.nl, paulus@samba.org,
        mingo@redhat.com, acme@kernel.org, jolsa@kernel.org,
        jean.pihet@linaro.org
Cc: LKML <linux-kernel@vger.kernel.org>, Jianyu Zhan <nasa4836@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 3, 2014 at 12:44 AM, Jianyu Zhan <nasa4836@gmail.com> wrote:
> Hi, Namhyung,
>
>>I don't know what's the correct way to do this.  But it seems like the
>>prefix was overwritten when given from user, so below patch will work
>>also.
>
> This does work too. So I update the patch as below:
>
> ---8<---
> From: Jianyu Zhan <nasa4836@gmail.com>
> Date: Sat, 24 May 2014 22:34:26 +0800
> Subject: [PATCH] perf: fix 'make help' message error
>
> Currently 'make help' message has such hint:
>
>    use "make prefix=<path> <install target>" to install to a particular
>        path like make prefix=/usr/local install install-doc
>
> But this is misleading, when I specify "prefix=/usr/local", it has got no
> respect at all.
>
> This is because that, "DESTDIR" is condiered first. In this case, "DESTDIR"
> has an empty value, so "prefix" is honored. However, "prefix" is unconditionally
> assigned to $HOME, regardless of what it is set to from command line. So our
> "prefix" setting got no respect and the actual destination falls back to $HOME.
>
> This patch fixes this issue and corrects the help message.
>
> Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
> ---
>  tools/perf/Makefile.perf   | 4 ++--
>  tools/perf/config/Makefile | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
> index 895edd3..5918063 100644
> --- a/tools/perf/Makefile.perf
> +++ b/tools/perf/Makefile.perf
> @@ -784,8 +784,8 @@ help:
>         @echo ''
>         @echo 'Perf install targets:'
>         @echo '  NOTE: documentation build requires asciidoc, xmlto packages to be installed'
> -       @echo '  HINT: use "make prefix=<path> <install target>" to install to a particular'
> -       @echo '        path like make prefix=/usr/local install install-doc'
> +       @echo '  HINT: use "prefix" or "DESTDIR" to install to a particular'
> +       @echo '        path like "make prefix=/usr/local install install-doc"'
>         @echo '  install        - install compiled binaries'
>         @echo '  install-doc    - install *all* documentation'
>         @echo '  install-man    - install manpage documentation'
> diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
> index 802cf54..53dc11e 100644
> --- a/tools/perf/config/Makefile
> +++ b/tools/perf/config/Makefile
> @@ -601,7 +601,7 @@ endif
>
>
>  # Make the path relative to DESTDIR, not to prefix
>  ifndef DESTDIR
> -prefix = $(HOME)
> +prefix ?= $(HOME)
>  endif
>  bindir_relative = bin
>  bindir = $(prefix)/$(bindir_relative)

Cc Namyung with a correct email...


Thanks,
Jianyu Zhan
