Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372AbaAVOD1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 09:03:27 -0500
Received: from mail-oa0-f51.google.com ([209.85.219.51]:51358 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755209AbaAVODY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 09:03:24 -0500
MIME-Version: 1.0
In-Reply-To: <20140122130211.GB1132@krava.brq.redhat.com>
References: <CA+5PVA7LcDe5Y2RePTFbLdSHd85WhHcHHnFw2mBycfFRJ2m-FQ@mail.gmail.com>
	<CA+5PVA5SWV-pWxfisAVXB-PkARqRsHiaWOne2sXiG7r1D5M6Rg@mail.gmail.com>
	<20140122130211.GB1132@krava.brq.redhat.com>
Date: Wed, 22 Jan 2014 09:03:21 -0500
X-Google-Sender-Auth: SnlHoBaL-x9iPuWhj9Z5y29PvoI
Message-ID: <CA+5PVA5QjRbkK2zScYvDj5FcvJ5iTmDWsp3Bhvndv-FYmeQwag@mail.gmail.com>
Subject: Re: [PATCH] perf tests: Add install prefix tests
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 22, 2014 at 8:02 AM, Jiri Olsa <jolsa@redhat.com> wrote:
> On Tue, Jan 21, 2014 at 07:58:41PM -0500, Josh Boyer wrote:
>> On Tue, Jan 21, 2014 at 3:02 PM, Josh Boyer <jwboyer@fedoraproject.org> wrote:
>> > Hi All,
>> >
>> > I went to build Linux v3.13-737-g7fe67a1 in Fedora this morning and it
>> > resulted in RPM complaining that the perf and perf.so binaries had
>>
>
> SNIP
>
>> I'm not sure why DESTDIR is included in the -DPLUGIN_DIR definition in
>> tools/lib/traceevent/Makefile, nor why $(prefix) is in plugindir_SQ in
>> tools/perf/config/Makefile.
>>
>> josh
>>
>> diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
>> index 56d52a3..005c9cc 100644
>> --- a/tools/lib/traceevent/Makefile
>> +++ b/tools/lib/traceevent/Makefile
>> @@ -63,7 +63,7 @@ endif
>>  endif
>>
>>  ifeq ($(set_plugin_dir),1)
>> -PLUGIN_DIR = -DPLUGIN_DIR="$(DESTDIR)/$(plugin_dir)"
>> +PLUGIN_DIR = -DPLUGIN_DIR="$(plugin_dir)"
>>  PLUGIN_DIR_SQ = '$(subst ','\'',$(PLUGIN_DIR))'
>
> hi,
> this one needs to stay, otherwise perf have wrong path
> to load plugins from..

Hm.  Are you sure?  I believe I tested with just the $(prefix) removed
below and it still failed the RPM build.  If DESTDIR is included in
what is passed as DPLUGIN_DIR, it will include the buildroot path in
the binaries, but when the RPM is installed it does not install to the
buildroot path.  E.g. you will have:

-DPLUGIN_DIR="/home/jwboyer/rpmbuild/BUILDROOT/kernel-3.14.0-0.rc0.git1.1.fc21.x86_64//usr/lib64/traceevent/plugins"

but the plugins will be installed to /usr/lib64/traceevent/plugins by
RPM.  I'll try again with just the libdir fix, but I'm fairly sure
what I've said above is correct.  At least in terms of how RPMs are
built.

josh
