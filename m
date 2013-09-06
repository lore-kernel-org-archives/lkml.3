Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751177Ab3IFKRy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 06:17:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42977 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750884Ab3IFKRw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 06:17:52 -0400
Date: Fri, 6 Sep 2013 12:17:20 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Jean Pihet <jean.pihet@linaro.org>
Cc: Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Patch Tracking <patches@linaro.org>
Subject: Re: [PATCH 3/3] perf: parse the .debug_frame section in case
 .eh_frame is not present
Message-ID: <20130906101720.GA1055@krava.brq.redhat.com>
References: <1378317854-25965-1-git-send-email-jean.pihet@linaro.org>
 <1378317854-25965-4-git-send-email-jean.pihet@linaro.org>
 <20130905163030.GF1100@krava.brq.redhat.com>
 <CAFrcx1=QA3EpPAxx7Jx=87WbupAEFQ8L+t9pTJ=+3ucVTE+xtg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFrcx1=QA3EpPAxx7Jx=87WbupAEFQ8L+t9pTJ=+3ucVTE+xtg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 06, 2013 at 11:31:17AM +0200, Jean Pihet wrote:
> Hi Jiri,
> 
> On 5 September 2013 18:30, Jiri Olsa <jolsa@redhat.com> wrote:
> > On Wed, Sep 04, 2013 at 08:04:14PM +0200, Jean Pihet wrote:
> >> On ARM the debug info is not present in the .eh_frame sections but
> >> instead in .debug_frame.
> >> Use libunwind to load and parse the debug info.
> >
> > hum, cannot make final link:
> >
> > $ make LIBUNWIND_DIR=/opt/libunwind/
> >     CHK -fstack-protector-all
> >     CHK -Wstack-protector
> >     CHK -Wvolatile-register-var
> >     CHK -D_FORTIFY_SOURCE=2
> >     CHK bionic
> >     CHK libelf
> >     CHK libdw
> >     CHK -DLIBELF_MMAP
> >     CHK -DLIBELF_MMAP
> >     CHK libunwind
> >     CHK libaudit
> >
> > ...
> >
> > make[1]: `liblk.a' is up to date.
> >     SUBDIR /home/jolsa/linux-perf/tools/lib/traceevent/
> >     LINK perf
> > libperf.a(unwind.o): In function `find_proc_info':
> > /home/jolsa/linux-perf/tools/perf/util/unwind.c:339: undefined reference to `_Ux86_64_dwarf_find_debug_frame'
> > collect2: ld returned 1 exit status
> > make: *** [perf] Error 1
> >
> >
> > I'm using the latest code from git://git.sv.gnu.org/libunwind.git
> >
> > Looks like dwarf_find_debug_frame is not exported, although
> > it looks like it is based on what I see in libunwind sources ;-)
> >
> > What did I miss?
> libunwind needs to be configured with --enable-debug-frame for the
> debug_frame code to be included in the lib.
> On ARM the flag is always set while it isn't on x86. Here is the
> culprit below (lines from libunwind configure).

yay, thats it!

> 
> Should that be changed in configure along with the changes in tools/perf?

I guess it's ok

Other than that tabs misformating the 'perf tool' change looks ok.

I tested the '.eh_frame' code and it's still working. Once
I figure out how to create a x86 binary with .debug_frame
data I'll test the code itself ;-)

If you could think of any automated testcase for this that could
be added under 'tests' that'd be nice (not necessarily)

thanks,
jirka
