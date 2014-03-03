Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188AbaCCVwQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 16:52:16 -0500
Received: from mail-vc0-f180.google.com ([209.85.220.180]:37269 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755114AbaCCVwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 16:52:14 -0500
MIME-Version: 1.0
In-Reply-To: <20140303212642.GJ18016@ZenIV.linux.org.uk>
References: <20140303210359.26624.qmail@science.horizon.com>
	<20140303212642.GJ18016@ZenIV.linux.org.uk>
Date: Mon, 3 Mar 2014 13:52:13 -0800
X-Google-Sender-Auth: xomet0GM3GkjnEd8Qa5CEizSYV8
Message-ID: <CA+55aFwdEbMMTPyCEKop0Fukhxi90OCdvDieX7iB-dX9Ziovdg@mail.gmail.com>
Subject: Re: Update of file offset on write() etc. is non-atomic with I/O
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: George Spelvin <linux@horizon.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 3, 2014 at 1:26 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Mon, Mar 03, 2014 at 04:03:59PM -0500, George Spelvin wrote:
>>
>> (If you want to use bits, why not use the two lsbits of the file pointer
>> for the purpose?  That would save a lot of space.)
>
> Most of the cases have it kept separately in registers, actually - there's
> a reason why fdget() and friends are inlined.

Yes. And bit test and set ops on registers are actually cheaper than
playing around with bytes.

That said, the "fget_light()" interface sucks - exactly because it
doesn't do the "return structure in two registers" thing. We should
get rid of it - there's just one remaining user in networking code,
and it should be rewritten in terms of fdget().

That's a separate issue, though.

Oh, and George, your email setup is broken. Gmail thinks your emails
are spam. I'm not sure why (the usual spf problems do not apply), but
it's possibly because your name and email looks made up.

              Linus
