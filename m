Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062AbaGIAfo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 20:35:44 -0400
Received: from ozlabs.org ([103.22.144.67]:45483 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751151AbaGIAfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 20:35:41 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] scripts/mod/modpost.c: Fix bug in number_prefix
In-Reply-To: <8761jooaw2.fsf@rasmusvillemoes.dk>
References: <1403685999-31013-1-git-send-email-linux@rasmusvillemoes.dk> <53AADC30.7080401@windriver.com> <8761jooaw2.fsf@rasmusvillemoes.dk>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 09 Jul 2014 09:28:43 +0930
Message-ID: <87d2df768c.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rasmus Villemoes <linux@rasmusvillemoes.dk> writes:
> Paul Gortmaker <paul.gortmaker@windriver.com> writes:
>
>> On 14-06-25 04:46 AM, Rasmus Villemoes wrote:
>>> The function number_prefix() can currently only return 1 if its
>>> argument is the empty string: If line 3 is reached and *sym (now the
>>> second character in the argument) is not '.', 0 is returned. However,
>>> if that character is '.', the first assignment to c is that same '.',
>>> which obviously fails to be a digit.
>>
>> I'd suggest you expand the commit log to actually list the end-user
>> visible symptom and the use case that this actually fixes, since it
>> isn't obvious to me at all.
>
> Sorry, it isn't obvious to me either. I just stumbled on it reading the
> code; the rest of modpost.c is too deep magic for me.

The function is horribly mis-named which doesn't help ("number_postfix"
would be closer).

And yes, it's completely broken.

Sam, this never worked, and was clearly never tested.  Seems like we
should just rip out the '$' postfix then, or are you aware of platforms
which have been ignoring modpost complaints since 2008?

Cheers,
Rusty.
