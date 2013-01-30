Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069Ab3A3D2g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 22:28:36 -0500
Received: from mail.skyhub.de ([78.46.96.112]:49174 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751775Ab3A3D2e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 22:28:34 -0500
Date: Wed, 30 Jan 2013 04:28:31 +0100
From: Borislav Petkov <bp@alien8.de>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Thomas Backlund <tmb@mageia.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: perf 3.8-rc build failure:  undefined reference to `strlcpy'
Message-ID: <20130130032831.GA30965@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Namhyung Kim <namhyung@kernel.org>,
	Thomas Backlund <tmb@mageia.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Jiri Olsa <jolsa@redhat.com>
References: <51074E9D.3040803@mageia.org>
 <20130129103722.GE14444@pd.tnic>
 <87ehh3v2jo.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87ehh3v2jo.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2013 at 11:15:55AM +0900, Namhyung Kim wrote:
> Please see my reply on another post from Thomas:
> 
>   https://lkml.org/lkml/2013/1/29/32
> 
> It's not like a build failure of perf tools, it's just a result of
> feature test so should not affect the build of perf itself, right?

Doh, I see it. It is the -DHAVE_STRLCPY test, of course. And it happens
only with a V=1 build, so actually there's not a build problem.

> Why it confuses us is that we don't show any compile message if -s
> option is given to make, so I posted a patch to hide CHK and above
> failure message when -s option is specified.

Hm, trying your patch ontop of acme's perf/core still shows CHK stuff

$ make -s tools/perf
    DESCEND perf
    CHK -fstack-protector-all
    CHK -Wstack-protector
    CHK -Wvolatile-register-var
    CHK bionic
    CHK libelf
    CHK libdw
    ...


and that's because I'm doing the build from the toplevel repo and not in
perf/. If I switch to perf first, it is silent:

$ make -s
Makefile:809: No bfd.h/libbfd found, install binutils-dev[el]/zlib-static to gain symbol demangling
Makefile:846: No numa.h found, disables 'perf bench numa mem' benchmark, please install numa-libs-devel or libnuma-dev
$

Oh, and one more thing, there's tools/scripts/Makefile.include which
looks at -s already and perf/Makefile includes it so you probably want
to put your change there so that all tools use it.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
