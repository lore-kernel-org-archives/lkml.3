Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757622AbaCDULH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:11:07 -0500
Received: from mail-ig0-f171.google.com ([209.85.213.171]:34943 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757602AbaCDULD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:11:03 -0500
MIME-Version: 1.0
In-Reply-To: <20140303233902.GP18016@ZenIV.linux.org.uk>
References: <20140303210359.26624.qmail@science.horizon.com>
	<20140303212642.GJ18016@ZenIV.linux.org.uk>
	<CA+55aFwdEbMMTPyCEKop0Fukhxi90OCdvDieX7iB-dX9Ziovdg@mail.gmail.com>
	<CA+55aFxszctXek3QCXPeDScdSQZvuzp+EXHdA5cZnG3CLeJ1XA@mail.gmail.com>
	<CA+55aFwjSAPx=6x6r9hN_1hH406=TCnAyb=6s0BLt9=YsKy_wA@mail.gmail.com>
	<20140303233902.GP18016@ZenIV.linux.org.uk>
Date: Tue, 4 Mar 2014 21:11:02 +0100
Message-ID: <CALXu0UcdypbLJH9H4Nj2c8BxjmRG6ULHOfDmXAThubzdPMcmEg@mail.gmail.com>
Subject: Re: Update of file offset on write() etc. is non-atomic with I/O
From: Cedric Blancher <cedric.blancher@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        George Spelvin <linux@horizon.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 March 2014 00:39, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Mon, Mar 03, 2014 at 03:23:55PM -0800, Linus Torvalds wrote:
>
>> This just uses a "flags" field, and we currently only have two bits
>> that we use: FDPUT_FPUT and FDPUT_POS_UNLOCK. The first patch knows
>> that "fget_light()" writes 0/1 for that, which is the same as the
>> FDPUT_FPUT bit. I didn't bother to comment on it or clean it up, since
>> the second patch just removes that whole fget_light() mess.
>>
>> Comments?
>
> do_sendfile() is also there and this one is even more unpleasant ;-/
> We probably can ignore that one (until POSIX learns of its existence),
> thouhg...

I've forwarded your request to the Austin Group (who manage the POSIX stuff).

Ced
-- 
Cedric Blancher <cedric.blancher@gmail.com>
Institute Pasteur
