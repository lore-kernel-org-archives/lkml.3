Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418Ab3G3Oz0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 10:55:26 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:39623 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959Ab3G3OzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 10:55:24 -0400
MIME-Version: 1.0
X-Originating-IP: [5.35.97.134]
In-Reply-To: <CAOJe8K1D-=oZW5=Bba+ytGD5fP84caOYUWCCFdzTnQDhToE0Jg@mail.gmail.com>
References: <CAOJe8K1D-=oZW5=Bba+ytGD5fP84caOYUWCCFdzTnQDhToE0Jg@mail.gmail.com>
Date: Tue, 30 Jul 2013 18:55:23 +0400
Message-ID: <CAOJe8K16GOHo6k_44g6AZfZ_Gv9Lt=6orA7XjHobdTaoLYpGcA@mail.gmail.com>
Subject: Re: [build failure] perf
From: Denis Kirjanov <kda@linux-powerpc.org>
To: acme@ghostprotocols.net
Cc: mingo@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CCing linux-kernel

One interesting observation is that perf fails to build on x86 using
gcc 4.1.2 with:
cc1: warnings being treated as errors
util/session.c: In function 'regs_dump__printf':
util/session.c:715: warning: dereferencing type-punned pointer will
break strict-aliasing rules
util/session.c:715: warning: dereferencing type-punned pointer will
break strict-aliasing rules

I was thinking about that something is wrong with u64 datatype but on
the other hand  I can build it on my ppc32 system with gcc  4.5.4...

On 7/29/13, Denis Kirjanov <kda@linux-powerpc.org> wrote:
> Hi,
>
> I'm having a problem compiling perf(mainline 3.11.0-rc3) on the old
> x86 box, probably something wrong with the lex on my system:
>
>     CC util/parse-events.o
> cc1: warnings being treated as errors
> util/parse-events.c: In function 'parse_events__scanner':
> util/parse-events.c:829: warning: implicit declaration of function
> 'parse_events_lex_init_extra'
> util/parse-events.c:829: warning: nested extern declaration of
> 'parse_events_lex_init_extra'
> make: *** [util/parse-events.o] Error 1
>
> Thanks!
>
