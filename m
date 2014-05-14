Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410AbaENVeQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 17:34:16 -0400
Received: from mail-ve0-f169.google.com ([209.85.128.169]:58112 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbaENVeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 17:34:15 -0400
MIME-Version: 1.0
In-Reply-To: <20140514143124.52c598a2ba8e2539ee76558c@linux-foundation.org>
References: <53739201.6080604@oracle.com> <20140514132312.573e5d3cf99276c3f0b82980@linux-foundation.org>
 <5373D509.7090207@oracle.com> <20140514140305.7683c1c2f1e4fb0a63085a2a@linux-foundation.org>
 <5373DBE4.6030907@oracle.com> <20140514143124.52c598a2ba8e2539ee76558c@linux-foundation.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 14 May 2014 14:33:54 -0700
Message-ID: <CALCETrXQOPBOBOgE_snjdmJM7zi34Ei8-MUA-U-YVrwubz4sOQ@mail.gmail.com>
Subject: Re: mm: NULL ptr deref handling mmaping of special mappings
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 2:31 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Wed, 14 May 2014 17:11:00 -0400 Sasha Levin <sasha.levin@oracle.com> wrote:
>
>> > In my linux-next all that code got deleted by Andy's "x86, vdso:
>> > Reimplement vdso.so preparation in build-time C" anyway.  What kernel
>> > were you looking at?
>>
>> Deleted? It appears in today's -next. arch/x86/vdso/vma.c:124 .
>>
>> I don't see Andy's patch removing that code either.
>
> ah, OK, it got moved from arch/x86/vdso/vdso32-setup.c into
> arch/x86/vdso/vma.c.
>
> Maybe you managed to take a fault against the symbol area between the
> _install_special_mapping() and the remap_pfn_range() call, but mmap_sem
> should prevent that.
>
> Or the remap_pfn_range() call never happened.  Should map_vdso() be
> running _install_special_mapping() at all if
> image->sym_vvar_page==NULL?

I'm confused: are we talking about 3.15-rcsomething or linux-next?
That code changed.

Would this all make more sense if there were just a single vma in
here?  cc: Pavel and Cyrill, who might have to deal with this stuff in
CRIU

--Andy

-- 
Andy Lutomirski
AMA Capital Management, LLC
