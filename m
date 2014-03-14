Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028AbaCNUZw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 16:25:52 -0400
Received: from mail-yh0-f46.google.com ([209.85.213.46]:39418 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755350AbaCNUZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 16:25:51 -0400
Date: Fri, 14 Mar 2014 17:24:21 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Don Zickus <dzickus@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 1/5] perf tests: Add tip/pid mmap automated tests
Message-ID: <20140314202421.GA14945@ghostprotocols.net>
References: <1394805606-25883-1-git-send-email-jolsa@redhat.com>
 <1394805606-25883-2-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1394805606-25883-2-git-send-email-jolsa@redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Mar 14, 2014 at 03:00:02PM +0100, Jiri Olsa escreveu:
> Adding automated test for memory maps lookup within
> multiple machines threads.

  CC       /tmp/build/perf/arch/x86/util/tsc.o
tests/mmap-events.c: In function ‘mmap_events’:
tests/mmap-events.c:157:18: error: declaration of ‘thread’ shadows a global declaration [-Werror=shadow]
tests/mmap-events.c:46:14: error: shadowed declaration is here [-Werror=shadow]
tests/mmap-events.c: In function ‘thread’:
tests/mmap-events.c:54:7: error: ignoring return value of ‘write’, declared with attribute warn_unused_result [-Werror=unused-result]
cc1: all warnings being treated as errors
make[1]: *** [/tmp/build/perf/tests/mmap-events.o] Error 1
make[1]: *** Waiting for unfinished jobs....
make: *** [install-bin] Error 2
make: Leaving directory `/home/acme/git/linux/tools/perf'

real	0m10.024s
user	0m45.900s
sys	0m4.932s
[acme@ssdandy linux]$ 

[acme@ssdandy linux]$ cat /etc/fedora-release 
Fedora release 18 (Spherical Cow)
[acme@ssdandy linux]$ gcc -v
Using built-in specs.
COLLECT_GCC=/usr/bin/gcc
COLLECT_LTO_WRAPPER=/usr/libexec/gcc/x86_64-redhat-linux/4.7.2/lto-wrapper
Target: x86_64-redhat-linux
Configured with: ../configure --prefix=/usr --mandir=/usr/share/man
--infodir=/usr/share/info
--with-bugurl=http://bugzilla.redhat.com/bugzilla --enable-bootstrap
--enable-shared --enable-threads=posix --enable-checking=release
--disable-build-with-cxx --disable-build-poststage1-with-cxx
--with-system-zlib --enable-__cxa_atexit --disable-libunwind-exceptions
--enable-gnu-unique-object --enable-linker-build-id
--with-linker-hash-style=gnu
--enable-languages=c,c++,objc,obj-c++,java,fortran,ada,go,lto
--enable-plugin --enable-initfini-array --enable-java-awt=gtk
--disable-dssi --with-java-home=/usr/lib/jvm/java-1.5.0-gcj-1.5.0.0/jre
--enable-libgcj-multifile --enable-java-maintainer-mode
--with-ecj-jar=/usr/share/java/eclipse-ecj.jar
--disable-libjava-multilib --with-ppl --with-cloog --with-tune=generic
--with-arch_32=i686 --build=x86_64-redhat-linux
Thread model: posix
gcc version 4.7.2 20121109 (Red Hat 4.7.2-8) (GCC) 
[acme@ssdandy linux]$
