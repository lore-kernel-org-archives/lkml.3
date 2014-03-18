Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932126AbaCROUu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 10:20:50 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:65429 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755328AbaCROUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 10:20:49 -0400
MIME-Version: 1.0
In-Reply-To: <20140318134324.GB3585@infradead.org>
References: <1394808224-113774-1-git-send-email-dzickus@redhat.com>
 <87ob15tx6a.fsf@sejong.aot.lge.com> <20140318134324.GB3585@infradead.org>
From: Namhyung Kim <namhyung@kernel.org>
Date: Tue, 18 Mar 2014 23:20:28 +0900
X-Google-Sender-Auth: TjUhmK57DvqoYvUj40NiJ8tRQZs
Message-ID: <CAM9d7cgxabLGmNN_YhmnN8tkfZmhq2Bww9s=ruT40Wnxg-TY-g@mail.gmail.com>
Subject: Re: [PATCH V2] perf: Speed up thread map generation
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Don Zickus <dzickus@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        jmario@redhat.com, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2014 at 10:43 PM, Arnaldo Carvalho de Melo
<acme@redhat.com> wrote:
> Em Mon, Mar 17, 2014 at 10:45:49AM +0900, Namhyung Kim escreveu:
>> Hi Don,
>>
>> On Fri, 14 Mar 2014 10:43:44 -0400, Don Zickus wrote:
>> > When trying to capture perf data on a system running spejbb2013,
>> > perf hung for about 15 minutes.  This is because it took that
>> > long to gather about 10,000 thread maps and process them.
>> >
>> > I don't think a user wants to wait that long.
>> >
>> > Instead, recognize that thread maps are roughly equivalent to
>> > pid maps and just quickly copy those instead.
>> >
>> > To do this, I synthesize 'fork' events, this eventually calls
>> > thread__fork() and copies the maps over.
>> >
>> > The overhead goes from 15 minutes down to about a few seconds.
>>
>> [SNIP]
>> > @@ -416,6 +453,10 @@ int perf_event__synthesize_threads(struct perf_tool *tool,
>> >     if (mmap_event == NULL)
>> >             goto out_free_comm;
>> >
>> > +   fork_event = malloc(sizeof(fork_event->fork) + machine->id_hdr_size);
>> > +   if (fork_event == NULL)
>> > +           goto out_free_mmap;
>> > +
>> >     if (machine__is_default_guest(machine))
>> >             return 0;
>>
>> Not related to this patch, but this will causes a memory leak..
>> So I think below patch is needed on top (not sure it's also needed for
>> perf_event__synthesize_thread_map() too).
>
> Good catch, applying it, please next time send it under separate cover,
> i.e. not inside another thread.

Okay.  I'll send this kind of patch in a separate thread next time.

Thanks,
Namhyung
