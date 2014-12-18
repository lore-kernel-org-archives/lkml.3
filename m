Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808AbaLRVPg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 16:15:36 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:39518 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230AbaLRVPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 16:15:35 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] checkpatch: Check for use of disallowed macros
Organization: D03
References: <1418381488-25123-1-git-send-email-linux@rasmusvillemoes.dk>
	<1418383004.18092.46.camel@perches.com>
X-Hashcash: 1:20:141218:joe@perches.com::EDcGXdogkrKn2iD6:000ME/
X-Hashcash: 1:20:141218:linux-kernel@vger.kernel.org::t4nXiNh0SQHq6mMe:0000000000000000000000000000000001TWO
Date: Thu, 18 Dec 2014 22:15:28 +0100
In-Reply-To: <1418383004.18092.46.camel@perches.com> (Joe Perches's message of
	"Fri, 12 Dec 2014 03:16:44 -0800")
Message-ID: <87ppbg64nj.fsf@rasmusvillemoes.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12 2014, Joe Perches <joe@perches.com> wrote:

> On Fri, 2014-12-12 at 11:51 +0100, Rasmus Villemoes wrote:
>> Since fe7c36c7 ("Makefile: Build with -Werror=date-time if the
>> compiler supports it"), use of __DATE__, __TIME__, __TIMESTAMP__ has
>> been disallowed. This hasn't prevented a few new users from creeping
>> in. Make checkpatch complain.
>> +
>> +# Use of __DATE__, __TIME__, __TIMESTAMP__ is not allowed
>> +		if ($line =~ m/\b__(?:DATE|TIME|TIMESTAMP)__\b/) {
>> +		    ERROR("DATETIME", "Do not use the macros __DATE__, __TIME__ and __TIMESTAMP__\n" . $herecurr)
>
> I'd probably add that adjacent to the existing __FUNCTION__
> test near line 5000 and make the test show the specific macro
> used.

Yeah, that makes sense. I didn't really know where to put it.

> Maybe add __LINE__ and __FILE__ as a separate --strict test too.

Are those also disallowed, or is it just that new users shouldn't be
added?

> Also the error message should should show the specific macro and
> if __DATE__ and __TIME__ are on the same line, the error should
> be emitted twice.
>
> Maybe:
> 		while ($line =~ /\b(__(?:DATE|TIME|TIMESTAMP)__)\b/g) {
> 			ERROR("DATETIME",
> 			      "Do not use the $1 macro\n" . $herecurr);
> 		}

Looks good to me. I could resend, but can't really claim
authorship. Joe, mind taking it from here?

Rasmus

