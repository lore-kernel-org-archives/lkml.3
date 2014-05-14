Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958AbaENVb1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 17:31:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48332 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418AbaENVb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 17:31:26 -0400
Date: Wed, 14 May 2014 14:31:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, Dave Jones <davej@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: Re: mm: NULL ptr deref handling mmaping of special mappings
Message-Id: <20140514143124.52c598a2ba8e2539ee76558c@linux-foundation.org>
In-Reply-To: <5373DBE4.6030907@oracle.com>
References: <53739201.6080604@oracle.com>
	<20140514132312.573e5d3cf99276c3f0b82980@linux-foundation.org>
	<5373D509.7090207@oracle.com>
	<20140514140305.7683c1c2f1e4fb0a63085a2a@linux-foundation.org>
	<5373DBE4.6030907@oracle.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 May 2014 17:11:00 -0400 Sasha Levin <sasha.levin@oracle.com> wrote:

> > In my linux-next all that code got deleted by Andy's "x86, vdso:
> > Reimplement vdso.so preparation in build-time C" anyway.  What kernel
> > were you looking at?
> 
> Deleted? It appears in today's -next. arch/x86/vdso/vma.c:124 .
> 
> I don't see Andy's patch removing that code either.

ah, OK, it got moved from arch/x86/vdso/vdso32-setup.c into
arch/x86/vdso/vma.c.

Maybe you managed to take a fault against the symbol area between the
_install_special_mapping() and the remap_pfn_range() call, but mmap_sem
should prevent that.

Or the remap_pfn_range() call never happened.  Should map_vdso() be
running _install_special_mapping() at all if
image->sym_vvar_page==NULL?
