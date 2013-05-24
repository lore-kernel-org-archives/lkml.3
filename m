Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759601Ab3EXB3q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 21:29:46 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:48747 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759393Ab3EXB3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 21:29:45 -0400
Message-ID: <519EC282.1010800@gmail.com>
Date: Fri, 24 May 2013 11:29:38 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, milosz@adfin.com,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Is spin_is_locked() safe to use with BUG_ON()/WARN_ON()?
References: <CA+55aFww-UYfLA4cN6MSkeXzmAnAruShddAPegCpn+5yd1HGmQ@mail.gmail.com> <6402.1369320636@warthog.procyon.org.uk> <6788.1369321955@warthog.procyon.org.uk>
In-Reply-To: <6788.1369321955@warthog.procyon.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/05/13 01:12, David Howells wrote:
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
>> We do *not* want to add some crazy "spin_is_nt_locked". We just want
>> to get rid of these idiotic debug tests.
> 
> Generally, I think you are right, though there are also some checks in
> deallocation routines that check that a spinlock is not currently held before
> releasing the memory holding it - should those be allowed to stay?  I'd be
> tempted to wrap the whole check in something, perhaps an "spin_lock_uninit()"
> and move the check to a header file.  Would this be useful for lockdep or
> anything like that?

lockdep has lockdep_assert_held(), which might be what you want. Though
it looks like it possibly also has the false positive issues on SMP?

~Ryan

