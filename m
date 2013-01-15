Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757454Ab3AOA4b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 19:56:31 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:55886 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757096Ab3AOA4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 19:56:30 -0500
Message-ID: <50F4A92F.2070204@linux.vnet.ibm.com>
Date: Mon, 14 Jan 2013 16:56:15 -0800
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: paul.szabo@sydney.edu.au
CC: 695182@bugs.debian.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC] Reproducible OOM with just a few sleeps
References: <201301142036.r0EKaYGN005907@como.maths.usyd.edu.au>
In-Reply-To: <201301142036.r0EKaYGN005907@como.maths.usyd.edu.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011500-3620-0000-0000-000000E5B2CB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2013 12:36 PM, paul.szabo@sydney.edu.au wrote:
> I understand that more RAM leaves less lowmem. What is unacceptable is
> that PAE crashes or freezes with OOM: it should gracefully handle the
> issue. Noting that (for a machine with 4GB or under) PAE fails where the
> HIGHMEM4G kernel succeeds and survives.

You have found a delta, but you're not really making apples-to-apples
comparisons.  The page tables (a huge consumer of lowmem in your bug
reports) have much more overhead on a PAE kernel.  A process with a
single page faulted in with PAE will take at least 4 pagetable pages
(it's 7 in practice for me with sleeps).  It's 2 pages minimum (and in
practice with sleeps) on HIGHMEM4G.

There's probably a bug here.  But, it's incredibly unlikely to be seen
in practice on anything resembling a modern system.  The 'sleep' issue
is easily worked around by upgrading to a 64-bit kernel, or using sane
ulimit values.  Raising the vm.min_free_kbytes sysctl (to perhaps 10x of
its current value on your system) is likely to help the hangs too,
although it will further "consume" lowmem.

I appreciate your persistence here, but for a bug with such a specific
use case, and with so many reasonable workarounds, it's not something I
want to dig in to much deeper.  I'll be happy to answer any questions if
you want to go digging deeper, or want some pointers on where to go
looking to fix this properly.

