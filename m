Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705Ab3JJHJE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 03:09:04 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:49923 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598Ab3JJHJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 03:09:01 -0400
Date: Thu, 10 Oct 2013 09:08:58 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 06/52] tools/perf/build: Split out feature check:
 'stackprotector'
Message-ID: <20131010070858.GI10246@gmail.com>
References: <1381227082-22039-1-git-send-email-mingo@kernel.org>
 <1381227082-22039-7-git-send-email-mingo@kernel.org>
 <87hacpk73g.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87hacpk73g.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Namhyung Kim <namhyung@kernel.org> wrote:

> On Tue,  8 Oct 2013 12:10:36 +0200, Ingo Molnar wrote:
> > -ifeq ($(call try-cc,$(SOURCE_HELLO),$(CFLAGS) -Werror -Wstack-protector,-Wstack-protector),y)
> > +ifeq ($(feature-stackprotector), 1)
> >    CFLAGS += -Wstack-protector
> >  endif
> 
> [SNIP]
> 
> > +test-stackprotector:
> > +	$(BUILD) -Werror -fstack-protector
> 
> The flag being checked should be -"W"stack-protector instead of
> -"f"stack-protector.  And the gcc manpage says that -Wstack-protector is
> only active when -fstack-protector is active.  So the end result should
> look like
> 
> 	$(BUILD) -Werror -fstack-protector -Wstack-protector

So, I think this testcase only wanted to check whether GCC knows the 
option or not, right?

Nevertheless I agree that we could add -Wstack-protector to be on the safe 
side, I'll send a patch for that.

Thanks,

	Ingo
