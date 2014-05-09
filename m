Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756870AbaEIPOM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 11:14:12 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:57111 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbaEIPOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 11:14:08 -0400
MIME-Version: 1.0
In-Reply-To: <20140509140536.F06BFE009B@blue.fi.intel.com>
References: <1399552888-11024-1-git-send-email-kirill.shutemov@linux.intel.com>
	<CAMSv6X0+3-uNeiyEPD3sA5dA6Af_M+BT0aeVpa3qMv1aga0q9g@mail.gmail.com>
	<20140508160205.A0EC7E009B@blue.fi.intel.com>
	<CA+55aFw9eiaFtr+c4gcGSWG=pPeqDnX5aPQMVMqX1XkPF30ahg@mail.gmail.com>
	<20140509140536.F06BFE009B@blue.fi.intel.com>
Date: Fri, 9 May 2014 08:14:08 -0700
X-Google-Sender-Auth: eKc8nDbW9M9Td7iPVwzE6uEAdB8
Message-ID: <CA+55aFz9Yo7OC03tKt2wsdd8cDi00yxvMwszrsOsx0ZVEh6zqQ@mail.gmail.com>
Subject: Re: [PATCHv2 0/2] remap_file_pages() decommission
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Armin Rigo <arigo@tunes.org>, Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 9, 2014 at 7:05 AM, Kirill A. Shutemov
<kirill.shutemov@linux.intel.com> wrote:
>
> Hm. I'm confused here. Do we have any limit forced per-user?

Sure we do. See "struct user_struct". We limit max number of
processes, open files, signals etc.

> I only see things like rlimits which are copied from parrent.
> Is it what you want?

No, rlimits are per process (although in some cases what they limit
are counted per user despite the _limits_ of those resources then
being settable per thread).

So I was just thinking that if we raise the per-mm default limits,
maybe we should add a global per-user limit to make it harder for a
user to use tons and toms of vma's.

          Linus
