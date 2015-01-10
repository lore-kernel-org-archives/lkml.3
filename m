Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015AbbAJKqa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 05:46:30 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:49096 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbbAJKq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 05:46:29 -0500
Date: Sat, 10 Jan 2015 11:46:27 +0100
From: Andreas Mohr <andi@lisas.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Lang <david@lang.hm>, "Kirill A. Shutemov" <kirill@shutemov.name>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Langsdorf <mlangsdo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Linux 3.19-rc3
Message-ID: <20150110104627.GA8281@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFy+7+-8CHpmOjRXh1txpABRK3PC+7yZ+fESVAmveOWDyw@mail.gmail.com>
X-Priority: none
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> I dunno. I do know that you definitely don't want to haev a
> desktop/workstation with 64kB pages.

Yet that is what any VirtualAlloc() call on Windows does
(well, not exactly *page* granularity but *allocation* granularity there).
Prime example: do a naively specific/custom VirtualAlloc() request
for a simple string Hello World\0 allocation (11+1 bytes),
get one page (4kB, "Private Data") plus "overhead" (60kB, "Unusable").
--> allocation efficiency: 0.01831%(!).
And that does hurt plenty IME, especially on a 32bit address space's
very limited 2GB/3GB total per Win32 process.

http://blogs.microsoft.co.il/sasha/2014/07/22/tracking-unusable-virtual-memory-vmmap/
"Why is address space allocation granularity 64K?"
  http://blogs.msdn.com/b/oldnewthing/archive/2003/10/08/55239.aspx

One thing less left to wonder why 'doze is such a performance pig...

Andreas Mohr
