Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751AbaGIHN0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 03:13:26 -0400
Received: from asavdk3.altibox.net ([109.247.116.14]:38749 "EHLO
	asavdk3.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313AbaGIHNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 03:13:25 -0400
Date: Wed, 9 Jul 2014 09:13:19 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts/mod/modpost.c: Fix bug in number_prefix
Message-ID: <20140709071319.GA30377@ravnborg.org>
References: <1403685999-31013-1-git-send-email-linux@rasmusvillemoes.dk>
 <53AADC30.7080401@windriver.com>
 <8761jooaw2.fsf@rasmusvillemoes.dk>
 <87d2df768c.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d2df768c.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 09:28:43AM +0930, Rusty Russell wrote:
> Rasmus Villemoes <linux@rasmusvillemoes.dk> writes:
> > Paul Gortmaker <paul.gortmaker@windriver.com> writes:
> >
> >> On 14-06-25 04:46 AM, Rasmus Villemoes wrote:
> >>> The function number_prefix() can currently only return 1 if its
> >>> argument is the empty string: If line 3 is reached and *sym (now the
> >>> second character in the argument) is not '.', 0 is returned. However,
> >>> if that character is '.', the first assignment to c is that same '.',
> >>> which obviously fails to be a digit.
> >>
> >> I'd suggest you expand the commit log to actually list the end-user
> >> visible symptom and the use case that this actually fixes, since it
> >> isn't obvious to me at all.
> >
> > Sorry, it isn't obvious to me either. I just stumbled on it reading the
> > code; the rest of modpost.c is too deep magic for me.
> 
> The function is horribly mis-named which doesn't help ("number_postfix"
> would be closer).
number_suffix() - I sometimes mix postfix and suffix.

> 
> And yes, it's completely broken.
> 
> Sam, this never worked, and was clearly never tested.  Seems like we
> should just rip out the '$' postfix then, or are you aware of platforms
> which have been ignoring modpost complaints since 2008?
The architectures that uses -ffunction_sections are sometimes
in a situation where they add a number. And maybe in other cases too.

I still see section mismatch warnings ignored but there are much less
of them these days.
And since this has not worked for years lets rip it out.
If we really need this feature in the future then we can add it back.

Rasmus - will you take care and send a patch that removes this?

Thanks,
	Sam
