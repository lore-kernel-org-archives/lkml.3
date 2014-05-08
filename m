Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454AbaEHPfZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 11:35:25 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:34230 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994AbaEHPfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 11:35:21 -0400
MIME-Version: 1.0
In-Reply-To: <1399552888-11024-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1399552888-11024-1-git-send-email-kirill.shutemov@linux.intel.com>
Date: Thu, 8 May 2014 08:35:20 -0700
X-Google-Sender-Auth: dkWMmzXKiD1hxwcPlKp77px1Zjs
Message-ID: <CA+55aFyQyZM_qKFeThXA=PJzPReb8-VYoKpcrRHP+0UydqqaGw@mail.gmail.com>
Subject: Re: [PATCHv2 0/2] remap_file_pages() decommission
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 8, 2014 at 5:41 AM, Kirill A. Shutemov
<kirill.shutemov@linux.intel.com> wrote:
>
> The second patch replaces remap_file_pages(2) with and emulation. I didn't
> find any real code (apart LTP) to test it on. So I wrote simple test case.
> See commit message for numbers.

I'm certainly ok with this. It removes code even in the "no cleanup of
the core VM" case, and performance doesn't seem to be horrible.

That said, I *really* want to get at least some minimal testing on
something that actually uses it as more than just a test-program. I'm
sure somebody inside RH has to have a 32-bit Oracle setup for
performance testing. Guys?

             Linus
