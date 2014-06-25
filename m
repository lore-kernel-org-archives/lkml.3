Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493AbaFYWwe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 18:52:34 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:48587 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754602AbaFYWwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 18:52:33 -0400
Date: Wed, 25 Jun 2014 15:52:30 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Stefan Bader <stefan.bader@canonical.com>
cc: Heiko Carstens <heiko.carstens@de.ibm.com>, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: fs/stat: Reduce memory requirements for stat_open
In-Reply-To: <53AA746A.3030303@canonical.com>
Message-ID: <alpine.DEB.2.02.1406251551460.4592@chino.kir.corp.google.com>
References: <1402578017-16637-1-git-send-email-stefan.bader@canonical.com> <20140612134149.GC4296@osiris> <5399B301.9030108@canonical.com> <alpine.DEB.2.02.1406241642280.22030@chino.kir.corp.google.com> <53AA746A.3030303@canonical.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jun 2014, Stefan Bader wrote:

> Heiko and I both had the same issue. Since some x86 hardware also reaches a lot
> of CPUs (hyperthreads included), we bumped the possible number of CPUs to 256 at
> least for the 64bit kernel. And that resulted in failed accesses to /proc/stat
> when memory became fragmented.
> So the first patch will avoid this on most systems. I have not seen this myself,
> but I would expect him to be happy with 1/2 already. For really excessive
> hardware 2/2 will close the gap.
> Since this is no critical bug, I am fine with 3.17, too. I have not done so,
> yet, but I could let our reporter try the patches (again, probably not verifying
> the second part). Just waited to do so to see whether the code settles down to
> these changes.
> 

Ok, thanks.  Looks like

proc-stat-convert-to-single_open_size.patch
fs-seq_file-fallback-to-vmalloc-allocation.patch

are destined for 3.17.
