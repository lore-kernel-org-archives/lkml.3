Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057Ab3HUNj5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 09:39:57 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:62579 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995Ab3HUNj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 09:39:56 -0400
MIME-Version: 1.0
In-Reply-To: <520B7F6D.2000004@intel.com>
References: <1376484517-5339-1-git-send-email-adrian.hunter@intel.com>
	<1376484517-5339-10-git-send-email-adrian.hunter@intel.com>
	<520B7F6D.2000004@intel.com>
Date: Wed, 21 Aug 2013 15:39:55 +0200
Message-ID: <CABPqkBRDB6_HvBAYNsZu2=VDhqYuzmYym97T7zWdvAVjuQgQQg@mail.gmail.com>
Subject: Re: [PATCH V11 09/15] perf: make events stream always parsable
From: Stephane Eranian <eranian@google.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 14, 2013 at 3:00 PM, Adrian Hunter <adrian.hunter@intel.com> wrote:
> On 14/08/13 15:48, Adrian Hunter wrote:
>> The event stream is not always parsable because the format of a sample
>> is dependent on the sample_type of the selected event.  When there
>> is more than one selected event and the sample_types are not the
>> same then parsing becomes problematic.  A sample can be matched to its
>> selected event using the ID that is allocated when the event is opened.
>> Unfortunately, to get the ID from the sample means first parsing it.
>>
>> This patch adds a new sample format bit PERF_SAMPLE_IDENTIFER that puts
>> the ID at a fixed position so that the ID can be retrieved without
>> parsing the sample.  For sample events, that is the first position
>> immediately after the header.  For non-sample events, that is the last
>> position.
>>
>> In this respect parsing samples requires that the sample_type and ID
>> values are recorded.  For example, perf tools records struct perf_event_attr
>> and the IDs within the perf.data file.  Those must be read first
>> before it is possible to parse samples found later in the perf.data file.
>>
>> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
>
> Forgot to add Peter's ack which is here:
>
>         http://marc.info/?l=linux-kernel&m=137629757013526&w=2

Tested this patch via libpfm4 and per-event branch-stack.
Works well.

Tested-by: Stephane Eranian <eranian@google.com>
