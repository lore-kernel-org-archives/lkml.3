Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756019AbaEOVnL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 17:43:11 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:33017 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807AbaEOVnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 17:43:09 -0400
MIME-Version: 1.0
In-Reply-To: <20140515213124.GT28328@moon>
References: <5373DBE4.6030907@oracle.com> <20140514143124.52c598a2ba8e2539ee76558c@linux-foundation.org>
 <CALCETrXQOPBOBOgE_snjdmJM7zi34Ei8-MUA-U-YVrwubz4sOQ@mail.gmail.com>
 <20140514221140.GF28328@moon> <CALCETrUc2CpTEeo=NjLGxXQWHn-HG3uYUo-L3aOU-yVjVx3PGg@mail.gmail.com>
 <20140515084558.GI28328@moon> <CALCETrWwWXEoNparvhx4yJB8YmiUBZCuR6yQxJOTjYKuA8AdqQ@mail.gmail.com>
 <20140515195320.GR28328@moon> <CALCETrWbf8XYvBh=zdyOBqVqRd7s8SVbbDX=O2X+zAZn83r-bw@mail.gmail.com>
 <20140515201914.GS28328@moon> <20140515213124.GT28328@moon>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 15 May 2014 14:42:48 -0700
Message-ID: <CALCETrXe80dx+ODPF1o2iUMOEOO_JAdev4f9gOQ4SUj4JQv36Q@mail.gmail.com>
Subject: Re: mm: NULL ptr deref handling mmaping of special mappings
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 2:31 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> On Fri, May 16, 2014 at 12:19:14AM +0400, Cyrill Gorcunov wrote:
>>
>> I see what you mean. We're rather targeting on bare x86-64 at the moment
>> but compat mode is needed as well (not yet implemented though). I'll take
>> a precise look into this area. Thanks!
>
> Indeed, because we were not running 32bit tasks vdso32-setup.c::arch_setup_additional_pages
> has never been called. That's the mode we will have to implement one day.
>
> Looking forward the question appear -- will VDSO_PREV_PAGES and rest of variables
> be kind of immutable constants? If yes, we could calculate where the additional
> vma lives without requiring any kind of [vdso] mark in proc/pid/maps output.

Please don't!

These might, in principle, even vary between tasks on the same system.
 Certainly the relative positions of the vmas will be different
between 3.15 and 3.16, since we need almost my entire cleanup series
to reliably put them into their 3.16 location.  And I intend to change
the number of pages in 3.16 or 3.17.

--Andy
