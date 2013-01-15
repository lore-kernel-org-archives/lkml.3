Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757698Ab3AOCQp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 21:16:45 -0500
Received: from talus.maths.usyd.edu.au ([129.78.68.1]:51823 "EHLO
	talus.maths.usyd.edu.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757234Ab3AOCQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 21:16:44 -0500
X-smtpdoor-from: psz@maths.usyd.edu.au
X-smtpdoor-want-Message-ID: <201301150216.r0F2GNYW022199@como.maths.usyd.edu.au>
Date: Tue, 15 Jan 2013 13:16:23 +1100
From: paul.szabo@sydney.edu.au
Message-Id: <201301150216.r0F2GNYW022199@como.maths.usyd.edu.au>
To: dave@linux.vnet.ibm.com
Subject: Re: [RFC] Reproducible OOM with just a few sleeps
Cc: 695182@bugs.debian.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <50F4A92F.2070204@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Dave,

>> ... What is unacceptable is that PAE crashes or freezes with OOM:
>> it should gracefully handle the issue. Noting that (for a machine
>> with 4GB or under) PAE fails where the HIGHMEM4G kernel succeeds ...
>
> You have found a delta, but you're not really making apples-to-apples
> comparisons.  The page tables ...

I understand that the exact sizes of page tables are very important to
developers. To the rest of us, all that matters is that the kernel moves
them to highmem or swap or whatever, that it maybe emits some error
message but that it does not crash or freeze.

> There's probably a bug here.  But, it's incredibly unlikely to be seen
> in practice on anything resembling a modern system. ...

Probably, I found the bug on a very modern and brand-new system, just
trying to copy a few ISO image files and trying to log in a hundred
students. My machine crashed under those very practical and normal
circumstances. The demos with dd and sleep were just that: easily
reproducible demos.

> ... easily worked around by upgrading to a 64-bit kernel ...

Do you mean that PAE should never be used, but to use amd64 instead?

> ... Raising the vm.min_free_kbytes sysctl (to perhaps 10x of
> its current value on your system) is likely to help the hangs too,
> although it will further "consume" lowmem.

I have tried that, it did not work. As you say, it is backward.

> ... for a bug with ... so many reasonable workarounds ...

Only one workaround was proposed: use amd64.

PAE is buggy and useless, should be deprecated and removed.

Cheers, Paul

Paul Szabo   psz@maths.usyd.edu.au   http://www.maths.usyd.edu.au/u/psz/
School of Mathematics and Statistics   University of Sydney    Australia
