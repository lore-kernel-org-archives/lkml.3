Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751833Ab3ASWop (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 17:44:45 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:65039 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064Ab3ASWon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 17:44:43 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Sat, 19 Jan 2013 23:44:42 +0100
Message-ID: <CA+icZUV2Fj4wtObY94s3h5=24dOhcxSuVUNv-qtRXAU5Hi-p1w@mail.gmail.com>
Subject: Re: WARNING: at drivers/tty/tty_buffer.c:476 flush_to_ldisc()
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Dave Jones <davej@redhat.com>
Cc: Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ilya Zykov <ilya@ilyx.ru>, LKML <linux-kernel@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>, linux-serial@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>, Jan Kara <jack@suse.cz>,
        Eric Sandeen <sandeen@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

I suspected after initial testing a problem in TTY and applied two patches.
After more testing the root cause was a problem in JBD2.
A patch from Eric helped!
Follow the thread in [1] for more details.

If you are on Linux-Next (next-20130118) you need the following three patches.

Ilya Zykov (2):
      tty: Correct tty buffer flush.
      tty: Add driver unthrottle in ioctl(...,TCFLSH,..).

Eric Sandeen (1):
      jbd2: don't wake kjournald unnecessarily

Hope this helps you.

Regards,
- Sedat -

[0] http://marc.info/?t=135862023700004&r=1&w=2
[1] http://marc.info/?l=linux-serial&m=135860500714909&w=2
[2] http://git.kernel.org/?p=linux/kernel/git/gregkh/tty.git;a=commitdiff;h=a1bf9584429d61b7096f93ae09325e1ba538e9e8
[3] http://patchwork.ozlabs.org/patch/207237/
