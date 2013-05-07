Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759129Ab3EGVSJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 17:18:09 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:34286 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756585Ab3EGVSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 17:18:07 -0400
MIME-Version: 1.0
In-Reply-To: <CAOULuObmovvZQDibCJto-KN8DbpQpBwMsmFh1nmXj+hFwE1CaQ@mail.gmail.com>
References: <CAOULuObQq+WPf97LdsD5kN6cq=E9TvaHzqGzdKSWRme-Nk+WQQ@mail.gmail.com>
	<1612326.XDA8n1le4S@vostro.rjw.lan>
	<CAOULuObvuy_iTWp3sgqcvk39eF3KN2X77St=2A6w-BaeokFr2Q@mail.gmail.com>
	<2183106.5nsY0q0PTD@vostro.rjw.lan>
	<CAOULuObmovvZQDibCJto-KN8DbpQpBwMsmFh1nmXj+hFwE1CaQ@mail.gmail.com>
Date: Tue, 7 May 2013 17:18:05 -0400
Message-ID: <CAOULuOZ9gX_iZSN+oZGVq7tkTjbGA+28LnY4stZXRzsvqry+Ug@mail.gmail.com>
Subject: Re: Immediate wakeup after suspend
From: Parag Warudkar <parag.lkml@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>
Cc: Linux PM list <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 6, 2013 at 8:57 PM, Parag Warudkar <parag.lkml@gmail.com> wrote:
> On Mon, May 6, 2013 at 8:45 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>>> I have tried disabling EHC1 and EHC2 without any difference.
>>
>> That may mean one of two things: (1) After you'd tried that they appeared as
>> disabled, but the immediate wakeup still happened or (2) you'd tried to
>> disable them, but they still appeared as enabled.
>>
>> Which one of them is it?
>>
>
> #1 - that is they appeared disabled but the wakeup was still
> immediate. I tried that at least twice before sending the initial
> email and got the immediate wakeups both times but  when I tried to
> recreate this right now with the same kernel and now I get a bunch of
> WARN_ON()s but no immediate wakeups. (I can still wake it up by
> pressing power button.)
> I will test more and also bisect to see what is going on.

So on a hunch I removed radeon UVD firmware to disable UVD from
initializing and the problem goes away.
Turns out, earlier when the problem did not reproduce I was running a
kernel with a local patch that disables UVD.

I have tested this 3 times each - with UVD loaded the machine resumes
instantly. Without it, it works as expected.
I let the radeon/dri people know about it.

Thanks,
Parag
