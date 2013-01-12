Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419Ab3ALUdw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 15:33:52 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:58646 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754059Ab3ALUdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 15:33:51 -0500
MIME-Version: 1.0
In-Reply-To: <CALxABCbLmsg-gt-5MzQJv-Sy1qqnWh-Vr6HUutq=DzNO8M+s1A@mail.gmail.com>
References: <CALxABCau65Zm6qWQCgH+2_4SkojxFPbwwGwytCsiWyyq8bwnRw@mail.gmail.com>
 <Pine.LNX.4.44L0.1301121232510.32458-100000@netrider.rowland.org> <CALxABCbLmsg-gt-5MzQJv-Sy1qqnWh-Vr6HUutq=DzNO8M+s1A@mail.gmail.com>
From: Alex Riesen <raa.lkml@gmail.com>
Date: Sat, 12 Jan 2013 21:33:30 +0100
Message-ID: <CALxABCb1Z5fg4zPfTa5ka7WDjUNZSR4-n4P+fazdQLMD4F5njw@mail.gmail.com>
Subject: Re: USB device cannot be reconnected and khubd "blocked for more than
 120 seconds"
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 12, 2013 at 8:39 PM, Alex Riesen <raa.lkml@gmail.com> wrote:
> On Sat, Jan 12, 2013 at 6:37 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
>> On Sat, 12 Jan 2013, Alex Riesen wrote:
>>> One more detail: I usually use the "noop" elevator. That time it was
>>> the "deadline". And I just reproduced it easily with "deadline".
>>
>> I doubt the elevator has anything to do with this.
>
> But it looks like it does: just using the deadline elevator is a sure way
> to reproduce the bug. The system always recovers (sometimes after a while)
> with "noop".

And no, it does not. Not by itself, but the fact that deadline elevator was
compiled as module certainly helped!

This explains the hanging modprobe in the dmesg output (the part after device
connect). I still wonder, why didn't it froze at boot, mounting SATA devices
(the root, /var, and /home are on an SSD connected by SATA)? And why hanging
khubd at reboot?

Anyway, building the elevator in the kernel avoids the problem. Sorry for
not spotting this earlier.

Now, who would be interested to handle this kind of misconfiguration ...
