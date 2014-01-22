Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887AbaAVOpM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 09:45:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37624 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754545AbaAVOpH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 09:45:07 -0500
Date: Wed, 22 Jan 2014 15:44:53 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf tests: Add install prefix tests
Message-ID: <20140122144453.GB31858@krava.brq.redhat.com>
References: <CA+5PVA7LcDe5Y2RePTFbLdSHd85WhHcHHnFw2mBycfFRJ2m-FQ@mail.gmail.com>
 <CA+5PVA5SWV-pWxfisAVXB-PkARqRsHiaWOne2sXiG7r1D5M6Rg@mail.gmail.com>
 <20140122130211.GB1132@krava.brq.redhat.com>
 <CA+5PVA5QjRbkK2zScYvDj5FcvJ5iTmDWsp3Bhvndv-FYmeQwag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+5PVA5QjRbkK2zScYvDj5FcvJ5iTmDWsp3Bhvndv-FYmeQwag@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 22, 2014 at 09:03:21AM -0500, Josh Boyer wrote:
> On Wed, Jan 22, 2014 at 8:02 AM, Jiri Olsa <jolsa@redhat.com> wrote:
> > On Tue, Jan 21, 2014 at 07:58:41PM -0500, Josh Boyer wrote:
> >> On Tue, Jan 21, 2014 at 3:02 PM, Josh Boyer <jwboyer@fedoraproject.org> wrote:
> >> > Hi All,
> >> >
> >> > I went to build Linux v3.13-737-g7fe67a1 in Fedora this morning and it
> >> > resulted in RPM complaining that the perf and perf.so binaries had
> >>
> >
> > SNIP
> >
> >> I'm not sure why DESTDIR is included in the -DPLUGIN_DIR definition in
> >> tools/lib/traceevent/Makefile, nor why $(prefix) is in plugindir_SQ in
> >> tools/perf/config/Makefile.
> >>
> >> josh
> >>
> >> diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
> >> index 56d52a3..005c9cc 100644
> >> --- a/tools/lib/traceevent/Makefile
> >> +++ b/tools/lib/traceevent/Makefile
> >> @@ -63,7 +63,7 @@ endif
> >>  endif
> >>
> >>  ifeq ($(set_plugin_dir),1)
> >> -PLUGIN_DIR = -DPLUGIN_DIR="$(DESTDIR)/$(plugin_dir)"
> >> +PLUGIN_DIR = -DPLUGIN_DIR="$(plugin_dir)"
> >>  PLUGIN_DIR_SQ = '$(subst ','\'',$(PLUGIN_DIR))'
> >
> > hi,
> > this one needs to stay, otherwise perf have wrong path
> > to load plugins from..
> 
> Hm.  Are you sure?  I believe I tested with just the $(prefix) removed
> below and it still failed the RPM build.  If DESTDIR is included in
> what is passed as DPLUGIN_DIR, it will include the buildroot path in
> the binaries, but when the RPM is installed it does not install to the
> buildroot path.  E.g. you will have:
> 
> -DPLUGIN_DIR="/home/jwboyer/rpmbuild/BUILDROOT/kernel-3.14.0-0.rc0.git1.1.fc21.x86_64//usr/lib64/traceevent/plugins"
> 
> but the plugins will be installed to /usr/lib64/traceevent/plugins by
> RPM.  I'll try again with just the libdir fix, but I'm fairly sure
> what I've said above is correct.  At least in terms of how RPMs are
> built.

ok, now I'm woken up... you're right, both hunks are needed,
got confused with the DESTDIR real meaning, sry

jirka
