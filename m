Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648Ab3BUSRn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 13:17:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43713 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755015Ab3BUSRm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 13:17:42 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CA+55aFy4k07GPmszkBdYvCE-KphKLVowkZoW7hoAvcR+0U=stg@mail.gmail.com>
References: <CA+55aFy4k07GPmszkBdYvCE-KphKLVowkZoW7hoAvcR+0U=stg@mail.gmail.com> <30665.1361461678@warthog.procyon.org.uk> <CA+55aFxyuvC1H6doSw_e_yLTey2YGWU9cLnUzxUeT2kaeazydA@mail.gmail.com> <20130221164244.GA19625@srcf.ucam.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dhowells@redhat.com, Matthew Garrett <mjg59@srcf.ucam.org>,
        Josh Boyer <jwboyer@redhat.com>, Peter Jones <pjones@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, Kees Cook <keescook@chromium.org>,
        keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Load keys from signed PE binaries
Date: Thu, 21 Feb 2013 18:17:33 +0000
Message-ID: <567.1361470653@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > There's only one signing authority, and they only sign PE binaries.
> 
> If Red Hat wants to deep-throat Microsoft, that's *your* issue.  That
> has nothing what-so-ever to do with the kernel I maintain. It's
> trivial for you guys to have a signing machine that parses the PE
> binary, verifies the signatures, and signs the resulting keys with
> your own key. You already wrote the code, for chissake, it's in that
> f*cking pull request.

There's a problem with your idea.

 (1) Microsoft's revocation certificates would be based on the hash of the PE
     binary, not the key.

 (2) Re-signing would make the keys then dependent on our master key rather
     than directly on Microsoft's.  Microsoft's revocation certificates[*]
     would then be useless.

 (3) The only way Microsoft could then revoke the extra keys would be to
     revoke our *master* key.

[*] Assuming of course we add support for these.

David
