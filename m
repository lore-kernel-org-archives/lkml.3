Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816AbaIJOUz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 10:20:55 -0400
Received: from mail-qg0-f42.google.com ([209.85.192.42]:54781 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647AbaIJOUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 10:20:48 -0400
MIME-Version: 1.0
In-Reply-To: <20140910132123.GZ7996@ZenIV.linux.org.uk>
References: <1410340819-18338-1-git-send-email-voytikd@gmail.com> <20140910132123.GZ7996@ZenIV.linux.org.uk>
From: Dmitry Voytik <voytikd@gmail.com>
Date: Wed, 10 Sep 2014 18:20:27 +0400
Message-ID: <CAAX90H1uYKaW_yCZ7tCrhX9s5PzxVaV=6271OxF972pLbOVurg@mail.gmail.com>
Subject: Re: [PATCH] fs: seq_file: optimize seq_pad()
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        linux-kernel@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 5:21 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Wed, Sep 10, 2014 at 01:20:19PM +0400, Dmitry Voytik wrote:
>> Use seq_putc() instead of seq_printf() in seq_pad() because the
>> former is faster.
>
> _Solitary_ seq_putc() is certainly going to be faster, but that loop...
> Do you have profiling results, or is it just an apriori "printf must
> be sloooowwww"?

My fail, sorry. The commit message is little bit wrong. I meant that simple
looping of seq_putc() is faster than seq_printf(). I haven't done profilings.
I just realized that seq_printf() is more complex than simple loop
with seq_putc()
(no need to decode format string as in vsnprintf(), etc).
If I resend the patch with the following commit message:

Use a simple loop with seq_putc() instead of seq_printf() in seq_pad() as
this approach is faster due to less complexity in terms of machine cycles.

Would be it Okay?
Thank you for reviewing.

-- 
Best Regards,
Dmitry Voytik.
voytikd@gmail.com
