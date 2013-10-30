Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732Ab3J3G6K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 02:58:10 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:61972 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379Ab3J3G6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 02:58:09 -0400
MIME-Version: 1.0
In-Reply-To: <1383063623.2713.12.camel@joe-AO722>
References: <CABgQ-Ti0aaxqVGF0R-huQur=EGCTyXM0w-gyz9TenC=msucJqA@mail.gmail.com>
	<1383053609-2895-1-git-send-email-changbin.du@gmail.com>
	<1383063623.2713.12.camel@joe-AO722>
Date: Wed, 30 Oct 2013 14:58:07 +0800
Message-ID: <CABgQ-TisBA4+re7veEyK+F_jfG-mmuXT-R+hdHd1duqsx0qYLQ@mail.gmail.com>
Subject: Re: [PATCH v3] dynamic_debug: add wildcard support to filter files/functions/modules
From: Changbin Du <changbin.du@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Jason Baron <jbaron@akamai.com>,
        "linux-kernel@vger.kernel.org list" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/10/30 Joe Perches <joe@perches.com>:
> On Tue, 2013-10-29 at 21:33 +0800, Du, Changbin wrote:
>> This patch add wildcard '*'(matches zero or more characters) and '?'
>> (matches one character) support when qurying debug flags.
>
> Hi again.  Some trivial notes and a possible logic error:
>

>> +/* check if the string matches given pattern which includes wildcards */
>> +static bool match_pattern(const char *pattern, const char *string)
>> +{
>> +     const char *s = string,
>> +                *p = pattern;
>
> This sort of alignment is pretty unusual.
> Most kernel uses just repeat the type like:
>
>         const char *s = string;
>         const char *p = pattern;
>
I think so.

>> +     bool star = 0;
>
>         bool star = false;
>
>> +
>> +     while (*s) {
>> +             switch (*p) {
>> +             case '?':
>> +                     ++s, ++p;
>> +                     break;
>> +             case '*':
>> +                     star = true;
>> +                     string = s;
>> +                     if (!*++p)
>> +                             return true;
>> +                     pattern = p;;
>
> repeated ;
> Running your patches through checkpatch should find
> this sort of defect.
>

Sorry, it's may fault. I forgot to check it using the tool.

>> +                     break;
>> +             default:
>> +                     if (*s != *p) {
>> +                             if (!star)
>> +                                     return false;
>> +                             string++;
>> +                             s = string;
>> +                             p = pattern;
>> +                             break;
>> +                     }
>> +                     ++s, ++p;
>
> Maybe nicer with an if/else, I think you're still
> missing a reset of "star = false;" and I also think
> it's better to use a break here too.
>
>                 if (*s == *p) {
>                         s++;
>                         p++;
>                         star = false;
>                 } else {
>                         if (!star)
>                                 return false;
>                         string++;
>                         s = string;
>                         p = pattern;
>                 }
>                 break;

I have run loss of test before sending patch. all case passed. But I
will double check if need reset star flag. really thanks!
