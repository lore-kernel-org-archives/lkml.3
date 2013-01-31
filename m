Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635Ab3AaVzd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 16:55:33 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:62426 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193Ab3AaVz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 16:55:29 -0500
MIME-Version: 1.0
In-Reply-To: <510AE763.6090907@zytor.com>
References: <20130131005616.1C79F411@kernel.stglabs.ibm.com>
	<510AE763.6090907@zytor.com>
Date: Thu, 31 Jan 2013 13:55:29 -0800
X-Google-Sender-Auth: efn8gtzUQJVB2FRpbz8-5vJ03Z4
Message-ID: <CAE9FiQVn6_QZi3fNQ-JHYiR-7jeDJ5hT0SyT_+zVvfOj=PzF3w@mail.gmail.com>
Subject: Re: [RFC][PATCH] rip out x86_32 NUMA remapping code
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2013 at 1:51 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> I get a build failure on i386 allyesconfig with this patch:
>
> arch/x86/power/built-in.o: In function `swsusp_arch_resume':
> (.text+0x14e4): undefined reference to `resume_map_numa_kva'
>
> It looks trivial to fix up; I assume resume_map_numa_kva() just goes
> away like it does in the non-NUMA case, but it would be nice if you
> could confirm that.

the patches does not seem to complete.

at least, it does not remove

arch/x86/mm/numa.c:     nd = alloc_remap(nid, nd_size);
