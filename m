Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098Ab3ASW56 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 17:57:58 -0500
Received: from mail-qa0-f52.google.com ([209.85.216.52]:35408 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152Ab3ASW54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 17:57:56 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <50FB2364.8090403@redhat.com>
References: <CA+icZUV2Fj4wtObY94s3h5=24dOhcxSuVUNv-qtRXAU5Hi-p1w@mail.gmail.com>
	<50FB2364.8090403@redhat.com>
Date: Sat, 19 Jan 2013 23:57:55 +0100
Message-ID: <CA+icZUXRHAviSZK3bUQgjhCR6-haKMe1kOPuyemmdjSYVW1E1g@mail.gmail.com>
Subject: Re: WARNING: at drivers/tty/tty_buffer.c:476 flush_to_ldisc()
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Dave Jones <davej@redhat.com>, Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ilya Zykov <ilya@ilyx.ru>, LKML <linux-kernel@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>, linux-serial@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>, Jan Kara <jack@suse.cz>,
        "Theodore Ts'o" <tytso@mit.edu>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 19, 2013 at 11:51 PM, Eric Sandeen <sandeen@redhat.com> wrote:
> On 1/19/13 4:44 PM, Sedat Dilek wrote:
>> Hi Dave,
>>
>> I suspected after initial testing a problem in TTY and applied two patches.
>> After more testing the root cause was a problem in JBD2.
>> A patch from Eric helped!
>
> oh, excellent ;)
>
> Helped what, exactly?
>

Fixed a call-trace which I could reproduce running pm_test/freezer
(see [1] "[C.1] TRY TO FORCE THE CALL-TRACE").

- Sedat -

[1] http://marc.info/?l=linux-kernel&m=135862010419101&w=2

>>
 Follow the thread in [1] for more details.
>>
>> If you are on Linux-Next (next-20130118) you need the following three patches.
>>
>> Ilya Zykov (2):
>>       tty: Correct tty buffer flush.
>>       tty: Add driver unthrottle in ioctl(...,TCFLSH,..).
>>
>> Eric Sandeen (1):
>>       jbd2: don't wake kjournald unnecessarily
>
> Hum, I would not have expected this to *matter*, I thought it was just a perf
> optimization.  Hm.  What do you think it fixed, exactly?
>
> (sorry, have not followed that thread, busy elsewhere ATM)
>
> -eric
>
>> Hope this helps you.
>>
>> Regards,
>> - Sedat -
>>
>> [0] http://marc.info/?t=135862023700004&r=1&w=2
>> [1] http://marc.info/?l=linux-serial&m=135860500714909&w=2
>> [2] http://git.kernel.org/?p=linux/kernel/git/gregkh/tty.git;a=commitdiff;h=a1bf9584429d61b7096f93ae09325e1ba538e9e8
>> [3] http://patchwork.ozlabs.org/patch/207237/
>>
>
