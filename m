Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757568Ab3GWOD5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 10:03:57 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:57231 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757277Ab3GWOD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 10:03:56 -0400
Message-Id: <201307231403.r6NE3max026727@cam-smtp0.cambridge.arm.com>
Date: Tue, 23 Jul 2013 15:03:48 +0100
To: Michal Marek <mmarek@suse.cz>
Cc: "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Problem using gtags target
From: Punit Agrawal <punit.agrawal@arm.com>
Gcc: nnfolder+archive:sent.2013-07
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Marek <mmarek@suse.cz> writes:

> On 8.7.2013 19:22, Punit Agrawal wrote:
>> Hi,
>> 
>> I am trying to use GNU global for kernel source browsing but have run
>> into a problem when using "gtags" target in Makefile. The index
>> files(GTAGS, GSYMS, GPATH, GRTAGS) don't work and on further
>> investigation turned out to be 16kb each in size. My command line is - 
>> 
>> make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- -j5 gtags
>
> So you have a command that fails
>
>> 
>> On some digging, I traced the relevant code to scripts/tags.sh which
>> produces reasonably sized indices (modulo some  missing environment
>> variables) when run as - 
>> 
>> ./scripts/tags.sh gtags
>
> ...and a command that works. So you can start "bisecting" between these
> two: Try removing -j5 or ARCH= or  CROSS_COMPILE= from the make command
> line. Still failing? Add 'printenv >env.make' to the tags.sh script and
> run it via make tags. Compare the env.make file with printenv output
> from the shell. Try setting the variables from env.make in the shell and
> see when ./scripts/tags.sh gtags starts failing.
>

:) I'd already tried without the ARCH and CROSS_COMPILE and was half-way
through trying out the various env options, before I accidentally
discovered what the problem was.

Althought I had the latest version (5.7.1) of the global package (which
gtags is part of), it was only the latest version that my distro (Ubuntu
12.10) provided and not the latest upstream release (6.2.8) for the
package. I should have checked but didn't think it would be so out of
date (more than 3 years) as most packages are quite up-to-date.

Upgrading the binaries to v6.2.8 solved the problem for me along with a
very very nice speed bump while indexing the kernel sources.

> FWIW, both your commands seem to work for me and produce a GRTAGS that
> is 256MB big.
>

My tag files are in the same size range as well.

Hopefully, this thread should make it easier to search for others who
face this issue.

Cheers,
Punit

> Michal
