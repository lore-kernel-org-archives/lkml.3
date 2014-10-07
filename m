Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222AbaJGS6p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 14:58:45 -0400
Received: from mail-oi0-f53.google.com ([209.85.218.53]:34775 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754193AbaJGS6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 14:58:44 -0400
Date: Tue, 7 Oct 2014 13:58:38 -0500
From: Chuck Ebbert <cebbert.lkml@gmail.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>, Stephane Eranian <eranian@google.com>,
        linux-kernel@vger.kernel.org, jolsa@redhat.com, peterz@infradead.org,
        mingo@elte.hu, dsahern@gmail.com
Subject: Re: [PATCH v2] perf tools: fix off-by-one error in maps
Message-ID: <20141007135838.5e3e364c@as>
In-Reply-To: <20141007140050.GB2256@redhat.com>
References: <20141006083532.GA4850@quad>
	<8761fwh1nc.fsf@sejong.aot.lge.com>
	<20141007140050.GB2256@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Oct 2014 11:00:50 -0300
Arnaldo Carvalho de Melo <acme@redhat.com> wrote:

> I keep thinking that this change is making things unclear.
> 
> I.e. the _start_ of a map (map->start) is _in_ the map, and the _end_
> of a map (map->end) is _in_ the map as well.
> 
> 	if (addr > m->end)
> 
> is shorter than:
> 
> 	if (addr >= m->end)
> 
> "start" and "end" should have the same rule applied, i.e. if one is in,
> the other is in as well.
> 
> Etc.
> 

But the convention used in the memory management code is that "end" is
the next byte after the memory region. This gives you:

  size = end - start
  end = start + size

Using a different convention here will just confuse people used to the
way it's done everywhere else.
