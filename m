Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576AbbAPLAo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 06:00:44 -0500
Received: from mta-out1.inet.fi ([62.71.2.227]:48167 "EHLO jenni1.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754153AbbAPLAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 06:00:39 -0500
Date: Fri, 16 Jan 2015 13:00:13 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Calvin Owens <calvinowens@fb.com>,
        Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Peter Feiner <pfeiner@google.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        linux-kernel <linux-kernel@vger.kernel.org>, kernel-team@fb.com
Subject: Re: [RFC][PATCH] procfs: Add /proc/<pid>/mapped_files
Message-ID: <20150116110013.GA29182@node.dhcp.inet.fi>
References: <1421194829-28696-1-git-send-email-calvinowens@fb.com>
 <87oaq1v49z.fsf@rasmusvillemoes.dk>
 <CAAHN_R0AhAc7zt3sfbKdXJEj3Ncd4Hao-1qr=X3mkSjB7F_fYg@mail.gmail.com>
 <87fvbdv2g3.fsf@rasmusvillemoes.dk>
 <20150114210326.GA25159@mail.thefacebook.com>
 <20150114144531.2564398d03c19fd48e4749d9@linux-foundation.org>
 <87y4p4gbu1.fsf@rasmusvillemoes.dk>
 <20150115171543.ac60bc77.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150115171543.ac60bc77.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2015 at 05:15:43PM -0800, Andrew Morton wrote:
> On Thu, 15 Jan 2015 00:51:50 +0100 Rasmus Villemoes <linux@rasmusvillemoes.dk> wrote:
> 
> > > There are still several flags unused in vma.vm_flags btw.
> > >
> > > I'm not sure that we can repurpose vm_pgoff (or vm_private_data) for
> > > this: a badly behaved thread could make its sp point at a random vma
> > > then trick the kernel into scribbling on that vma's vm_proff?
> > 
> > Well, we could still check vm_file for being NULL before writing to
> > vm_pgoff/vm_stack_tid. 
> 
> Yes, I guess that would work.  We'd need to check that nobody else
> is already playing similar games with vm_pgoff.

Well, we do use ->vm_pgoff in anonymous VMAs. For rmap in particular --
vma_address().

-- 
 Kirill A. Shutemov
