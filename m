Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338Ab3JYQET (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 12:04:19 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:39700 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957Ab3JYQES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 12:04:18 -0400
Message-ID: <526A967B.6040008@gmail.com>
Date: Fri, 25 Oct 2013 10:04:11 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Arnaldo Melo <acme@ghostprotocols.net>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH] perf session: Add option to copy events when queueing
References: <1378496221-61525-1-git-send-email-dsahern@gmail.com> <20130914161626.GD1718@localhost.localdomain> <CAFTL4hx=ycrepky0P3DYwoFBgknYumW6+tpW7PygqGD2ZNDFqg@mail.gmail.com> <5268F524.20505@gmail.com> <20131024122748.GC6539@ghostprotocols.net> <52691CBD.7050606@gmail.com> <20131024140731.GD6539@ghostprotocols.net>
In-Reply-To: <20131024140731.GD6539@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/13 8:07 AM, Arnaldo Melo wrote:
> What I thought was since we have to allocate memory _somewhere_ we could
> size the ring buffer in such a way that it would be big enough for us to
> leave those referenced entries there, not consumed, till we actually
> consume them when reordering the events, and if we run out of space, the
> kernel would just use LOST records, and not overwrite anything.

The tail pointer should only be moved up once all the events have been 
flushed from the ordered samples queue. Right now the tail is moved up 
when the event is read from the mmap (the patch in the other email 
thread withstanding). The problem is that we do not have any linkage 
between the event and the mmap that it came from; that information is 
lost when the event is added to the ordered samples queue.

David
