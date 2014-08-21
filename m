Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312AbaHUXBM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 19:01:12 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:47317 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277AbaHUXBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 19:01:10 -0400
MIME-Version: 1.0
In-Reply-To: <1408641520.23250.71.camel@joe-AO725>
References: <20140821162050.GA1323@www.outflux.net>
	<1408641520.23250.71.camel@joe-AO725>
Date: Thu, 21 Aug 2014 18:01:08 -0500
X-Google-Sender-Auth: NHmCq8rEZr1ZMf8yRAqgX1iwq20
Message-ID: <CAGXu5jJmp4-sposMxjTobEj0xzueQY54OzvdDQg-GC-HhJuBwQ@mail.gmail.com>
Subject: Re: [PATCH] checkpatch: look for common misspellings
From: Kees Cook <keescook@chromium.org>
To: Joe Perches <joe@perches.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andy Whitcroft <apw@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Antti Palosaari <crope@iki.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2014 at 12:18 PM, Joe Perches <joe@perches.com> wrote:
> On Thu, 2014-08-21 at 09:20 -0700, Kees Cook wrote:
>> Check for misspellings, based on Debian's lintian list. Several false
>> positives were removed, and several additional words added that were
>> common in the kernel:
> []
>> diff --git a/MAINTAINERS b/MAINTAINERS
> []
>> @@ -2311,6 +2311,7 @@ M:      Andy Whitcroft <apw@canonical.com>
>>  M:   Joe Perches <joe@perches.com>
>>  S:   Maintained
>>  F:   scripts/checkpatch.pl
>> +F:   scripts/spelling.txt
>
> I don't want to be responsible for misspellings.
>
> Maybe this should be moved to another section
> and you could be added as a maintainer for that.

Okay, sure. Happy to do so. Or maybe some -docs folks want to join me? :)

>
>> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> []
>> +# Check for several spelling mistakes.
>> +             if ($rawline =~ $spelling_re) {
>
> $spelling_re has a rather hidden ( ... ) use so I think
> it'd be better to not use spelling_re at all and have a
> variable like:
> our $misspellings = join('|', @spelling_list);
>
> and also use while so all misspellings are found so this
> could be:
>
>                 while ($rawline =~ /(?:^|$edge)($misspellings)(?:\$|$edge)/g) {
>
>> +                     my $typo = "The word '$1' may be misspelled";
>> +                     $typo .= " (perhaps you want '$spelling_fix{$1}'?)\n";
>> +                     WARN("TYPO_SPELLING", $typo . $herecurr);
>> +             }
>>       }
>
> Seems sensible, but this checks only .c and .h files.
> Any of the Kconfig/.txt files are skipped.

Oh, hm. Yes, seems like this should be relocated then.

> I'd probably leave out "The word "

Fair enough.

> Maybe add a $fix too?
>
> Maybe:
>
>                 while ($rawline =~ /(?:^|$edge)($misspellings)(?:\$|$edge)/g) {
>                         my $typo = $1;
>                         if (WARN("TYPO_SPELLING",
>                                  "$typo may be misspelled - Use '$spelling_fix($typo)'?\n" . $herecurr) &&
>                             $fix) {
>                                 $fixed[$fixlinenr] =~ s/(?:^|$edge)($typo)(?:\$|$edge)/$spelling_fix($typo)/;
>                         }
>                 }
>
>

Cool, let me grok your suggested patch and reply. Thanks for looking this over!

-Kees

-- 
Kees Cook
Chrome OS Security
