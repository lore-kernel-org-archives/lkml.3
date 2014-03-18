Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569AbaCRQlH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 12:41:07 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:47593 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754330AbaCRQlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 12:41:04 -0400
MIME-Version: 1.0
In-Reply-To: <20140318132355.GA7845@krava.brq.redhat.com>
References: <1395095198-20034-1-git-send-email-artagnon@gmail.com>
 <1395095198-20034-6-git-send-email-artagnon@gmail.com> <878us8rkqq.fsf@sejong.aot.lge.com>
 <20140318132355.GA7845@krava.brq.redhat.com>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Tue, 18 Mar 2014 12:40:23 -0400
Message-ID: <CALkWK0n=Y5VQ0a9uicXjDmJEs5vQHPAeFkbDY3nTVz9HEeRjrg@mail.gmail.com>
Subject: Re: [PATCH 5/5] perf test: squelch warnings about undefined sizeof
To: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Olsa wrote:
>> > Squelch the warnings by explicitly ignoring the sizeof function.
>>
>> It just hides the warning leaving the real problem untouched.  If you
>> really don't want to see those, I guess installing proper plugin for the
>> failing events will help you (in case you didn't).
>
> it wont' help, sizeof is special.. AFAIK we did not figure
> out a way to handle that so far
>
> but I think it was used only in one trace subsystem.. maybe we
> could replace it and forbid to use it in future ;-)

It only seems to be used by xen:

  Warning: [xen:xen_mmu_set_pte] function sizeof not defined
  Warning: [xen:xen_mmu_set_pte_atomic] function sizeof not defined
  Warning: [xen:xen_mmu_set_domain_pte] function sizeof not defined
  Warning: [xen:xen_mmu_set_pte_at] function sizeof not defined
  Warning: [xen:xen_mmu_set_pmd] function sizeof not defined
  Warning: [xen:xen_mmu_set_pud] function sizeof not defined
  Warning: [xen:xen_mmu_set_pgd] function sizeof not defined
  Warning: [xen:xen_mmu_ptep_modify_prot_start] function sizeof not defined
  Warning: [xen:xen_mmu_ptep_modify_prot_commit] function sizeof not defined

These events are defined in include/trace/events/xen.h. Any hints on
how to proceed?
