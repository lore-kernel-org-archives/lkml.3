Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933465AbaCSAq2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 20:46:28 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:36655 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933312AbaCSAq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 20:46:26 -0400
MIME-Version: 1.0
In-Reply-To: <1395154016-26709-1-git-send-email-jolsa@redhat.com>
References: <1395154016-26709-1-git-send-email-jolsa@redhat.com>
From: Namhyung Kim <namhyung@kernel.org>
Date: Wed, 19 Mar 2014 00:46:06 +0000
X-Google-Sender-Auth: wgMhGnI6dWgG_kb8_KXpysxG9l0
Message-ID: <CAM9d7ciA_R42RQgYtHSnbmuDFMZtu3_D5S-eJ0Q+1zh91krTaA@mail.gmail.com>
Subject: Re: [PATCH 0/6] perf tools: Share map groups within process
To: Jiri Olsa <jolsa@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Don Zickus <dzickus@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Tue, Mar 18, 2014 at 2:46 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> hi,
> this patchset moves thread's map_groups to be dynamically
> allocated and shared within process threads.
>
> The main benefit would be to be able to look up memory
> map from any thread that belongs to the process.
>
> This implements one of the solution ideas for issue
> described by Don in following thread:
> http://marc.info/?l=linux-kernel&m=139403876017159&w=2
>
> RFC changes:
>   - added automated test for thread map groups get/put methods
>   - fix reference count for case described by Namhyung
>   - rename the mmap-events.c test to mmap-thread-lookup.c
>   - added PROT_EXEC to mmap call in tests/mmap-thread-lookup.c
>     as it's not implied by default on all archs (Namhyung)
>   - lazy mg allocation in thread__find_addr_map (Namhyung)
>   - fix compilation failures (Arnaldo)

Looks good to me!

Reviewed-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung
