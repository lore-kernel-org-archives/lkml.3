Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935364Ab3JPSOI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 14:14:08 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:44128 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934511Ab3JPSOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 14:14:05 -0400
MIME-Version: 1.0
In-Reply-To: <20131016175302.GB4100@infradead.org>
References: <1381416608-2741-1-git-send-email-eranian@google.com>
	<20131010180049.GD9929@pd.tnic>
	<20131016124627.GA2611@gmail.com>
	<CABPqkBRQcisi8ukhD=6fKMq+iqwM+Qgxd3=jo82EUJB5coXs1A@mail.gmail.com>
	<20131016175302.GB4100@infradead.org>
Date: Wed, 16 Oct 2013 20:14:04 +0200
Message-ID: <CABPqkBSs1YwTiy_nkyXc89vg8-Tg=ONqCk930A+ksoLKsGLdHw@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] perf,x86: add Intel RAPL PMU support
From: Stephane Eranian <eranian@google.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>, "Yan, Zheng" <zheng.z.yan@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 7:53 PM, Arnaldo Carvalho de Melo
<acme@redhat.com> wrote:
> Em Wed, Oct 16, 2013 at 03:13:54PM +0200, Stephane Eranian escreveu:
>> On Wed, Oct 16, 2013 at 2:46 PM, Ingo Molnar <mingo@kernel.org> wrote:
>> > We should also tell user-space that the unit of this counter is 'Joule'.
>> >
>> > Then things like:
>> >
>> >         perf stat -a -e power/* sleep 1
>> >
>> > would output, without knowing any RAPL details:
>> >
>> >             0.20619 Joule    power/energy-core
>> >             2.42151 Joule    power/energy-pkg
>> >
>> Not sure there is already some support for this in perf stat. Arnaldo?
>
> Nope, there is not, we would have to have some table somewhere with
> "event-regexp: unit-string"
>
>> If not that we need another sysfs file to export the unit. Another
>> possibility is for perf stat to recognize the power/* and extract the
>> unit from the event name. In my example power/joules-cores -> joules.
>
> I.e. you would be encoding the counter unit as the suffix, might as well
> call it "power/cores.joules" and use the dot as the separator for the
> unit, but would be just a compact form to encode the counter->unit
> table.
>
May be easier to add a sysfs entry with the unit to display.
