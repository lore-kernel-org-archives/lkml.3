Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733Ab3FZQfo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 12:35:44 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:51670 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516Ab3FZQfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 12:35:42 -0400
MIME-Version: 1.0
In-Reply-To: <20130626114324.GA3538@hal>
References: <20130626114324.GA3538@hal>
Date: Wed, 26 Jun 2013 22:05:41 +0530
Message-ID: <CAAHN_R1LyhSJE5bAisx39sOyFfRTXQGpCx=CrwQYHWZHSTnOcw@mail.gmail.com>
Subject: Re: Ambigiuous thread stack annotation in /proc/pid/[s]maps
From: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
To: Jan Glauber <jan.glauber@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 June 2013 17:13, Jan Glauber <jan.glauber@gmail.com> wrote:
> Any ideas how that can be fixed? The only solution that comes to my mind
> is to prevent merging vma's that are used for thread stacks. There is already a
> flag (MAP_STACK) which is set by the libc for mmap'ing thread stacks but the
> kernel currently does not care. If the kernel gets an mmap request with
> MAP_STACK set we could mark the VMA and avoid merging it with others.
>
> Unfortunately there seems to be no bit left in the vm_flags to store the
> MAP_STACK information...

The annotations essentially point out that the vma contains the stack
and not that the vma *is* the stack.  We'd get similar output with
makecontext/getcontext, where the stack may just be a portion of
memory in another vma.  I don't remember if I had explicitly mentioned
that during the original discussion.

Siddhesh
--
http://siddhesh.in
