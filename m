Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979AbaLXRio (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 12:38:44 -0500
Received: from mail-lb0-f181.google.com ([209.85.217.181]:51734 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbaLXRin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 12:38:43 -0500
MIME-Version: 1.0
In-Reply-To: <20141224172506.GA23683@amd>
References: <20141224163823.GA17035@amd> <CALCETrW8nrKSZ800C+WaHMK4DCuWnD9TG3dYo7cZwm5j4CpNJQ@mail.gmail.com>
 <20141224172506.GA23683@amd>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 24 Dec 2014 09:38:22 -0800
Message-ID: <CALCETrVP2PtB82x4JFFsXDomNKgRTk_3LoMyyk5KCXN=f8_DJw@mail.gmail.com>
Subject: Re: DRAM unreliable under specific access patern
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 24, 2014 at 9:25 AM, Pavel Machek <pavel@ucw.cz> wrote:
> On Wed 2014-12-24 09:13:32, Andy Lutomirski wrote:
>> On Wed, Dec 24, 2014 at 8:38 AM, Pavel Machek <pavel@ucw.cz> wrote:
>> > Hi!
>> >
>> > It seems that it is easy to induce DRAM bit errors by doing repeated
>> > reads from adjacent memory cells on common hw. Details are at
>> >
>> > https://www.ece.cmu.edu/~safari/pubs/kim-isca14.pdf
>> >
>> > . Older memory modules seem to work better, and ECC should detect
>> > this. Paper has inner loop that should trigger this.
>> >
>> > Workarounds seem to be at hardware level, and tricky, too.
>>
>> One mostly-effective solution would be to stop buying computers
>> without ECC.  Unfortunately, no one seems to sell non-server chips
>> that can do ECC.
>
> Or keep using old computers :-).
>
>> > Does anyone have implementation of detector? Any ideas how to work
>> > around it in software?
>> >
>>
>> Platform-dependent page coloring with very strict, and impossible to
>> implement fully correctly, page allocation constraints?
>
> This seems to be at cacheline level, not at page level, if I
> understand it correctly.
>
> So the problem would is: I have something mapped read-only, and I can
> still cause bitflips in it.
>
> Hmm. So it is pretty obviously a security problem, no need for
> java. Just do some bit flips in binary root is going to run, and it
> will crash for him. You can map binaries read-only, so you have enough
> access.

Right.  So we're mostly screwed.

>
> As far as I understand it, attached program could reproduce it on
> affected machines?

I thought that article suggested using addresses 8M (is that 8
megabytes?) apart for the two accesses.

--Andy

>                                                                         Pavel
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html



-- 
Andy Lutomirski
AMA Capital Management, LLC
