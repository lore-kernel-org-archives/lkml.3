Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756259Ab3APPMg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 10:12:36 -0500
Received: from mail-bk0-f51.google.com ([209.85.214.51]:36451 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762Ab3APPMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 10:12:35 -0500
MIME-Version: 1.0
In-Reply-To: <20130116142549.GD1042@krava.brq.redhat.com>
References: <1358257194-8204-1-git-send-email-jolsa@redhat.com>
 <CAOPLpQeHTCwr4tuHi0nORCn+LKJRzEGoCWhC-rj30nLe7bY5Nw@mail.gmail.com> <20130116142549.GD1042@krava.brq.redhat.com>
From: Ulrich Drepper <drepper@gmail.com>
Date: Wed, 16 Jan 2013 10:12:14 -0500
Message-ID: <CAOPLpQcohbB7tekbaezTkKaLVWKaZgMjR-YjCTKxQnix2+pn=A@mail.gmail.com>
Subject: Re: [RFC 0/4] perf tool: Adding ratios support
To: Jiri Olsa <jolsa@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andi Kleen <andi@firstfloor.org>, David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2013 at 9:25 AM, Jiri Olsa <jolsa@redhat.com> wrote:
> I was thinking having config files (global and arch specific)
> comming with perf having predefined formulas.

All the more reason to not mention the file name or really any source
for the definition of the formula in the name,


> 1)  -e 'ratio/branch-rate/'  # special event class
> 2)  -e 'ratio-branch-rate'   # 'ratio-' prefix
> 3)  -e cpu/branch-rate/      # handled like aliases, ratio name would need to be unique
>   ... ?

I think 3 is the most extensible.  Perhaps use the syntax used in
other places.  We have these :u suffixes etc.  Perhaps have :r or :R
or whatever.

Given the other comments, we might want to avoid right away "ratio".
If the mechanism is generalized it could be used to express "counter1
- counter2" for events which cannot be expressed with a single counter
but are not really ratios.
