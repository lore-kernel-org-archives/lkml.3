Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119Ab3EAQzA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 12:55:00 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:60651 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916Ab3EAQyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 12:54:53 -0400
MIME-Version: 1.0
In-Reply-To: <518145F6.3060800@zytor.com>
References: <3cdeaedaa41e258e8aa9ca83d79a936e0b9462bc.1367385613.git.luto@amacapital.net>
 <20130501113352.GA29571@pd.tnic> <20130501163404.GA6286@thunk.org> <518145F6.3060800@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 1 May 2013 09:54:32 -0700
Message-ID: <CALCETrX0WEGJ0UZz6PyQ4DrnpGg52S0cArDYLQ9Yjz3uic_N4A@mail.gmail.com>
Subject: Re: [PATCH v5] x86: Enable fast strings on Intel if BIOS hasn't already
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Borislav Petkov <bp@alien8.de>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Andrew Lutomirski <luto@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 1, 2013 at 9:42 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 05/01/2013 09:34 AM, Theodore Ts'o wrote:
>>
>> In fact, there is the question of whether we should be checking to see
>> if the CPU stepping is one of the ones with the bug, and if so, to
>> have Linux disable fast strings even if the BIOS didn't, instead of
>> blindly enabling fast strings....
>>
>
> The erratum reads seriously, but it only affects crossings between pages
> of different page types, which is rare in itself.  WT and WP are not
> even used in Linux; the UC case we end up doing 8-byte stores instead of
> the proper size, which is wrong, but for the case where the user is
> malicious the user could just do that directly, and it seems extremely
> hard to envision a scenario where someone would do that intentionally.

(Just my luck.  I'm currently trying to implement WT via PAT by
stealing a slot from either UC or UC-.)

There's already a warning in the Intel system programming manual:

11.5.2.3
Writing Values Across Pages with Different Memory Types
If two adjoining pages in memory have different memory types, and a
word or longer
operand is written to a memory location that crosses the page boundary between
those two pages, the operand might be written to memory twice. This
action does not
present a problem for writes to actual memory; however, if a device is
mapped the
memory space assigned to the pages, the device might malfunction.

Is there any code that memcpys across memory types and expects any
particularly sensible behavior out of it?


I'll try to see what Windows is doing.  From my cursory reading of the
errata documents, this affects basically all CPUs -- it doesn't seem
to have been fixed in any revision of anything.  So this erratum
doesn't seem to explain why different BIOSes would do different
things.


--Andy

P.S. The printk is in the right place in the patch, but the text is
misleading.  I'll fix it if there's a v6.

>
>         -hpa
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
