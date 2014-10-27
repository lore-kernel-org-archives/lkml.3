Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445AbaJ0VJp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 17:09:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40478 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203AbaJ0VJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 17:09:43 -0400
Date: Mon, 27 Oct 2014 14:09:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, sparclinux@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steve Capper <steve.capper@linaro.org>
Subject: Re: [GIT] Sparc
Message-Id: <20141027140938.142f83a4c3bc6512dd73b54c@linux-foundation.org>
In-Reply-To: <CA+55aFyqtuh53PmwO65NtM_PrPd51=EMWiv8dU8bNTrXL59=Jg@mail.gmail.com>
References: <20141024.133249.71272218161411159.davem@davemloft.net>
	<CA+55aFyqtuh53PmwO65NtM_PrPd51=EMWiv8dU8bNTrXL59=Jg@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Oct 2014 12:47:48 -0700 Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, Oct 24, 2014 at 10:32 AM, David Miller <davem@davemloft.net> wrote:
> >
> >    It's really idiotic to have a weak symbolled fallback that just
> >    returns zero, and causes this kind of bug.  There should be no
> >    backup implementation and the link should fail if the architecture
> >    fails to provide __get_user_pages_fast() and supports transparent
> >    hugepages.
> 
> Agreed. I think the weak fallback is for the "no hugepages support"
> case, but that does sound very annoying and fragile.
> 

Yup.  I'm thinking the get_user_pages_fast() and
__get_user_pages_fast() in mm/util.c should be made non-weak and moved
to mm/nommu.c.

With that change, MMU architctures will need to either define
CONFIG_HAVE_GENERIC_RCU_GUP or implement their own versions.

Perhaps sparc should be defining CONFIG_HAVE_GENERIC_RCU_GUP.

We really should switch x86 to the generic version - from a quick read
it looks like it will work without needing any changes.

Steve, thoughts?
