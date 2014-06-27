Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959AbaF0ORY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 10:17:24 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:61994 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173AbaF0ORW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 10:17:22 -0400
MIME-Version: 1.0
In-Reply-To: <DDD31947-22E6-44DB-9969-D73D35BB9659@gmail.com>
References: <DDD31947-22E6-44DB-9969-D73D35BB9659@gmail.com>
Date: Fri, 27 Jun 2014 16:17:21 +0200
Message-ID: <CABPqkBTLdX=uFGFqO9NFS6Yiyn+ty5gNj6ta4LdtBBwnygOATA@mail.gmail.com>
Subject: Re: [PERF_EVENT 3.11] Group Multiplexing not Working Properly
From: Stephane Eranian <eranian@google.com>
To: =?UTF-8?B?THXDrXMgVGFuacOnYQ==?= <matallui@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jun 24, 2014 at 7:36 PM, Luís Taniça <matallui@gmail.com> wrote:
> Hi,
>
> I am trying to configure 8 events in a machine which supports only 4 (so, using multiplexing). I tried different approaches:
>
>         1) Configure 8 events independently (works as expected)
>         2) Configure 2 event-sets of 4 events each in counting mode (works as expected)
>         3) Configure 2 event-sets of 4 events each in sampling mode (not working right)
>
What do it mean 'not working' in 3)?
Are you using perf record or your own code?

I think it would help if you could share the exact setup, i.e., the various
struct perf_event_attr structs.

> In case 3) I also tried different approaches:
>
>         3.a) 1 ring-buffer for each event-set and a callback for the POLL signal
>                 - only the first ring-buffer was detecting samples
>                 - the second ring-buffer was empty
>
>         3.b) 1 ring-buffer shared between event-sets (using PERF_EVENT_IOC_SET_OUTPUT)
>                 - both event-sets were writing to the ring-buffer
>                 - 1st event-set only writes 2 samples while 2nd event-set writes like 20+ samples
>                 - samples from 1st event-set report time_enabled=time_running while samples from 2nd don’t
>
> Moreover, in both cases the wakeup_events parameter is not working.
> I believe there must be some programming bugs in perf_event while profiling in sampling mode with multiple event-sets (groups).
>
> Regards,
> matallui
>
>
