Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473AbaENCP7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 22:15:59 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:46069 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024AbaENCP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 22:15:57 -0400
Message-ID: <5372D1D9.4070503@gmail.com>
Date: Tue, 13 May 2014 20:15:53 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Alexis Berlemont <alexis.berlemont@gmail.com>,
        linux-kernel@vger.kernel.org
CC: jolsa@redhat.com, acme@ghostprotocols.net, mingo@kernel.org
Subject: Re: [PATCH 00/34] perf and kconfig / kbuild
References: <1400018609-20486-1-git-send-email-alexis.berlemont@gmail.com>
In-Reply-To: <1400018609-20486-1-git-send-email-alexis.berlemont@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/13/14, 4:02 PM, Alexis Berlemont wrote:
> Hello,
>
> A few months ago, I tried to make a proposal to introduce Kconfig in
> perf's generation procedure.
> (cf. https://lkml.org/lkml/2013/12/20/511)
>
> I started from David Ahern's work; I was not aware that Jiri Olsa
> pushed further the idea and proposed an alternative which integrated
> kbuild too.
>
> So, here is another proposal based on Jiri Olsa work (from April 2013).
> * Most of the NO_* and HAVE_* makefile variables were removed on
>    behalf of Kconfig's ones (CONFIG_*); perf source code was modified
>    accordingly;
> * These changes make the glue files tools/perf/config/Makefile.fix-* useless
> * The build test cases now relies on generated configuration files (in
>    tools/perf/tests/configs);
>

Thanks for picking this up. I skimmed through all of the patches and 
conceptually looks good. I doubt I will have time for a detailed review 
any time soon.

Looks like they apply to Linus' top of tree but with a few errors -- see 
below. You should always run checkpatch.pl before sending out:

Applying: kbuild: Introduce KBUILD_AUTOCONF variable for auto.conf include
Applying: kbuild: Introduce KCONFIG_AUTOCONFIGDEP variable for conf tool
Applying: perf tools: Kbuild builtin source related fixies
Applying: perf tools: Kbuild source related fixies
Applying: perf tools: Add kbuild support into Makefile.kbuild
Applying: perf kbuild: fix recursive invocation of config/features-checks
Applying: perf kbuild: store in config-detected missing variables 
(libdir, ...)
Applying: perf kbuild: remove useless #ifdef directives
Applying: perf kbuild: fix a link issue if BUILTIN_TRACE is disabled
Applying: perf kbuild: add missing files and missing flags in Kbuild files
/Users/dsa/sw/perf/ahern.git/.git/rebase-apply/patch:30: trailing 
whitespace.
CFLAGS_Context.o += -Wno-redundant-decls -Wno-strict-prototypes
/Users/dsa/sw/perf/ahern.git/.git/rebase-apply/patch:137: trailing 
whitespace.
CFLAGS_trace-event-perl.o   += -Wno-redundant-decls -Wno-strict-prototypes
/Users/dsa/sw/perf/ahern.git/.git/rebase-apply/patch:138: trailing 
whitespace.
CFLAGS_trace-event-perl.o   += -Wno-unused-parameter -Wno-shadow -Wno-undef
/Users/dsa/sw/perf/ahern.git/.git/rebase-apply/patch:143: trailing 
whitespace.
CFLAGS_trace-event-python.o += -Wno-redundant-decls -Wno-strict-prototypes
warning: 4 lines applied after fixing whitespace errors.
Applying: perf kbuild: update kbuild files according to last changes
Applying: perf kbuild: remove legacy slang-related build variables
Applying: perf kbuild: remove legacy libaudit-related build variables
Applying: perf kbuild: remove legacy libgtk2-related build variables
/Users/dsa/sw/perf/ahern.git/.git/rebase-apply/patch:204: trailing 
whitespace.
#else
warning: 1 line applied after fixing whitespace errors.
Applying: perf kbuild: remove legacy libperl-related build variables
Applying: perf kbuild: remove legacy timerfd-related build variable
Applying: perf kbuild: remove legacy demangle-related build variables
Applying: perf kbuild: remove legacy on_exit-related build variable
Applying: perf kbuild: remove legacy backtrace-related build variable
Applying: perf kbuild: remove legacy numa-related build variable
Applying: perf kbuild: remove legacy bionic-related build variable
Applying: perf kbuild: remove legacy libelf-related build variables (1st 
part)
Applying: perf kbuild: remove legacy libelf-related build variables (2nd 
part)
Applying: perf kbuild: remove legacy libdwarf-related build variables
/Users/dsa/sw/perf/ahern.git/.git/rebase-apply/patch:342: trailing 
whitespace.
       endif # CONFIG_LIBDWARF_UNWIND
warning: 1 line applied after fixing whitespace errors.
Applying: perf kbuild: remove legacy libunwind-related build variables
Applying: perf kbuild: remove legacy libpython-related build variable
Applying: perf kbuild: add generated Kconfig build-test cases
Applying: perf kbuild: fix installation of traceevent plugins
/Users/dsa/sw/perf/ahern.git/.git/rebase-apply/patch:74: trailing 
whitespace.
make_pure           :=
warning: 1 line applied after fixing whitespace errors.
Applying: perf kbuild: fix tarpkg target in tests/make
Applying: perf kbuild: update Kbuild files with new and removed sources
Applying: perf kbuild: update build test configurations
/Users/dsa/sw/perf/ahern.git/.git/rebase-apply/patch:773: trailing 
whitespace.

warning: 1 line applied after fixing whitespace errors.
Applying: perf kbuild: relocate the configs generating script
Applying: perf kbuild: minor changes
Applying: perf kbuild: remove Makefile.perf

David

