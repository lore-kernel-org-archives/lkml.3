Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752662Ab3F0QCo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 12:02:44 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:46192 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018Ab3F0QCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 12:02:43 -0400
Date: Thu, 27 Jun 2013 18:02:37 +0200
From: Jan Glauber <jan.glauber@gmail.com>
To: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Ambigiuous thread stack annotation in /proc/pid/[s]maps
Message-ID: <20130627160232.GA1748@hal>
References: <20130626114324.GA3538@hal>
 <CAAHN_R1LyhSJE5bAisx39sOyFfRTXQGpCx=CrwQYHWZHSTnOcw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAHN_R1LyhSJE5bAisx39sOyFfRTXQGpCx=CrwQYHWZHSTnOcw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 10:05:41PM +0530, Siddhesh Poyarekar wrote:
> On 26 June 2013 17:13, Jan Glauber <jan.glauber@gmail.com> wrote:
> > Any ideas how that can be fixed? The only solution that comes to my mind
> > is to prevent merging vma's that are used for thread stacks. There is already a
> > flag (MAP_STACK) which is set by the libc for mmap'ing thread stacks but the
> > kernel currently does not care. If the kernel gets an mmap request with
> > MAP_STACK set we could mark the VMA and avoid merging it with others.
> >
> > Unfortunately there seems to be no bit left in the vm_flags to store the
> > MAP_STACK information...
> 
> The annotations essentially point out that the vma contains the stack
> and not that the vma *is* the stack.  We'd get similar output with

But isn't that confusing to the user? At least it is to me. Imagine someone
who uses the maps or smaps output to determine the size of code, data and
stack of a process. Maybe it would be better to not print the stack:tid data
at all if the kernel cannot distinguish the vma's?
Is that behaviour documented anywhere?

> makecontext/getcontext, where the stack may just be a portion of
> memory in another vma.  I don't remember if I had explicitly mentioned
> that during the original discussion.

Never seen that makecontext stuff before. Do you have an example output how
the maps would look like if that is used?

--Jan
 
> Siddhesh
> --
> http://siddhesh.in
