Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035Ab3LJMeS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 07:34:18 -0500
Received: from mail-ea0-f172.google.com ([209.85.215.172]:41661 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970Ab3LJMeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 07:34:14 -0500
Date: Tue, 10 Dec 2013 13:34:11 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "mingo@elte.hu" <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Ben Cheng <bccheng@google.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH] perf tools: fix bug in usage of the basename() function
Message-ID: <20131210123411.GA31129@gmail.com>
References: <20131205015557.GA13397@quad>
 <20131205085912.GB13377@gmail.com>
 <CABPqkBR8Q=iV_-0O=BNkxCyuu7C3GUjB+ZjQc-Kysux3pE16vA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBR8Q=iV_-0O=BNkxCyuu7C3GUjB+ZjQc-Kysux3pE16vA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephane Eranian <eranian@google.com> wrote:

> >> +     base = strdup(basename(lname));
> >> +
> >> +     free(lname);
> >> +
> >> +     if (!base)
> >> +             return;
> >> +
> >> +     if (dso->sname_alloc)
> >> +             free((char *)dso->short_name);
> >
> > That cast is probably not needed.
> >
> It is with my compiler. It prints out a warning otherwise.

Yeah, see my previous mail, I think having dso->short_name as 'const' 
is a mistake, as there are really just two main usecases for methods 
that operate on 'struct dso':

 - life time affecting (setup/free) methods which need access to all
   fields, which don't want dso->short_name as a const (as evidenced
   by the cast).

 - actual usage methods that get a 'const struct dso' anyway, so they
   don't need dso->short_name as a const.

Thanks,

	Ingo
