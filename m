Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755822AbbAPBP5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 20:15:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33038 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbbAPBP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 20:15:56 -0500
Date: Thu, 15 Jan 2015 17:15:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Calvin Owens <calvinowens@fb.com>,
        Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Peter Feiner <pfeiner@google.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        linux-kernel <linux-kernel@vger.kernel.org>, <kernel-team@fb.com>
Subject: Re: [RFC][PATCH] procfs: Add /proc/<pid>/mapped_files
Message-Id: <20150115171543.ac60bc77.akpm@linux-foundation.org>
In-Reply-To: <87y4p4gbu1.fsf@rasmusvillemoes.dk>
References: <1421194829-28696-1-git-send-email-calvinowens@fb.com>
	<87oaq1v49z.fsf@rasmusvillemoes.dk>
	<CAAHN_R0AhAc7zt3sfbKdXJEj3Ncd4Hao-1qr=X3mkSjB7F_fYg@mail.gmail.com>
	<87fvbdv2g3.fsf@rasmusvillemoes.dk>
	<20150114210326.GA25159@mail.thefacebook.com>
	<20150114144531.2564398d03c19fd48e4749d9@linux-foundation.org>
	<87y4p4gbu1.fsf@rasmusvillemoes.dk>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jan 2015 00:51:50 +0100 Rasmus Villemoes <linux@rasmusvillemoes.dk> wrote:

> > There are still several flags unused in vma.vm_flags btw.
> >
> > I'm not sure that we can repurpose vm_pgoff (or vm_private_data) for
> > this: a badly behaved thread could make its sp point at a random vma
> > then trick the kernel into scribbling on that vma's vm_proff?
> 
> Well, we could still check vm_file for being NULL before writing to
> vm_pgoff/vm_stack_tid. 

Yes, I guess that would work.  We'd need to check that nobody else
is already playing similar games with vm_pgoff.
