Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932663AbaBFNs0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 08:48:26 -0500
Received: from mail-yh0-f50.google.com ([209.85.213.50]:33221 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756217AbaBFNsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 08:48:24 -0500
Date: Thu, 6 Feb 2014 10:48:17 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 0/3] Fix perf build breakages in 3.13
Message-ID: <20140206134817.GC8026@ghostprotocols.net>
References: <1391648361.3003.97.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391648361.3003.97.camel@deadeye.wl.decadent.org.uk>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Feb 06, 2014 at 12:59:21AM +0000, Ben Hutchings escreveu:
> perf no longer compiles on powerpc and sparc due to changes in the trace
> sub-command.  This series fixes those compile errors; I compile-tested
> in Debian sid on armhf, i386, powerpc and sparc.
> 
> I would much prefer not to revert the tty ioctl decoding but I think
> it's going to take a much more sophisticated approach to do it right
> across all supported architectures.

Second thought on the revert one:

Do you have a problem of switching the big hammer to one that makes this
work just on x86/x86-64?

That way at least those on these arches can have this while the correct
solution is worked out.

- Arnaldo
 
> Ben.
> 
> Ben Hutchings (3):
>   Revert "perf trace: Initial beautifier for ioctl's 'cmd' arg"
>   perf trace: Add fallback definition of EFD_SEMAPHORE
>   perf trace: Decode architecture-specific signal numbers
> 
>  tools/perf/builtin-trace.c | 48 ++++++++++++++--------------------------------
>  1 file changed, 14 insertions(+), 34 deletions(-)
> 
> 
> -- 
> Ben Hutchings
> It is a miracle that curiosity survives formal education. - Albert Einstein


