Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935533Ab3DJWEe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 18:04:34 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:61057 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759724Ab3DJWEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:04:33 -0400
MIME-Version: 1.0
From: Andrew Shewmaker <agshew@gmail.com>
Date: Wed, 10 Apr 2013 16:04:11 -0600
Message-ID: <CAF-E8XEPpbqfytcsz3XGuYf06hOUrkj4rcUaahEFfWA-e4NPhQ@mail.gmail.com>
Subject: Re: [mmotm:master 81/499] WARNING: mm/built-in.o(.text+0x1acc1):
 Section mismatch in reference from the function reserve_mem_notifier() to the
 function .meminit.text:init_user_reserve()
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 12:11 AM, kbuild test robot
<fengguang.wu@intel.com> wrote:
> tree:   git://git.cmpxchg.org/linux-mmotm.git master
> head:   47ca352cea8ba679f803387d208c739131ecb38a
> commit: 992357a07ee0697a1997c2960c3f88d02b2f2753 [81/499] mm: reinititalise user and admin reserves if memory is added or removed
> config: x86_64-randconfig-a00-0410 (attached as .config)
>
> All warnings:
>
>>> WARNING: mm/built-in.o(.text+0x1acc1): Section mismatch in reference from the function reserve_mem_notifier() to the function .meminit.text:init_user_reserve()
>    The function reserve_mem_notifier() references
>    the function __meminit init_user_reserve().
>    This is often because reserve_mem_notifier lacks a __meminit
>    annotation or the annotation of init_user_reserve is wrong.
> --
>>> WARNING: mm/built-in.o(.text+0x1acd8): Section mismatch in reference from the function reserve_mem_notifier() to the function .meminit.text:init_admin_reserve()
>    The function reserve_mem_notifier() references
>    the function __meminit init_admin_reserve().
>    This is often because reserve_mem_notifier lacks a __meminit
>    annotation or the annotation of init_admin_reserve is wrong.

Andrew, am I right in thinking that functions annotated with __meminit may
be discarded? If so, then I should drop the annotation from init_user_reserve()
and init_admin_reserve() since the memory notifier uses them to reinitialize
memory, right?
