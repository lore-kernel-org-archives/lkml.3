Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297AbaAVLgs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 06:36:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35072 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754528AbaAVLgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 06:36:44 -0500
Date: Wed, 22 Jan 2014 12:36:30 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: Weird plugin paths in perf and perf.so binaries with 3.14 merge
 window
Message-ID: <20140122113630.GA1132@krava.brq.redhat.com>
References: <CA+5PVA7LcDe5Y2RePTFbLdSHd85WhHcHHnFw2mBycfFRJ2m-FQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+5PVA7LcDe5Y2RePTFbLdSHd85WhHcHHnFw2mBycfFRJ2m-FQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 03:02:43PM -0500, Josh Boyer wrote:
> Hi All,
> 
> I went to build Linux v3.13-737-g7fe67a1 in Fedora this morning and it
> resulted in RPM complaining that the perf and perf.so binaries had
> strings in them that matched the RPM_BUILD_ROOT string.  That fails
> the RPM build.
> 
> Looking over the logs, I see that the traceevent plugins are getting a
> rather weird -DPLUGIN_DIR define passed to them.  E.g.:
> 
> gcc -c -g -Wall   -I. -I
> /home/jwboyer/kernel/kernel-3.13.fc21/linux-3.14.0-0.rc0.git1.1.fc21.x86_64/tools/lib/traceevent/../../include
>  '-DPLUGIN_DIR="/home/jwboyer/rpmbuild/BUILDROOT/kernel-3.14.0-0.rc0.git1.1.fc21.x86_64//usr//usr/lib64/traceevent/plugins"'
>  -D_GNU_SOURCE -std=gnu99 -fPIC
> /home/jwboyer/kernel/kernel-3.13.fc21/linux-3.14.0-0.rc0.git1.1.fc21.x86_64/tools/lib/traceevent/parse-filter.c
> -o parse-filter.o
> 
> We're building perf like so:
> 
> make -s -j8 -C tools/perf V=1 WERROR=0 NO_LIBUNWIND=1
> HAVE_CPLUS_DEMANGLE=1 NO_GTK2=1 NO_LIBNUMA=1 NO_STRLCPY=1 NO_BIONIC=1
> prefix=/usr DESTDIR=/home/jwboyer/rpmbuild/BUILDROOT/kernel-3.14.0-0.rc0.git1.1.fc21.x86_64
> all
> 
> and installing it via:
> 
> make -s -j8 -C tools/perf V=1 WERROR=0 NO_LIBUNWIND=1
> HAVE_CPLUS_DEMANGLE=1 NO_GTK2=1 NO_LIBNUMA=1 NO_STRLCPY=1 NO_BIONIC=1
> prefix=/usr DESTDIR=/home/jwboyer/rpmbuild/BUILDROOT/kernel-3.14.0-0.rc0.git1.1.fc21.x86_64
> install-bin
> 
> make -s -j8 -C tools/perf V=1 WERROR=0 NO_LIBUNWIND=1
> HAVE_CPLUS_DEMANGLE=1 NO_GTK2=1 NO_LIBNUMA=1 NO_STRLCPY=1 NO_BIONIC=1
> prefix=/usr DESTDIR=/home/jwboyer/rpmbuild/BUILDROOT/kernel-3.14.0-0.rc0.git1.1.fc21.x86_64
> install-python_ext
> 
> This has worked for all the builds up until this point.
> 
> Somehow the perf and perf.so binaries are getting the string being
> passed via -DPLUGIN_DIR into them, likely through the libtraceevent.a
> link.  I'm pretty sure that (1) the string being passed is totally
> broken and should be "/usr/lib64/traceevent/plugins" and (2) that I
> haven't come close to deciphering how to fix this.
> 
> So, could you please look this over and see where the define is
> getting messed up?

hi,
just get to this.. checking

jirka
