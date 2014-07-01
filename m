Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758800AbaGAUHJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 16:07:09 -0400
Received: from mailsec106.isp.belgacom.be ([195.238.20.102]:59867 "EHLO
	mailsec106.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754745AbaGAUHH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 16:07:07 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=0I4RXl3vBzpC9C0LkGzOScdFrA33WtKNJhCMihYJJm8= c=1 sm=2
 a=uHT-V1L4BTMA:10 a=IkcTkHD0fZMA:10 a=IJv9LcIfAAAA:8
 a=cQf-W7nAJlF6Xta0fwsA:9 a=QEXdDO2ut3YA:10 a=K6kUPx8HyhEA:10
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AncFAMoTs1PD7hTU/2dsb2JhbABagw1Sg0ioSQaaSQGBDxZ1hAMBAQQBI1YFCwUEAhgCAhgOAgJXBhMRiCkMkFmcJ4Z/lGgXgSuERIh9MweCd4FMBZwuiX2IPoIAgUQ7
Date: Tue, 1 Jul 2014 22:07:05 +0200 (CEST)
From: Fabian Frederick <fabf@skynet.be>
Reply-To: Fabian Frederick <fabf@skynet.be>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        "Theodore Ts'o" <tytso@mit.edu>
Message-ID: <268827901.224510.1404245225814.open-xchange@webmail.nmp.skynet.be>
In-Reply-To: <1404034438.9064.55.camel@joe-AO725>
References: <1403899823-4461-1-git-send-email-fabf@skynet.be> <1403905024.9064.16.camel@joe-AO725> <20140629112156.6a14ad3599a016a1c05c4771@skynet.be> <1404034438.9064.55.camel@joe-AO725>
Subject: Re: [PATCH 1/1] scripts/checkpatch.pl: update kmalloc_array/kcalloc
 conversion warning
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.2.2-Rev27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> On 29 June 2014 at 11:33 Joe Perches <joe@perches.com> wrote:
>
>
> On Sun, 2014-06-29 at 11:21 +0200, Fabian Frederick wrote:
> > On Fri, 27 Jun 2014 14:37:04 -0700 Joe Perches <joe@perches.com> wrote:
> []
> > > I'm not sure of the value of this as I think at some point
> > > if not already today, the compiler will optimize the multiply
> > > away.
> > >
> > > But it's probably better to look at the non-sizeof variable
> > > and emit the warning only when it's not $Constant or some
> > > upper-case only macro #define like "\b[A-Z_]+\b" is used.
> []
> > > diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> []
> > > +                 }
> > > +                 if ($r1 !~ /^sizeof\b/ && $r2 =~ /^sizeof\s*\S/ &&
> > > +                     !($r1 =~ /^$Constant$/ || $r1 =~ /^[A-Z_]+$/)) {
>
> This last test should be
>
> /^[A-Z_][A-Z0-9_]*$/
>
> to allow upper case macros with digits too
>
> > Already tested ? If not I can do it and give you some feedback ...
>
> Lightly.  Test away.

Tested on rc3: 766 warnings against 976 with original version.

No more warnings for things like:

mm/huge_memory.c
pages = kmalloc(sizeof(struct page *) * HPAGE_PMD_NR, GFP_KERNEL);

net/ipv6/ip6_fib.c
mp = kzalloc(sizeof(u32) * RTAX_MAX, GFP_KERNEL);

lib/sort.c
a = kmalloc(1000 * sizeof(int), GFP_KERNEL);

Looks good.

Fabian

>
>
