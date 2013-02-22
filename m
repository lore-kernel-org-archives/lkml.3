Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758362Ab3BVW5U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 17:57:20 -0500
Received: from mail-la0-f54.google.com ([209.85.215.54]:58189 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757482Ab3BVW5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 17:57:19 -0500
MIME-Version: 1.0
In-Reply-To: <1361571667.2030.13.camel@joe-AO722>
References: <20130222204253.A37B931C1C1@corp2gmr1-1.hot.corp.google.com>
	<1361566784.2030.6.camel@joe-AO722>
	<1361570508.5608.10.camel@thor.lan>
	<1361571667.2030.13.camel@joe-AO722>
Date: Fri, 22 Feb 2013 15:57:16 -0700
Message-ID: <CAKocOONj+gEcBXZJXGqoY00mcUf5WpLo7j7JF-S20UZED+pLCA@mail.gmail.com>
Subject: Re: [PATCH] checkpatch: Improve CamelCase test for Page
From: Shuah Khan <shuahkhan@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Peter Hurley <peter@hurleysoftware.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 22, 2013 at 3:21 PM, Joe Perches <joe@perches.com> wrote:
> On Fri, 2013-02-22 at 17:01 -0500, Peter Hurley wrote:
>> I didn't bother to mention it before, but since your addressing mm
>> CamelCase exceptions, perhaps
>>
>>   xxxx_XXXX
>>   xx_XXX_xxx
>>   XXX_xxx
>>
>> could be exceptions as well?
>
> Maybe the check should only be for "[A-Z][a-z]|[a-z][A-Z]"
> to make '_' and any non-alpha char a name barrier.
>
> So vars like A_foo or b_9A would be acceptable.
>
> Maybe:
>
> ---
>  scripts/checkpatch.pl | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 747bcd7..e08e9f6 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -2929,8 +2929,8 @@ sub process {
>                 while ($line =~ m{($Constant|$Lval)}g) {
>                         my $var = $1;
>                         if ($var !~ /$Constant/ &&
> -                           $var =~ /[A-Z]\w*[a-z]|[a-z]\w*[A-Z]/ &&
> -                           $var !~ /^Page[A-Z]/ &&
> +                           $var =~ /[A-Z][a-z]|[a-z][A-Z]/ &&
> +                           $var !~ /"^(?:Clear|Set|TestClear|TestSet|)Page[A-Z]/ && &&
>                             !defined $camelcase{$var}) {
>                                 $camelcase{$var} = 1;
>                                 WARN("CAMELCASE",
>
>

What are the guidelines on camelcase warnings on patches. A recent one
I ran into is on a variable in a structure and fixing it would require
changing the original variable.

WARNING: Avoid CamelCase: <cp->Header.SGList>
#67: FILE: drivers/scsi/hpsa.c:1409:
+		cp->Header.SGList = 0;

WARNING: Avoid CamelCase: <cp->Header.SGTotal>
#68: FILE: drivers/scsi/hpsa.c:1410:
+		cp->Header.SGTotal = 0;

total: 0 errors, 2 warnings, 11 lines checked

One would have to change a large portion of the code to fix it. In
such cases, do we ignore this warning?

-- Shuah
