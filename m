Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756305AbaDKMCf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 08:02:35 -0400
Received: from mail-qg0-f54.google.com ([209.85.192.54]:61558 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755522AbaDKMCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 08:02:33 -0400
X-Greylist: delayed 614 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Apr 2014 08:02:33 EDT
MIME-Version: 1.0
X-Originating-IP: [46.139.80.5]
In-Reply-To: <20140411115421.GL16119@n2100.arm.linux.org.uk>
References: <1397211951-20549-1-git-send-email-miklos@szeredi.hu>
	<1397211951-20549-3-git-send-email-miklos@szeredi.hu>
	<20140411103351.GJ16119@n2100.arm.linux.org.uk>
	<CAJfpegvZ-n4sT0ojj9iUg_R5gMZHT0caad6TpOdcmF=pdiXkqg@mail.gmail.com>
	<20140411115421.GL16119@n2100.arm.linux.org.uk>
Date: Fri, 11 Apr 2014 14:02:32 +0200
Message-ID: <CAJfpegtenNUCEAJ3SZpQ8NYcdbCeS8pVxaT767szkR1PF8YPNA@mail.gmail.com>
Subject: Re: [PATCH 02/15] arm: __NR_syscalls fix
From: Miklos Szeredi <miklos@szeredi.hu>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arch <linux-arch@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2014 at 1:54 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Fri, Apr 11, 2014 at 01:50:50PM +0200, Miklos Szeredi wrote:
>> On Fri, Apr 11, 2014 at 12:33 PM, Russell King - ARM Linux
>> <linux@arm.linux.org.uk> wrote:
>> > On Fri, Apr 11, 2014 at 12:25:38PM +0200, Miklos Szeredi wrote:
>> >> From: Miklos Szeredi <mszeredi@suse.cz>
>> >>
>> >> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
>> >> Cc: Russell King <linux@arm.linux.org.uk>
>> >> ---
>> >
>> > This has me wondering...
>> >
>> > (a) what you think it fixes
>> > (b) whether you tried to build-test this
>> >
>> > The ARM instruction set supports 8-bit immediate constants with an even
>> > power of two shift.  384 fits that (0x180), 382 does not (0x17e), and
>> > in your following patch, 383 definitely doesn't (0x17f).
>> >
>> > Having this constant larger than necessary does not cause any problem
>> > for the syscall table: we explicitly pad it with calls to sys_ni_syscall
>> > to make up the difference.
>>
>> Yes, and the padding will be of wrong length if NR_syscalls is
>> incorrect (which may be Oopsable?).  At least that is my impression
>> from a casual glance.
>
> Please explain.

Look at ending lines of arch/arm/kernel/calls.S: if  NR_syscalls is a
multiple of 4, then syscalls_padding will be zero.  I.e. no padding
despite the fact that there is in fact only 382 system calls in table
and there should be 2 sys_ni_syscall pads.

So there's some crap in there, for sure.  If it causes actual
problems, I don't know.

Thanks,
Miklos
