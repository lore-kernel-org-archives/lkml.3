Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985AbaEHQI3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 12:08:29 -0400
Received: from mail-ve0-f178.google.com ([209.85.128.178]:62061 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733AbaEHQI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 12:08:28 -0400
MIME-Version: 1.0
In-Reply-To: <20140508160205.A0EC7E009B@blue.fi.intel.com>
References: <1399552888-11024-1-git-send-email-kirill.shutemov@linux.intel.com>
	<CAMSv6X0+3-uNeiyEPD3sA5dA6Af_M+BT0aeVpa3qMv1aga0q9g@mail.gmail.com>
	<20140508160205.A0EC7E009B@blue.fi.intel.com>
Date: Thu, 8 May 2014 09:08:27 -0700
X-Google-Sender-Auth: BapfkOHV5HzsQWA_Vy7IxhA2V20
Message-ID: <CA+55aFw9eiaFtr+c4gcGSWG=pPeqDnX5aPQMVMqX1XkPF30ahg@mail.gmail.com>
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

On Thu, May 8, 2014 at 9:02 AM, Kirill A. Shutemov
<kirill.shutemov@linux.intel.com> wrote:
>
>> i.e. if you remove or
>> emulate remap_file_pages(), please increase the default limit as well.
>
> It's fine to me. Andrew?

Not Andrew, but one thing we might look at is to make the limit
per-user rather than per-vm.

Because the vma limit isn't _just_ about the ELF core dump format
(although the default value for it is), it's also about making it
harder for people to use up tons of kernel memory in non-obvious ways.

(There are possibly also latency issues for process exit or big
munmap, I'm not sure how big a deal that is any more. Our find_vma()
should certainly scale fine, so the most obvious "tons of vma's"
problems are long gone)

               Linus
