Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515Ab3HVWOu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 18:14:50 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:57168 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754465Ab3HVWOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 18:14:48 -0400
MIME-Version: 1.0
In-Reply-To: <1377208659.12003.47.camel@joe-AO722>
References: <20130822214553.GE14837@ld-irv-0074.broadcom.com>
	<1377208659.12003.47.camel@joe-AO722>
Date: Thu, 22 Aug 2013 15:14:47 -0700
Message-ID: <CAN8TOE9AFSVOhP1fazHK_VWZjDtqtd-Co47pGGFVvuS99qNy4A@mail.gmail.com>
Subject: Re: checkpatch.pl: false warning about "-p0 patch"
From: Brian Norris <computersforpeace@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 2:57 PM, Joe Perches <joe@perches.com> wrote:
> On Thu, 2013-08-22 at 14:45 -0700, Brian Norris wrote:
>> Hello,
>
> Hello.
>
>> I have received what appears to be a false warning from checkpatch.pl when
>> checking a patch named 'b':
>>
>>     $ scripts/checkpatch.pl b
>>     WARNING: patch prefix 'b' exists, appears to be a -p0 patch
>>
>>     total: 0 errors, 1 warnings, 16 lines checked
>>
>>     b has style problems, please review.
>>
>>     If any of these errors are false positives, please report
>>     them to the maintainer, see CHECKPATCH in MAINTAINERS.
>>
>> It appears that I can trigger this warning with any arbitrary commit. The
>> following bash script gives me at least one warning for everything in Linus'
>> tree:
>>
>>   for i in {0..100}
>>   do
>>       git format-patch -1 HEAD~$i --stdout > b
>>       scripts/checkpatch.pl b
>>   done
>>
>> I have also seen this warning on patches with other names, but I'm not
>> reproducing that right now.
>
> checkpatch can use stdin as well as files/patches.
>
> Try this instead of creating a temporary file:
>
> for i in {0..100}
> do
>     git format-patch -1 --stdout HEAD~$1 | ./scripts/checkpatch.pl -
> done

Thanks for the tip. This for-loop was just a litmus test to show that
checkpatch.pl is indeed failing simply because of the filename of 'b'.
So I would consider that a checkpatch.pl bug.

But now, I realized the problem is simply with the existence of a file
named 'b'. That is, checkpatch will give a warning for this:

  touch b
  git format-patch -1 --stdout | scripts/checkpatch.pl -
  WARNING: patch prefix 'b' exists, appears to be a -p0 patch

  WARNING: patch prefix 'b' exists, appears to be a -p0 patch

  WARNING: patch prefix 'b' exists, appears to be a -p0 patch
  ...

Is that expected?

Brian
