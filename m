Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751598AbaCLSwu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 14:52:50 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:33970 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbaCLSwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 14:52:49 -0400
MIME-Version: 1.0
In-Reply-To: <20140312183925.GA19927@redhat.com>
References: <cover.1394648864.git.luto@amacapital.net> <6a0db396c4b00ab6fee0d091039b549dd761e9b3.1394648864.git.luto@amacapital.net>
 <20140312183925.GA19927@redhat.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 12 Mar 2014 11:52:28 -0700
Message-ID: <CALCETrX4a7jhvZGnULHzqdFaOw+X8OmCAw0Hwu3DvEhSFnh8pA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] x86_32: Remove user bit from identity map PDE
To: Dave Jones <davej@redhat.com>, Andy Lutomirski <luto@amacapital.net>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        X86 ML <x86@kernel.org>, Stefani Seibold <stefani@seibold.net>,
        Andreas Brief <Andreas.Brief@rohde-schwarz.com>,
        Martin Runge <Martin.Runge@rohde-schwarz.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 11:39 AM, Dave Jones <davej@redhat.com> wrote:
> On Wed, Mar 12, 2014 at 11:29:45AM -0700, Andy Lutomirski wrote:
>  > The only reason that the user bit was set was to support userspace
>  > access to the compat vDSO in the fixmap.  The compat vDSO is gone,
>  > so the user bit can be removed.
>  >
>  > -/*
>  > - * For PDE_IDENT_ATTR include USER bit. As the PDE and PTE protection
>  > - * bits are combined, this will alow user to access the high address mapped
>  > - * VDSO in the presence of CONFIG_COMPAT_VDSO
>  > - */
>  >  #define PTE_IDENT_ATTR       0x003          /* PRESENT+RW */
>  > -#define PDE_IDENT_ATTR       0x067          /* PRESENT+RW+USER+DIRTY+ACCESSED */
>  > +#define PDE_IDENT_ATTR       0x063          /* PRESENT+RW+USER+DIRTY+ACCESSED */
>  >  #define PGD_IDENT_ATTR       0x001          /* PRESENT (no other attributes) */
>
> update the comment too ?

Damnit.  I fixed this for the other patchset...

--Andy

>
>         Dave
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
